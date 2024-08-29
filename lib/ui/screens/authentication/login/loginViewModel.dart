import 'package:Eventify/data/repository/account/accountRepository.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/data/model/userModel.dart';
import 'package:Eventify/validator/validator.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AccountRepository _accountRepository = AccountRepository();
  RouterService routerService = RouterService();
  String _email = '';
  String _password = '';
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

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;
  set errorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> userLogin() async {
    if (!Validator.isValidEmail(email)) {
      errorMessage = 'Email không hợp lệ';
    }
    if (!Validator.isValidPassword(password)) {
      errorMessage = 'Mật khẩu phải có ít nhất 3 ký tự';
    }
    // final UserModel? user = await _accountRepository.login(email, password);
    final loginResponse = await _accountRepository.login(email, password);
      // final UserModel? user = await _accountRepository.login(email, password);
      // print("loginResponse là ");
      //       print(loginResponse);
      final UserModel? user = UserModel.fromJson(json: loginResponse['DT']);
    if (user == null) {
      errorMessage =
          'Đăng nhập không thành công. Vui lòng kiểm tra lại thông tin.';
      isValidAccount = "invalid";
    } else {
      print("tài khoản valid");
      isValidAccount = 'valid';
    }
    notifyListeners();
  }
}
