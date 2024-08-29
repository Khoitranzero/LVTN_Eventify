import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationWebSocket {
  final WebSocketChannel channel;// Thư viện web_socket_channel được sử dụng để kết nối và giao tiếp với một máy chủ WebSocket.

  NotificationWebSocket(String url, Function(String) onMessage)
      : channel = WebSocketChannel.connect(Uri.parse(url)) {
    channel.stream.listen(
      (message) => onMessage(message),//Khi nhận được tin nhắn từ WebSocket, hàm onMessage sẽ được gọi với tham số là tin nhắn nhận được.
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  void send(String message) {
    channel.sink.add(message);//gửi một tin nhắn đến máy chủ WebSocket.
  }

  void close() {
    channel.sink.close();// đóng kết nối WebSocket.
  }
}
