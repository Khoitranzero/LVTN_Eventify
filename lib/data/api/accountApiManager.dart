//userApiManager.dart
import 'dart:convert';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http ;




class AccountApiManager {
   Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/login');

    final response = await http.post(url,
        headers: <String, String>{'ContentType': 'application/json'},
        body: <String, String>{'email': email, 'password': password});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }
     // if (data['EC'] == 0) {
      //   return UserModel.fromJson(json: data['DT']);
      // } else {
      //   throw Exception(data['EM']);
      // }
  Future<String> register(
      String email, String username, String phone, String password) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/register');
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json'
    }, body: <String, String>{
      'email': email,
      'username': username,
      'phone': phone,
      'password': password
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['EC'] == 0) {
        return data['EM'];
      } else if (data['EC'] == 1) {
        return data['EM'];
      }
    } else {
      throw Exception('Đăng ký thất bại!');
    }
    throw Exception();
  }

  Future<Map<String, dynamic>> logout() async {
  final url = Uri.parse('${ApiConfig.baseAPI}/logout');
  final token = await TokenService.getToken();
  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        });
      
       if (response.statusCode == 200) {    
        final data = jsonDecode(response.body);  
        return data;
    }
    else {
     throw Exception('gọi API thất bại!');
  }}

   Future<Map<String, dynamic>> changePassword(
      String email, String oldPassword, String newPassword) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/changePassword');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'email': email,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/sendVerificationCode');
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json'
    }, body: <String, String>{
      'email': email,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> verifyCodeAndChangePassword(
      String email, String code, String newPassword) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/verifyCodeAndChangePassword');
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json'
    }, body: <String, String>{
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }
  
  Future<Map<String, dynamic>> deleteUser(String email) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/deleteUser?email=$email');
    final token = await TokenService.getToken();
    final response = await http.delete(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

}
