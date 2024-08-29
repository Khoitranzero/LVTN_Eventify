import 'package:Eventify/data/api/accountApiManager.dart';

class AccountRepository {
  final AccountApiManager _accountApiManager = AccountApiManager();

Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final Map<String, dynamic> loginMessage = await _accountApiManager.login(email, password);
      return loginMessage;
    } catch (e) {
      print("Lỗi đăng nhập $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi đăng nhập: $e'};
    }
  }
  Future<String> register(
      String email, String username, String phone, String password) async {
    try {
      final registerMessage =
          await _accountApiManager.register(email, username, phone, password);
      return registerMessage;
    } catch (e) {
      return "$e";
    }
  }
  Future<Map<String, dynamic>> logout() async {
    try {
      final Map<String, dynamic> logoutMessage = await _accountApiManager.logout();
      return logoutMessage;
    } catch (e) {
      print("Lỗi đăng xuất $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi đăng xuất: $e'};
    }
  }

Future<Map<String, dynamic>> changePassword(String email, String oldPassword, String newPassword) async {
    try {
      final Map<String, dynamic> changePasswordMessage 
      = await _accountApiManager.changePassword(email, oldPassword, newPassword);
      return changePasswordMessage;
    } catch (e) {
      print("Lỗi đổi mật khẩu $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi khi đổi mật khẩu: $e'};
    }
  }

Future<Map<String, dynamic>> sendVerificationCode(String email) async {
  try {
    final Map<String, dynamic> sendVerificationCodeMessage = await _accountApiManager.sendVerificationCode(email);
    return sendVerificationCodeMessage;
  } catch (e) {
    print("Lỗi gửi mã xác minh: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi khi gửi mã xác minh: $e'};
  }
}
  Future<Map<String, dynamic>> verifyCodeAndChangePassword(String email, String code, String newPassword) async {
      try {
    final Map<String, dynamic>  verifyCodeAndChangePasswordMessage 
    = await _accountApiManager.verifyCodeAndChangePassword(email, code, newPassword);
    return verifyCodeAndChangePasswordMessage;
  } catch (e) {
    print("Lỗi mã xác minh không đúng hoặc đổi mật khẩu thất bại: $e");
       return {'EC': -1, 'EM': 'Đã xảy ra lỗi mã xác minh không đúng hoặc đổi mật khẩu thất bại: $e'};
  }
  }
  
   Future<Map<String, dynamic>> deleteUser(String email) async {
      try {
    final Map<String, dynamic>  deleteUserMessage = await _accountApiManager.deleteUser(email);
    return deleteUserMessage;
  } catch (e) {
    print("Lỗi xóa tài khoản thất bại: $e");
       return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa tài khoản thất bại: $e'};
  }
  }
}
