//eventApiManager.dart
import 'dart:convert';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http;

class EventApiManager {
  Future<Map<String, dynamic>> getUserRoleInEvent(
      String eventId, String userId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/event/getUserRoleInEvent?eventId=$eventId&userId=$userId');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> getAllEventStatus() async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/getAllEventStatus');
    final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> getUserEvents(String userId) async {
    final url =
        Uri.parse('${ApiConfig.baseAPI}/event/getUserEvents?userId=$userId');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
        'ContentType': 'application/json',
        'Authorization': 'Bearer $token',
      },
      // body: <String, String>{
      //   'userId': userId,
      // }
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> getAllEventCategory() async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/getAllEventCategory');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> createEvent(
      String eventId,
      String name,
      String location,
      String description,
      String startAt,
      String endAt,
      String categoryId,
      String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/createEvent');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'name': name,
      'location': location,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'categoryId': categoryId,
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> getOneEvent(String eventId) async {
    final url =
        Uri.parse('${ApiConfig.baseAPI}/event/getOneEvent?eventId=$eventId');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> updateEvent(
      String categoryId,
      String name,
      String location,
      String description,
      String startAt,
      String endAt,
      String status,
      String eventId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/updateEvent');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'categoryId': categoryId,
      'name': name,
      'location': location,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'status': status,
      'eventId': eventId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    final url =
        Uri.parse('${ApiConfig.baseAPI}/event/deleteEvent?eventId=$eventId');
    final token = await TokenService.getToken();
    final response = await http.delete(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> getMemberInEvents(String eventId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/event/getMemberInEvents?eventId=$eventId');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> getMemberAssign(
      String eventId, String taskId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/event/getMemberAssign?eventId=$eventId&taskId=$taskId');
    final token = await TokenService.getToken();
    final response = await http.get(
      url,
      headers: <String, String>{
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

  Future<Map<String, dynamic>> addUserToEvent(
      String eventId, String userId, String role) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/addUserToEvent');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'userId': userId,
      'role': role,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> updateUserRole(
      String eventId, String userId, String role) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/event/updateUserRole');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'userId': userId,
      'role': role,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> deleteUserInEvent(
      String eventId, String userId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/event/deleteUserInEvent?eventId=$eventId&userId=$userId');
    final token = await TokenService.getToken();
    final response = await http.delete(
      url,
      headers: <String, String>{
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
}
