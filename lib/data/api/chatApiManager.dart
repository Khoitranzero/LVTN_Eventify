//chatApiManager.dart
import 'dart:convert';
import 'dart:io';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http;

class ChatApiManager {


  
   Future<Map<String, dynamic>> getUserRoomChat(String userId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/chat/getUserRoomChat?userId=$userId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
    
  }

   Future<Map<String, dynamic>> getAllMessagesInChatRoom(String eventId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/chat/getAllMessagesInChatRoom?eventId=$eventId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
}

    Future<Map<String, dynamic>> sendMessage(String eventId, String userId, String messageText) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/chat/sendMessage');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'userId': userId,
      'messageText': messageText,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }
  Future<Map<String, dynamic>> sendImage(String eventId, String userId, File? imageFile) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/chat/sendImage');
    final token = await TokenService.getToken();
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['eventId'] = eventId;
    request.fields['userId'] = userId;
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }
}