// import 'package:Eventify/data/repository/user/userRepository.dart';
// import 'package:Eventify/data/services/routes_service.dart';
// import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
// import 'package:Eventify/ui/screens/home/home_screen.dart';
// import 'package:Eventify/validator/validator.dart';
// import 'package:flutter/material.dart';

// enum ChangePasswordState { none, invalid, valid }

// class ChangePasswordViewModel with ChangeNotifier {
//   final BuildContext context;
//   ChangePasswordViewModel(this.context);
//   final UserRepository _userRepository = UserRepository();
//   ChangePasswordState _changePasswordState = ChangePasswordState.none;
//   ChangePasswordState get changePasswordState => _changePasswordState;

//   Future<void> changePassword(String email, String oldPassword, String newPassword) async {
//   try {
//     if (!Validator.isValidPassword(oldPassword) || !Validator.isValidPassword(newPassword)) {
//       _changePasswordState = ChangePasswordState.invalid;
//       notifyListeners();
//       return;
//     }

//     final result = await _userRepository.changePassword(email, oldPassword, newPassword);

//     if (result['EC'] == 0) {
//       _changePasswordState = ChangePasswordState.valid;
//       UIToastNN.showToast('Đổi mật khẩu thành công');
//     } else {
//       _changePasswordState = ChangePasswordState.invalid;
//       UIToastNN.showToast('Lỗi đổi mật khẩu: ${result['EM']}');
//     }

    
//     if (_changePasswordState ==ChangePasswordState.valid) {
//       Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       // builder: (context) => UserDetail(phone: phone),
//                       builder: (context) => HomeScreen(),
//                     ),);
//     }
//   } catch (e) {
//     print('Lỗi đổi mật khẩu: $e');
//     _changePasswordState = ChangePasswordState.invalid;
//     UIToastNN.showToast('Lỗi đổi mật khẩu: $e');
//   }
//   notifyListeners();
// }

// }
