import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationService {
  final WebSocketChannel _channel;
  final Function(bool) onNotificationUpdate;

  NotificationService(String url, this.onNotificationUpdate)
      : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        if (data['DT'] != null && data['DT'] is List) {
          onNotificationUpdate(true);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
  }

  void close() {
    _channel.sink.close();
  }
}
