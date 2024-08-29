import 'dart:io';

import 'package:Eventify/data/api/chatApiManager.dart';


class ChatRepository {
  final ChatApiManager _chatApiManager = ChatApiManager();

Future<Map<String, dynamic>> getUserRoomChat(String userId) async {
    try {
      final Map<String, dynamic> getUserRoomChatMessage = await _chatApiManager.getUserRoomChat(userId);
      return getUserRoomChatMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách phòng chat $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh sách phòng chat: $e'};
    }
  }
Future<Map<String, dynamic>> sendMessage(String eventId,String userId,String messageText) async {
    try {
      final Map<String, dynamic> sendMessage = await _chatApiManager.sendMessage(eventId,userId,messageText);
      return sendMessage;
    } catch (e) {
      print("Lỗi gửi tin nhắn $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi gửi tin nhắn: $e'};
    }
  }

Future<Map<String, dynamic>> sendImage(String eventId,String userId, File? imageFile) async {
    try {
      final Map<String, dynamic> sendImageMessage = await _chatApiManager.sendImage(eventId,userId,imageFile);
      return sendImageMessage;
    } catch (e) {
      print("Lỗi gửi hình ảnh $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi gửi hình ảnh: $e'};
    }
  }

Future<Map<String, dynamic>> getAllMessagesInChatRoom(String eventId) async {
    try {
      final Map<String, dynamic> getAllMessagesInChatRoomMessage = await _chatApiManager.getAllMessagesInChatRoom(eventId);
      return getAllMessagesInChatRoomMessage;
    } catch (e) {
      print("Lỗi hiển thị tin nhắn $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị tin nhắn: $e'};
    }
  }

}