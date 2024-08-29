import 'dart:convert';
import 'dart:io';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/repository/chat/chatRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; 

class ChatRoomScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  const ChatRoomScreen({Key? key, required this.eventId, required this.eventName}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final WebSocketChannel _channel;
  late final AuthProvider _authProvider;
  final ChatRepository _chatRepository = ChatRepository();
  List<types.Message> _messages = [];
  late final types.User _user;
  File? _imageFile;
  final TextEditingController _textController = TextEditingController();
  late final AutoScrollController _scrollController = AutoScrollController();

  bool _isEmpty = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
    _user = types.User(id: _authProvider.id);
    _loadMessages();
  }

  @override
  void initState() {
    super.initState();
     _connectWebSocket();
  }

void _connectWebSocket() {
  _channel = WebSocketChannel.connect(
    Uri.parse('ws://${ApiConfig.ipv4}:8080'),
  );
  _channel.stream.listen((message) {
    try {
      final decodedMessage = jsonDecode(message);
      // print('decodedMessage');
      // print(decodedMessage);
      if (decodedMessage['eventId'] == widget.eventId) {
        final messageContent = decodedMessage['message']['text'];
        final userId = decodedMessage['message']['userId'];
        final user = types.User(id: userId);

        if (messageContent.startsWith('http')) {
           final newMessage = types.ImageMessage(
            author: user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            height: 0.0,
            id: const Uuid().v4(),
            name: 'image',
            size: 0,
            uri: messageContent,
            width: 0.0,
          );
          setState(() {
            _messages.insert(0, newMessage);
          });
         
        } else {
          final newMessage = types.TextMessage(
            author: user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: messageContent,
          );
          setState(() {
            _messages.insert(0, newMessage);
          });
        }
      }
    } catch (e) {
      // Handle error in decoding or processing the message
      print('Error processing WebSocket message: $e');
    }
  });
}




  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }


  void _handleAttachmentPressed() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 70, maxWidth: 1440);

    if (pickedFiles != null) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: pickedFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final image = pickedFiles[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  for (var image in pickedFiles) {
                    final bytes = await image.readAsBytes();
                    final decodedImage = await decodeImageFromList(bytes);

                    final message = types.ImageMessage(
                      author: _user,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                      height: decodedImage.height.toDouble(),
                      id: const Uuid().v4(),
                      name: image.name,
                      size: bytes.length,
                      uri: image.path,
                      width: decodedImage.width.toDouble(),
                    );
                    _imageFile = File(image.path);
                    _handleSendPressed(types.PartialText(text: ''));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Gửi'),
              ),
            ],
          );
        },
      );
    }
  }


   Future<void> _handleSendPressed(types.PartialText message) async {
    final eventId = widget.eventId;
    final userId = _authProvider.id;
    final messageText = message.text;
    try {
      if (_imageFile != null) {
        final response = await _chatRepository.sendImage(
          eventId,
          userId,
          _imageFile,
        );

        final sentMessage = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: 0.0,
          id: const Uuid().v4(),
          name: 'image',
          size: 0,
          uri: response['DT']['text'],
          width: 0.0,
        );
        _channel.sink.add(jsonEncode({
          'eventId': eventId,
          'userId': userId,
          'message': {
            'text': sentMessage.uri,
          },
        }));
        // setState(() {
        //   _messages.insert(0, sentMessage);
        //   _imageFile = null;
        // });
      } else {
        final response = await _chatRepository.sendMessage(
          eventId,
          userId,
          messageText,
        );
        final sentMessage = types.TextMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: messageText,
        );
        _channel.sink.add(jsonEncode({
          'eventId': eventId,
          'userId': userId,
          'message': {
            'text': messageText,
          },
        }));
        // setState(() {
        //   _messages.insert(0, sentMessage);
        // });
      }
    } catch (e) {
      // Handle error if any
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  Future<void> _loadMessages() async {
    try {
      final response = await _chatRepository.getAllMessagesInChatRoom(widget.eventId);
      final messages = (response['DT'] as List).map((msg) {
        final author = types.User(
          id: msg['userId'],
          imageUrl: msg['User']['avatarUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
          lastName: msg['User']['name'],
        );

        if (msg['text'].startsWith('http')) {
          return types.ImageMessage(
            author: types.User(
              id: msg['userId'],
              imageUrl: msg['User']['avatarUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVZ_UtTTn7XHYWqm4YjiSSOSHadVPq66ZCYwuIadDX7JWt4WNSEyXQU34Nxzdd3K6twMY&usqp=CAU',
            ),
            createdAt: DateTime.parse(msg['time']).millisecondsSinceEpoch,
            height: 0.0,
            id: msg['id'],
            name: 'image',
            size: 0,
            uri: msg['text'],
            width: 0.0,
          );
        } else {
          return types.TextMessage(
            author: author,
            createdAt: DateTime.parse(msg['time']).millisecondsSinceEpoch,
            id: msg['id'],
            text: msg['text'],
          );
        }
      }).toList();
      messages.sort((a, b) => (b.createdAt ?? 0).compareTo(a.createdAt ?? 0)); 

      setState(() {
        _messages = messages;
      });
    } catch (e) {
      // Handle error if any
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    _scrollToTop();
  }

  void _scrollToTop() {
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendTextMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      _handleSendPressed(types.PartialText(text: text));
      _textController.clear();
      setState(() {
        _isEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phòng Chat : ${widget.eventName}'),
         leading: IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Chat(
        messages: _messages,
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
        showUserAvatars: true,
        showUserNames: true,
        scrollController: _scrollController, 
        customBottomWidget: CustomInput(
          isEmpty: _isEmpty,
          onChanged: (value) {
            setState(() {
              _isEmpty = value.isEmpty;
            });
          },
          onPressed: _isEmpty ? null : _sendTextMessage,
          textController: _textController,
          onImagesSelected: (List<File> images) async {
            for (var image in images) {
              final bytes = await image.readAsBytes();
              final decodedImage = await decodeImageFromList(bytes);

              final message = types.ImageMessage(
                author: _user,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                height: decodedImage.height.toDouble(),
                id: const Uuid().v4(),
                name: image.path.split('/').last,
                size: bytes.length,
                uri: image.path,
                width: decodedImage.width.toDouble(),
              );
              _imageFile = image;
              _handleSendPressed(types.PartialText(text: ''));
            }
          },
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final bool isEmpty;
  final Function(String) onChanged;
  final VoidCallback? onPressed;
  final TextEditingController textController;
  final Function(List<File>) onImagesSelected; 

  CustomInput({
    required this.isEmpty,
    required this.onChanged,
    required this.onPressed,
    required this.textController,
    required this.onImagesSelected, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.grey[100],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo,color: Colors.blue,),
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFiles = await picker.pickMultiImage(
                imageQuality: 70,
                maxWidth: 1440,
              );

              if (pickedFiles != null) {
                onImagesSelected(pickedFiles.map((file) => File(file.path)).toList());
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: textController,
              onChanged: onChanged,
              decoration: InputDecoration.collapsed(
                hintText: 'Nhập tin nhắn...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: onPressed,
            color: isEmpty ? Colors.grey : Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
