//taskApiManager.dart
import 'dart:convert';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http;

class TaskApiManager {
  Future<Map<String, dynamic>> getAllTaskInEvents(String eventId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getAllTaskInEvents?eventId=$eventId');
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

  Future<Map<String, dynamic>> getSubTaskInEvents(
      String eventId, String parentTaskId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getSubTaskInEvents?eventId=$eventId&parentTaskId=$parentTaskId');
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

  Future<Map<String, dynamic>> getAllTaskStatus() async {
    final url = Uri.parse('${ApiConfig.baseAPI}/task/getAllTaskStatus');
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

  Future<Map<String, dynamic>> getOneTask(String taskId, String userId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getOneTask?taskId=$taskId&userId=$userId');
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

  Future<Map<String, dynamic>> getOneSubTask(
      String taskId, String parentTaskId, String userId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getOneSubTask?taskId=$taskId&parentTaskId=$parentTaskId&userId=$userId');
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

  Future<Map<String, dynamic>> createTask(
    String name,
    String description,
    String startAt,
    String endAt,
    String eventId,
    String parentTaskId,
  ) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/task/createTask');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'name': name,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'eventId': eventId,
      'parentTaskId': parentTaskId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> updateTask(String name, String description,
      String startAt, String endAt, String status, String taskId, String isShow) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/task/updateTask');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'name': name,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'status': status,
      'taskId': taskId,
      'isShow': isShow,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    final url =
        Uri.parse('${ApiConfig.baseAPI}/task/deleteTask?taskId=$taskId');
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

  Future<Map<String, dynamic>> getMemberInTask(String taskId) async {
    final url =
        Uri.parse('${ApiConfig.baseAPI}/task/getMemberInTask?taskId=$taskId');
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

  Future<Map<String, dynamic>> getMemberInSubTask(
      String taskId, String parentTaskId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getMemberInSubTask?taskId=$taskId&parentTaskId=$parentTaskId');
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

  Future<Map<String, dynamic>> addMemberToTask(
      String taskId, String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/task/addMemberToTask');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'taskId': taskId,
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> deleteMemberInTask(
      String taskId, String userId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/deleteMemberInTask?taskId=$taskId&userId=$userId');
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

  Future<Map<String, dynamic>> getMemberAssignSubTask(String taskId) async {
    final url = Uri.parse(
        '${ApiConfig.baseAPI}/task/getMemberAssignSubTask?taskId=$taskId');
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
}
