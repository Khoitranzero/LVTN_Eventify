import 'package:Eventify/data/api/notificationApiManager.dart';

class NotificationRepository {
  final NotificationApiManager _notificationApiManager = NotificationApiManager();

Future<Map<String, dynamic>> getAllUserNotification(String userId) async {
    try {
      final Map<String, dynamic> getAllUserNotificationMessage = await _notificationApiManager.getAllUserNotification(userId);
      return getAllUserNotificationMessage;
    } catch (e) {
      print("Lỗi hiển thị thông báo $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị thông báo: $e'};
    }
  }


Future<Map<String, dynamic>> createNotifycation(String type,String data,String eventId,String userId) async {
  try {
    final Map<String, dynamic> createNotifycationMessage 
    = await _notificationApiManager.createNotifycation(type,data,eventId,userId);
    return createNotifycationMessage;
  } catch (e) {
    print("Lỗi tạo thông báo: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo thông báo: $e'};
  }
}

 Future<Map<String, dynamic>> readAllNotify(String userId) async {
  try {
    final Map<String, dynamic> readAllNotifyMessage = await _notificationApiManager.readAllNotify(userId);
    return readAllNotifyMessage;
  } catch (e) {
    print("Lỗi đọc tất cả thông báo: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi đọc tất cả thông báo: $e'};
  }
}

 Future<Map<String, dynamic>> readOneNotify(String notifyId,String userId) async {
  try {
    final Map<String, dynamic> readOneNotifyMessage = await _notificationApiManager.readOneNotify(notifyId,userId);
    return readOneNotifyMessage;
  } catch (e) {
    print("Lỗi đọc thông báo: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi đọc thông báo: $e'};
  }
}

Future<Map<String, dynamic>> deleteNotify(String userId,String notifyId) async {
  try {
    final Map<String, dynamic> deleteNotifyMessage = await _notificationApiManager.deleteNotify(userId,notifyId);
    return deleteNotifyMessage;
  } catch (e) {
    print("Lỗi xóa thông báo: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa thông báo: $e'};
  }
}
}