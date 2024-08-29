import 'package:flutter/material.dart';

class UICustomButton extends StatelessWidget {
  final String? buttonText;
  final IconData? icon;
  final VoidCallback onPressed;
  final int? flex;
  final Color? colors;

  UICustomButton({
    super.key,
    this.buttonText,
    this.icon,
    required this.onPressed,
    this.colors,
    this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.white),
              if (icon != null && buttonText != null) SizedBox(width: 4),
              if (buttonText != null)
                Text(
                  buttonText!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
