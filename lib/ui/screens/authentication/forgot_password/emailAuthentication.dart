
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIButtonNN.dart';
import 'package:Eventify/ui/component/molcules/UITextInputFormNN.dart';
import 'package:Eventify/ui/screens/authentication/forgot_password/forgotPassword.dart';
import 'package:Eventify/ui/screens/authentication/wave.dart';
import 'package:Eventify/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendVerificationCodeScreen extends StatefulWidget {
  const SendVerificationCodeScreen({super.key});

  @override
  State<SendVerificationCodeScreen> createState() => _SendVerificationCodeScreenState();
}

class _SendVerificationCodeScreenState extends State<SendVerificationCodeScreen> {
  RouterService routerService = RouterService();
  //AuthProvider authProvider = AuthProvider();

  FocusNode? _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();

  }

  @override
  void dispose() {
    _emailFocusNode?.dispose();
 
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
                icon: Icons.email,
                label: "Email",
                focusNode: _emailFocusNode,
                keyboardType: 'text',
                onChanged: (value) {
                  authProvider.email = value;
                  if (!Validator.isValidEmail(value)) {
                    authProvider.setError('Email', 'Email không hợp lệ');
                  } else {
                    authProvider.clearError('Email');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                    (auth) => auth.getError('Email'))),
            const SizedBox(
              height: 10,
            ),
         UIButtonNN(
                    buttonText: "Gửi mã xác thực",
                    onPressed: () async {
                   await authProvider.sendVerificationCode();
                    if(authProvider.sendVerificationCodeState== SendVerificationCodeState.valid){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodeAndResetPasswordScreen(),
                        ),
                      );
                     
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
                authProvider.clearError('sendVerificationCodeEmptyInfo');
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
