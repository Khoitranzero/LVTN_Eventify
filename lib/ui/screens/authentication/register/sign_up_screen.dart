import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/component/molcules/UIButtonNN.dart';
import 'package:Eventify/ui/component/molcules/UIDialogNN.dart';
import 'package:Eventify/ui/component/molcules/UITextInputFormNN.dart';
import 'package:Eventify/ui/screens/authentication/wave.dart';
import 'package:Eventify/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RouterService routerService = RouterService();
  //AuthProvider authProvider = AuthProvider();

  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;
  FocusNode? _fullNameFocusNode;
  FocusNode? _phoneFocusNode;
  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _fullNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    _fullNameFocusNode?.dispose();
    _phoneFocusNode?.dispose();
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
              keyboardType: 'text',
              icon: Icons.person_4,
              label: "Tên đầy đủ",
              focusNode: _fullNameFocusNode,
              onChanged: (value) {
                authProvider.fullName = value;
              },
            ),
            UITextInputFormNN(
                icon: Icons.phone,
                label: "Số điện thoại",
                focusNode: _phoneFocusNode,
                keyboardType: 'number',
                onChanged: (value) {
                  authProvider.phone = value;
                  if (!Validator.isValidPhoneNumber(value)) {
                    authProvider.setError(
                        'Phone', "Số điện thoại không hợp lệ");
                  } else {
                    authProvider.clearError('Phone');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                    (auth) => auth.getError('Phone'))),
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
            UITextInputFormNN(
                icon: Icons.lock,
                keyboardType: 'text',
                label: "Mật khẩu",
                focusNode: _passwordFocusNode,
                onChanged: (value) {
                  authProvider.password = value;
                  if (!Validator.isValidPassword(value)) {
                    authProvider.setError('Password', 'Mật khẩu không hợp lệ');
                  } else {
                    authProvider.clearError('Password');
                  }
                },
                errorText: context.select<AuthProvider, String?>(
                    (auth) => auth.getError('Password'))),
            const SizedBox(
              height: 10,
            ),
            UIButtonNN(
                buttonText: "Đăng ký",
                onPressed: () async {
                  await authProvider.register();

                  if (authProvider.getError('registerEmptyInfo') != null) {
                    String? errorMessage =
                        authProvider.getError('registerEmptyInfo');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UIDialogNN(
                              closeButtonText: "Đóng",
                              message: errorMessage,
                              onPressed: () => {Navigator.of(context).pop()},
                              title: "Thông báo");
                        });
                    authProvider.clearError('registerEmptyInfo');
                  }
                  if (authProvider.registerState == RegisterState.invalid) {
                    String? errorMessage =
                        authProvider.getError('registerFailed');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UIDialogNN(
                              closeButtonText: "Đóng",
                              message: errorMessage,
                              onPressed: () => {
                                    authProvider
                                        .setRegisterState(RegisterState.none),
                                    Navigator.of(context).pop()
                                  },
                              title: "Thông báo");
                        });
                    authProvider.clearError('registerFailed');
                  } else if (authProvider.registerState ==
                      RegisterState.valid) {
                    // routerService.goToLogin(context);
                    String? successMessage =
                        authProvider.getError('registerSuccess');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UIDialogNN(
                              closeButtonText: "Trở về màn hình đăng nhập",
                              message: successMessage.toString(),
                              onPressed: () => {
                                    authProvider
                                        .setRegisterState(RegisterState.none),
                                    routerService.goToLogin(context),
                                  },
                              title: "Thông báo");
                        });
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                // Navigator.pop(
                //   context,
                //   PageRouteBuilder(
                //     pageBuilder: (_, __, ___) => const LoginScreen(),
                //     transitionDuration: const Duration(milliseconds: 300),
                //     transitionsBuilder: (_, a, __, c) =>
                //         FadeTransition(opacity: a, child: c),
                //   ),
                // );
                routerService.goToLogin(context);
                authProvider.clearError('registerEmptyInfo');
                authProvider.clearError('registerFailed');
                authProvider.email = '';
                authProvider.password = '';
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
