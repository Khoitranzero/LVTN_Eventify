//chatApiManager.dart
import 'dart:convert';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http;

class NotificationApiManager {


   Future<Map<String, dynamic>> getAllUserNotification(String userId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/notification/getAllUserNotification?userId=$userId');
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


Future<Map<String, dynamic>> createNotifycation(String type,String data,String eventId,String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/notification/createNotify');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'type': type,
      'data': data,
      'eventId': eventId,
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> readAllNotify(String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/notification/readAllNotify');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }


Future<Map<String, dynamic>> readOneNotify(String notifyId,String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/notification/readOneNotify');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'notifyId': notifyId,
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

Future<Map<String, dynamic>> deleteNotify(String userId,String notifyId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/notification/deleteNotify');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'userId': userId,
      'notifyId': notifyId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

}