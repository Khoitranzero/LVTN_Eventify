import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  StreamController<String> _messageController = StreamController<String>();

  WebSocketService(this.url);
//Khởi tạo kết nối WebSocket với URL đã cung cấp
  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

// Lắng nghe các sự kiện từ stream của WebSocket:
    _channel!.stream.listen((message) {
      _messageController.add(message);// Khi nhận được tin nhắn, tin nhắn sẽ được thêm vào _messageController.
    }, onDone: () {
      print("WebSocket connection closed");
      reconnect();
    }, onError: (error) {
      print("WebSocket connection error: $error");
      reconnect();
    });
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  Stream<String> get messages => _messageController.stream;

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(status.goingAway);
    }
  }

  void reconnect() {
    print("Reconnecting...");
    Future.delayed(Duration(seconds: 5), () {
      connect();
    });
  }
}
