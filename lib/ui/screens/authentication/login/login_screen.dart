 import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:Eventify/ui/component/molcules/UIButtonNN.dart';
import 'package:Eventify/ui/component/molcules/UIDialogNN.dart';
import 'package:Eventify/ui/component/molcules/UITextInputFormNN.dart';
import 'package:Eventify/ui/screens/authentication/login/loginViewModel.dart';
// import 'package:Eventify/ui/screens/authentication/register/sign_up_screen.dart';
import 'package:Eventify/ui/screens/authentication/wave.dart';
import 'package:Eventify/validator/validator.dart';
// import 'package:Eventify/ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RouterService routerService = RouterService();
  late LoginViewModel _loginViewModel;
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;
  //AuthProvider authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _loginViewModel = LoginViewModel();
  }
void _checkLoginStatus() async {
  final token = await TokenService.getToken();
  if (token != null) {
    // routerService.gotoHomeScreen(context);
    context.go('/home');
  }
}
  @override
  void dispose() {
    _emailFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }
  // void handleLoginButtonPressed() {
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   _loginViewModel.email = email;
  //   _loginViewModel.password = password;
  //   _loginViewModel.userLogin();
  //   print(_loginViewModel.isValidAccount);
  //   if (_loginViewModel.isValidAccount == 'valid') {
  //     routerService.gotoHomeScreen(context);
  //   } else if (_loginViewModel.isValidAccount == 'invalid') {
  //     //hanlde with notify
  //     print("Không thể đăng nhập với lỗi ${_loginViewModel.errorMessage}");
  //   }
  // }

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
          const SizedBox(
            height: 50,
          ),
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
                  authProvider.setError('email', 'Email không hợp lệ');
                } else {
                  authProvider.clearError('email');
                }
              },
              errorText: context.select<AuthProvider, String?>(
                  (auth) => auth.getError('email'))),
          UITextInputFormNN(
            icon: Icons.lock,
            label: "Mật khẩu",
            // textEditingController: passwordController,
            focusNode: _passwordFocusNode,
            keyboardType: 'text',
            onChanged: (value) {
              authProvider.password = value;
              if (!Validator.isValidPassword(value)) {
                authProvider.setError('password', 'Mật khẩu không hợp lệ');
              } else {
                authProvider.clearError('password');
              }
            },
            errorText: context.select<AuthProvider, String?>(
                (auth) => auth.getError('password')),
          ),
          const SizedBox(
            height: 10,
          ),
          UIButtonNN(
              buttonText: "Đăng nhập",
              onPressed: () async {
                await authProvider.login();
                if (authProvider.getError('loginEmptyInfo') != null) {
                  String? errorMessage =
                      authProvider.getError('loginEmptyInfo');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UIDialogNN(
                            closeButtonText: "Đóng",
                            message: errorMessage,
                            onPressed: () => {Navigator.of(context).pop()},
                            title: "Thông báo");
                      });
                  authProvider.clearError('loginEmptyInfo');
                }
                if (authProvider.authState == AuthState.valid) {
                  // routerService.gotoHomeScreen(context);
                  //  routerService.goToIndexScreen(context);
                    RouterService().goToIndexScreen(context);
                } else if (authProvider.authState == AuthState.invalid) {
                  //handle wrong password or email here
                  // routerService.switchToRegister(context);
                  // print(authProvider.errors);
                  String? errorMessage = authProvider.getError('loginFailed');
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UIDialogNN(
                            closeButtonText: "Đóng",
                            message: errorMessage,
                            onPressed: () => {Navigator.of(context).pop()},
                            title: "Thông báo");
                      });
                  authProvider.clearError('loginFailed');
                }
              }),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              routerService.switchToRegister(context);
              authProvider.clearError('loginEmptyInfo');
              authProvider.clearError('loginFailed');
              authProvider.email = '';
              authProvider.password = '';
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text(
                  "Bạn chưa có tài khoản ?",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 24, 71, 111),
                      fontWeight: FontWeight.bold),
                )),
          ),
          InkWell(
            onTap: () {
              routerService.gotoSendVerificationCodeScreen(context);
              authProvider.clearAllError();
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: const Text(
                  "Quên mật khẩu !",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 24, 71, 111),
                      fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    )));
  }
}