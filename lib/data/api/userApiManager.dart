//userApiManager.dart
import 'dart:convert';
import 'dart:io';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http ;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';



class UserApiManager {
  
  Future<Map<String, dynamic>> getAllUser(String eventId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/user/getAllUser?eventId=$eventId');
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

  Future<Map<String, dynamic>> getOneUser(String userId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/user/getOneUser?userId=$userId');
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



  Future<Map<String, dynamic>> changeAvatar(String userId, File imageFile) async {
  try {
    final url = Uri.parse('${ApiConfig.baseAPI}/user/changeAvatar');
    final token = await TokenService.getToken();

    var request = http.MultipartRequest('post', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['userId'] = userId;
    var mimeType = lookupMimeType(imageFile.path)!.split('/');
    var file = await http.MultipartFile.fromPath(
      'avatar',
      imageFile.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );
    request.files.add(file);

   var response = await request.send();

if (response.statusCode == 200) {

  var responseData = await response.stream.bytesToString();

  var decodedData = jsonDecode(responseData);
  return decodedData;
} else {
  throw Exception('Failed to change avatar! Status code: ${response.statusCode}');
}
  } catch (e) {
    throw Exception('Failed to send request: $e');
  }
}

  Future<Map<String, dynamic>> updateUser(String name,String phoneNumber,String userId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/user/updateUser');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'name': name,
      'phoneNumber': phoneNumber,
      'userId': userId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

}
