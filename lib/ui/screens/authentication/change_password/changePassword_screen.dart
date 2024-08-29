import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIButtonNN.dart';
import 'package:Eventify/ui/component/molcules/UITextInputFormNN.dart';
import 'package:Eventify/ui/screens/authentication/wave.dart';
import 'package:Eventify/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // late ChangePasswordViewModel _changePasswordViewModel;
  FocusNode? _oldPasswordFocusNode;
  FocusNode? _newPasswordFocusNode;
  //AuthProvider authProvider = AuthProvider();
  RouterService routerService = RouterService();

  @override
  void initState() {
    super.initState();
    _oldPasswordFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
    // _changePasswordViewModel = ChangePasswordViewModel(context);
  }

  @override
  void dispose() {
    _oldPasswordFocusNode?.dispose();
    _newPasswordFocusNode?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // authProvider.clearError();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Đổi mật khẩu"),
       leading: IconButton(
          icon: Icon(Icons.keyboard_double_arrow_left),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              const Wave(),
              const SizedBox(height: 50),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/icon/ic_custom_launcher.png'),
              ),
              const SizedBox(height: 20),
              UITextInputFormNN(
                icon: Icons.lock,
                label: "Mật khẩu cũ",
                focusNode: _oldPasswordFocusNode,
                onChanged: (value) {
                  authProvider.oldPassword = value;
                  if (!Validator.isValidPassword(value)) {
                    authProvider.setError(
                        'oldPassword', 'Mật khẩu cũ không hợp lệ');
                  } else {
                    authProvider.clearError('oldPassword');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                  (auth) => auth.getError('oldPassword'),
                ), keyboardType: '',
              ),
              UITextInputFormNN(
                icon: Icons.lock,
                label: "Mật khẩu mới",
                focusNode: _newPasswordFocusNode,
                onChanged: (value) {
                  authProvider.newPassword = value;
                  if (!Validator.isValidPassword(value)) {
                    authProvider.setError(
                        'newPassword', 'Mật khẩu mới không hợp lệ');
                  } else {
                    authProvider.clearError('newPassword');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                  (auth) => auth.getError('newPassword'),
                ), keyboardType: '',
              ),
              const SizedBox(height: 10),
              UIButtonNN(
                buttonText: "Đổi mật khẩu",
                onPressed: () async {
                  // await _changePasswordViewModel.changePassword(
                  //   authProvider.email, 
                  //   authProvider.oldPassword, 
                  //   authProvider.newPassword, 
                  // );
                //     if (authProvider.changePasswordState == ChangePasswordState.valid) {
                //   routerService.gotoHomeScreen(context);
                //   authProvider.clearState();
                // } else if (authProvider.changePasswordState == ChangePasswordState.invalid) {
                //   print(authProvider.errors);
                // };
                    await authProvider.changePassword();
                    if(authProvider.changePasswordState == ChangePasswordState.valid){
                      //   Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => HomeScreen(),
                      //   ),
                      // );
                      // Navigator.pushReplacementNamed(context, '/index');
                      // RouterService().goToIndexScreen(context);
                     Navigator.pop(context, true);
                    }
                    // else if(authProvider.sendVerificationCodeState== SendVerificationCodeState.invalid){
                    //   UIToastNN.showToast(result['EM']);
                    // }
                    authProvider.setChangePasswordState(ChangePasswordState.none);
                }
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
