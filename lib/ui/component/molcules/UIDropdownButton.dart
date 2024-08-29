import 'package:flutter/material.dart';

class UIDropdownButton extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry padding;
  final Widget? prefixIcon;

  UIDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(
            color: value == null ? Colors.grey : Colors.transparent,
          ),
           prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
