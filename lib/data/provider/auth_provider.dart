import 'package:Eventify/data/repository/account/accountRepository.dart';
import 'package:Eventify/data/model/userModel.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState { none, invalid, valid }

enum RegisterState { none, invalid, valid }

enum ChangePasswordState { none, invalid, valid }

enum SendVerificationCodeState { none, invalid, valid }

enum VerifyCodeAndChangePasswordState { none, invalid, valid }

class AuthProvider with ChangeNotifier {
  final AccountRepository _accountRepository = AccountRepository();
  String _id = '';
  String _email = '';
  String _fullName = '';
  String _phone = '';
  String _password = '';
  String _oldPassword = '';
  String _newPassword = '';
  String _code = '';
  Map<String, String> _errors = {};
  AuthState _authState = AuthState.none;
  RegisterState _registerState = RegisterState.none;
  ChangePasswordState _changePasswordState = ChangePasswordState.none;
  SendVerificationCodeState _sendVerificationCodeState = SendVerificationCodeState.none;
  VerifyCodeAndChangePasswordState _verifyCodeAndChangePasswordState = VerifyCodeAndChangePasswordState.none;
  bool _isLoggedIn = false;

  AuthProvider({required bool isLoggedIn}) {
    _isLoggedIn = isLoggedIn;
    if (_isLoggedIn) {
      _loadUserData();
    }
  }

  bool get isLoggedIn => _isLoggedIn;

  String get fullName => _fullName;
  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String get id => _id;
  set id(String value) {
    _id = value;
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

  String get oldPassword => _oldPassword;
  set oldPassword(String value) {
    _oldPassword = value;
    notifyListeners();
  }

  String get newPassword => _newPassword;
  set newPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  String get code => _code;
  set code(String value) {
    _code = value;
    notifyListeners();
  }

  // Hàm getter để lấy thông báo lỗi của một trường cụ thể
  String? getError(String field) {
    return _errors[field];
  }

  // Cập nhật thông báo lỗi cho một trường cụ thể
  void setError(String field, String errorMessage) {
    _errors[field] = errorMessage;
    notifyListeners(); // Thông báo rằng dữ liệu đã thay đổi
  }

  // Hàm xóa thông báo lỗi của một trường cụ thể
  void clearError(String field) {
    _errors.remove(field);
    notifyListeners();
  }

  void clearAllError() {
    _errors.clear();
    notifyListeners();
  }

  void setAuthState(AuthState newState) {
    _authState = newState;
    notifyListeners();
  }

  void clearState() {
    _authState = AuthState.none;
    notifyListeners();
  }

  void setRegisterState(RegisterState newState) {
    _registerState = newState;
    notifyListeners();
  }

  void setChangePasswordState(ChangePasswordState newState) {
    _changePasswordState = newState;
    notifyListeners();
  }

  void setSendVerificationCodeState(SendVerificationCodeState newState) {
    _sendVerificationCodeState = newState;
    notifyListeners();
  }

  void setVerifyCodeAndChangePasswordState(
      VerifyCodeAndChangePasswordState newState) {
    _verifyCodeAndChangePasswordState = newState;
    notifyListeners();
  }

  Map<String, String> get errors => _errors;

  AuthState get authState => _authState;

  RegisterState get registerState => _registerState;

  ChangePasswordState get changePasswordState => _changePasswordState;

  SendVerificationCodeState get sendVerificationCodeState =>
      _sendVerificationCodeState;

  VerifyCodeAndChangePasswordState get verifyCodeAndChangePasswordState =>
      _verifyCodeAndChangePasswordState;

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      setError('loginEmptyInfo', "Vui lòng nhập đầy đủ thông tin");
    } else {
      final loginResponse = await _accountRepository.login(email, password);

      if (loginResponse['EC'] != 0) {
        setError('loginFailed', loginResponse['EM']);
        _authState = AuthState.invalid;
      } else if (loginResponse['DT'] is Map<String, dynamic>) {
        final UserModel user = UserModel.fromJson(json: loginResponse['DT']);
        _isLoggedIn = true;
        _id = user.id;
        _email = user.email;
        _fullName = user.fullName ?? '';
        _phone = user.phone ?? '';
        _authState = AuthState.valid;
        await TokenService.saveToken(user.token!);
        await _saveUserData(user);
      } else {
        setError('loginFailed', 'Invalid data format received');
        _authState = AuthState.invalid;
      }
    }
    notifyListeners();
  }

  Future<void> register() async {
    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      setError('registerEmptyInfo', 'Vui lòng nhập đầy đủ thông tin');
    } else {
      final String registerMessage =
          await _accountRepository.register(email, fullName, phone, password);
      if (registerMessage != "Tạo tài khoản thành công") {
        setError('registerFailed', registerMessage);
        _registerState = RegisterState.invalid;
      } else if (registerMessage == "Tạo tài khoản thành công") {
        setError('registerSuccess', registerMessage);
        _registerState = RegisterState.valid;
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      final Map<String, dynamic> logoutResponse =
          await _accountRepository.logout();
      // print("logoutResponse là");
      // print(logoutResponse);
      if (logoutResponse['EC'] != 0) {
        UIToastNN.showToastError(logoutResponse['EM']);
      }
      _isLoggedIn = false;
      _id = '';
      _email = '';
      _fullName = '';
      _phone = '';
      _password = '';
      await TokenService.deleteToken();
      await _clearUserData();
      clearState();
      // _authState = AuthState.invalid;
    } catch (e) {
      print("Lỗi đăng xuất: $e");
    }
  }

  Future<void> changePassword() async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      setError('changePasswordEmptyInfo', 'Vui lòng nhập đầy đủ thông tin');
    } else {
      final Map<String, dynamic> changePasswordMessage =
          await _accountRepository.changePassword(
              email, oldPassword, newPassword);
      if (changePasswordMessage['EC'] == 0) {
        _changePasswordState = ChangePasswordState.valid;
        UIToastNN.showToastSuccess(changePasswordMessage['EM']);
        // setError('sendVerificationCodeFailed', sendVerificationCodeMessage);
      } else {
        _changePasswordState = ChangePasswordState.invalid;
        UIToastNN.showToastError(changePasswordMessage['EM']);
        // setError('sendVerificationCodeSuccess', sendVerificationCodeMessage);
      }
    }
    notifyListeners();
  }

  Future<void> sendVerificationCode() async {
    if (email.isEmpty) {
      setError('sendVerificationCodeEmptyInfo', 'Vui lòng nhập email');
    } else {
      final Map<String, dynamic> sendVerificationCodeMessage =
          await _accountRepository.sendVerificationCode(email);
      if (sendVerificationCodeMessage['EC'] == 0) {
        _sendVerificationCodeState = SendVerificationCodeState.valid;
        UIToastNN.showToastSuccess(sendVerificationCodeMessage['EM']);
        // setError('sendVerificationCodeFailed', sendVerificationCodeMessage);
      } else {
        _sendVerificationCodeState = SendVerificationCodeState.invalid;
        UIToastNN.showToastError(sendVerificationCodeMessage['EM']);
        // setError('sendVerificationCodeSuccess', sendVerificationCodeMessage);
      }
    }
    notifyListeners();
  }

  Future<void> verifyCodeAndChangePassword() async {
    if (code.isEmpty || newPassword.isEmpty) {
      setError(
          'verifyCodeEmptyInfo', 'Vui lòng nhập mã xác minh và mật khẩu mới');
    } else {
      final Map<String, dynamic> verifyCodeAndChangePasswordMessage =
          await _accountRepository.verifyCodeAndChangePassword(
              email, code, newPassword);
      if (verifyCodeAndChangePasswordMessage['EC'] == 0) {
        _verifyCodeAndChangePasswordState =
            VerifyCodeAndChangePasswordState.valid;
        UIToastNN.showToastSuccess(verifyCodeAndChangePasswordMessage['EM']);
        // setError('verifyCodeFailed', verifyCodeAndChangePasswordMessage);
      } else {
        _verifyCodeAndChangePasswordState =
            VerifyCodeAndChangePasswordState.invalid;
        UIToastNN.showToastError(verifyCodeAndChangePasswordMessage['EM']);
        // setError('verifyCodeSuccess', verifyCodeAndChangePasswordMessage);
      }
    }
    notifyListeners();
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setString('email', user.email);
    await prefs.setString('fullName', user.fullName ?? '');
    await prefs.setString('phone', user.phone ?? '');
    await prefs.setString('token', user.token ?? '');
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('id') ?? '';
    _email = prefs.getString('email') ?? '';
    _fullName = prefs.getString('fullName') ?? '';
    _phone = prefs.getString('phone') ?? '';
    final token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      _isLoggedIn = true;
      await TokenService.saveToken(token);
    }
    notifyListeners();
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
