import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIToastNN {
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
   static void showToastSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 13, 242, 93).withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
   static void showToastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 250, 11, 11).withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
