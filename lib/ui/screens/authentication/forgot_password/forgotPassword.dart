
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIButtonNN.dart';
import 'package:Eventify/ui/component/molcules/UIDialogNN.dart';
import 'package:Eventify/ui/component/molcules/UITextInputFormNN.dart';
import 'package:Eventify/ui/screens/authentication/wave.dart';
import 'package:Eventify/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyCodeAndResetPasswordScreen extends StatefulWidget {
  const VerifyCodeAndResetPasswordScreen({super.key});

  @override
  State<VerifyCodeAndResetPasswordScreen> createState() => _VerifyCodeAndResetPasswordScreenState();
}

class _VerifyCodeAndResetPasswordScreenState extends State<VerifyCodeAndResetPasswordScreen> {
  RouterService routerService = RouterService();
  //AuthProvider authProvider = AuthProvider();

  FocusNode? _codeFocusNode;
  FocusNode? _newPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _codeFocusNode = FocusNode();
    _newPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _codeFocusNode?.dispose();
    _newPasswordFocusNode?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
 void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIDialogNN(
          closeButtonText: "Đóng",
          message: message,
          onPressed: () => Navigator.of(context).pop(),
          title: "Thông báo",
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
        body: SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const Wave(),
            // const SizedBox(
            //   height: 50,
            // ),
            SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/icon/ic_custom_launcher.png')),
            const SizedBox(
              height: 20,
            ),
            UITextInputFormNN(
              keyboardType: 'text',
              icon: Icons.confirmation_number,
              label: "Mã xác nhận",
              focusNode: _codeFocusNode,
              onChanged: (value) {
                authProvider.code = value;
              },
            ),
           
            UITextInputFormNN(
                icon: Icons.lock,
                keyboardType: 'text',
                label: "Mật khẩu mới",
                focusNode: _newPasswordFocusNode,
                onChanged: (value) {
                  authProvider.newPassword = value;
                  if (!Validator.isValidPassword(value)) {
                    authProvider.setError('newPassword', 'Mật khẩu không hợp lệ');
                  } else {
                    authProvider.clearError('newPassword');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                    (auth) => auth.getError('newPassword'))),
            const SizedBox(
              height: 10,
            ),
            UIButtonNN(
                buttonText: "Đổi mật khẩu",
                onPressed: () async {
                  await authProvider.verifyCodeAndChangePassword();
               if(authProvider.verifyCodeAndChangePasswordState== VerifyCodeAndChangePasswordState.valid){
                        routerService.goToLogin(context);
                    }
                    // else if(authProvider.sendVerificationCodeState== SendVerificationCodeState.invalid){
                    //   UIToastNN.showToast(result['EM']);
                    // }
                    authProvider.setSendVerificationCodeState(SendVerificationCodeState.none);
                    },
                  ),
                
            const SizedBox(
              height: 10,
            ),
           InkWell(
              onTap: () {
                routerService.goToLogin(context);
                // authProvider.clearError('sendVerificationCodeEmptyInfo');
                // authProvider.clearError('registerFailed');
                // authProvider.email = '';
                // authProvider.password = '';
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: const Text(
                    "Bạn đã có tài khoản ?",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 24, 71, 111),
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
