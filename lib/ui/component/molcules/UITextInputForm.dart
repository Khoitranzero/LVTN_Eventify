import 'package:flutter/material.dart';

class UITextInputForm extends StatefulWidget {
  final String label;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? errorText;
  final String keyboardType;
  const UITextInputForm(
      {super.key,
      required this.label,
      required this.focusNode,
      required this.keyboardType,
      this.onChanged,
      this.errorText});

  @override
  State<UITextInputForm> createState() => _UITextInputFormState();
}

class _UITextInputFormState extends State<UITextInputForm> {
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 60, 10),
      child: TextFormField(
        obscureText:
            widget.label.toLowerCase().contains("mật khẩu") && _isObsecure,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType.contains("number")
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          floatingLabelStyle: theme.textTheme.titleLarge,
          labelText: widget.label,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorText: widget.errorText,
          suffixIcon: widget.label.toLowerCase().contains("mật khẩu")
              ? IconButton(
                  icon: Icon(
                    _isObsecure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObsecure = !_isObsecure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
