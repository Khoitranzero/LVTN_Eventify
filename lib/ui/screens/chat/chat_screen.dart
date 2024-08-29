import 'package:Eventify/data/repository/chat/chatRepository.dart';
import 'package:Eventify/ui/screens/chat/chatRoom_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RouterService routerService = RouterService();
  ChatRepository chatRepository = ChatRepository();
  List<ChatRoomItem> chatRoomItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllUserChatRoom();
  }

  Future<void> fetchAllUserChatRoom() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await chatRepository.getUserRoomChat(authProvider.id);

      if (response['EC'] == 0) {
        setState(() {
          chatRoomItems = (response['DT'] as List)
              .map((chatRoom) => ChatRoomItem(
                    name: chatRoom['eventName'],
                    members: chatRoom['userCount'],
                    chatRooomId: chatRoom['chatRoomId'],
                    eventId: chatRoom['eventId'],
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        // Handle error case
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void navigateToChatRoomDetail(String eventId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          eventId: eventId,
          eventName: name
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchAllUserChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Danh sách phòng chat'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: chatRoomItems.length,
                  itemBuilder: (context, index) {
                    return UIChatRoomItem(
                      chatRoom: chatRoomItems[index],
                      onTap: () => navigateToChatRoomDetail(
                          chatRoomItems[index].eventId,chatRoomItems[index].name ),
                    );
                  },
                ),
              ));
  }
}

class ChatRoomItem {
  final String name;
  final int members;
  final String chatRooomId;
  final String eventId;

  ChatRoomItem({
    required this.name,
    required this.members,
    required this.chatRooomId,
    required this.eventId,
  });
}

class UIChatRoomItem extends StatelessWidget {
  final ChatRoomItem chatRoom;
  final VoidCallback onTap;

  UIChatRoomItem({required this.chatRoom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.forum_rounded, color: Colors.blue),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Phòng : ${chatRoom.name}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.blue),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.groups_sharp, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "Số thành viên : ${chatRoom.members}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
