import 'dart:io';
import 'package:Eventify/data/api/userApiManager.dart';

class UserRepository {
  final UserApiManager _userApiManager = UserApiManager();

  Future<Map<String, dynamic>> getAllUser(String eventId) async {
    try {
      final Map<String, dynamic> getAllUserMessage = await _userApiManager.getAllUser(eventId);
      return getAllUserMessage;
    } catch (e) {
      print("Lỗi hiển thị lấy tất cả user $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy tất cả user: $e'};
    }
  }
  Future<Map<String, dynamic>> getOneUser(String userId) async {
    try {
      final Map<String, dynamic> getOneUserMessage = await _userApiManager.getOneUser(userId);
      return getOneUserMessage;
    } catch (e) {
      print("Lỗi hiển thị user $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị user: $e'};
    }
  }

   Future<Map<String, dynamic>> changeAvatar(String userId, File imageFile) async {
    try {
      final Map<String, dynamic> changeAvatarMessage = await _userApiManager.changeAvatar(userId,imageFile);
      return changeAvatarMessage;
    } catch (e) {
      print("Lỗi đổi avatar $e");
      return {'EC': -1, 'EM': 'Đã xảy ra : $e'};
    }
  }

   Future<Map<String, dynamic>> updateUser(String name,String phoneNumber,String userId) async {
  try {
    final Map<String, dynamic> updateUserMessage = await _userApiManager.updateUser(name, phoneNumber, userId);
    return updateUserMessage;
  } catch (e) {
    print("Lỗi cập nhật user: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật user: $e'};
  }
}
}
