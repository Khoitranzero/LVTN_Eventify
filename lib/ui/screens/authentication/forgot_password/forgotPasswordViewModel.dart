import 'package:Eventify/data/services/routes_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  RouterService routerService = RouterService();
  String _email = '';
  String _code = '';
  String _newPassword = '';
  String _errorMessage = '';
  String? _isValidAccount;
  String get isValidAccount => _isValidAccount ?? '';
  set isValidAccount(String value) {
    _isValidAccount = value;
    notifyListeners();
  }

 String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get code => _code;
  set code(String value) {
    _code = value;
    notifyListeners();
  }
 String get newPassword => _newPassword;
  set newPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }
  String get errorMessage => _errorMessage;
  set errorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

//    Future<void> sendVerificationCode() async {
//   if (!Validator.isValidEmail(email)) {
//     errorMessage = 'Email không hợp lệ';
//     notifyListeners(); 
//     return;
//   }

//   final result = await _userRepository.sendVerificationCode(email);
//   if (result == "Gửi mã xác minh thành công") {
//     errorMessage = '';
//   } else {
//     errorMessage = result as String;
//   }
//   notifyListeners(); 
// }
//   Future<void> verifyCodeAndChangePassword() async {
//   if (!Validator.isValidPassword(newPassword)) {
//     errorMessage = 'Mật khẩu mới không hợp lệ';
//     notifyListeners(); 
//     return;
//   }

//   final result = await _userRepository.verifyCodeAndChangePassword(email, code, newPassword);
//   if (result == "Đổi mật khẩu thành công") {
//     errorMessage = '';
//   } else {
//     errorMessage = result;
//   }
//   notifyListeners(); 
// }

}
