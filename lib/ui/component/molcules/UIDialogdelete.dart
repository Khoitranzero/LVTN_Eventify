import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String type;
  final String title;
  final String content;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final String cancelButtonText;
  final VoidCallback onCancel;

  CustomDialog({
    Key? key,
    required this.type,
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.onConfirm,
    this.cancelButtonText = 'Cancel',
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text(content, style: TextStyle(fontSize: 16),),
      actions: <Widget>[
        Row(children: [
            UICustomButton(
                 icon: Icons.cancel,
                 buttonText: "Hủy",
                 onPressed: onCancel,
                 colors: Colors.blue,
                  flex: 2,
                  ),
            SizedBox(width: 3),
            
            type=="delete" ?
            UICustomButton(
                 icon: Icons.delete,
                 buttonText: "Xóa",
                    onPressed: onConfirm,
                    colors: Colors.red,
                    flex: 2,
                  )
                  :
                UICustomButton(
                 icon: Icons.check_circle_outline,
                 buttonText: "Xác nhận",
                    onPressed: onConfirm,
                    colors: Colors.lightGreen,
                    flex: 2,
                  )
        ],)
       
      ],
    );
  }
}
