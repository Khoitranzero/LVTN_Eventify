import 'package:Eventify/ui/screens/authentication/forgot_password/emailAuthentication.dart';
import 'package:Eventify/ui/screens/authentication/forgot_password/forgotPassword.dart';
import 'package:Eventify/ui/screens/authentication/login/login_screen.dart';
import 'package:Eventify/ui/screens/authentication/register/sign_up_screen.dart';
import 'package:Eventify/ui/screens/home/home_screen.dart';
import 'package:Eventify/ui/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterService  {

  final router = GoRouter(
    
    routes: [
      GoRoute(
        path: '/',
         builder: (context, state) => const IndexScreen(),
      ),
      GoRoute(
        path: '/index',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const IndexScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 100),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/sendVerificationCode',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            child: const SendVerificationCodeScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/verifyCodeAndResetPassword',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            child: const VerifyCodeAndResetPasswordScreen(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );

  void goToLogin(BuildContext context) {
    context.go('/login', extra: context);
  }

  void switchToRegister(BuildContext context) {
    context.go('/register', extra: context);
  }

  void gotoHomeScreen(BuildContext context) {
    context.go('/home', extra: context);
  }

  void gotoSendVerificationCodeScreen(BuildContext context) {
    context.go('/sendVerificationCode', extra: context);
  }

  void gotoVerifyCodeAndResetPasswordScreen(BuildContext context) {
    context.go('/verifyCodeAndResetPassword', extra: context);
  }

  void goToIndexScreen(BuildContext context) {
    context.go('/index', extra: context);
  }
}
