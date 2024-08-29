import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:flutter/material.dart';

class UIModalNN extends StatelessWidget {
  final String title;
  final String message;
  final String closeButtonText;
  final VoidCallback onPressed;
  UIModalNN(
      {super.key,
      required this.title,
      required this.message,
      required this.closeButtonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text(message, style: TextStyle(fontSize: 16)),
      actions: [
         UICustomButton(
                 icon: Icons.cancel_outlined,
                 buttonText: closeButtonText,
                 onPressed: onPressed,
                 colors: Colors.blue,
                  ),
        ],
    );
  }
}
