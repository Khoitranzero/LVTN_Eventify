import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i != 0 && (newText.length - i) % 3 == 0) {
        formattedText += ',';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class UIAppTextField extends StatelessWidget {
  final String hintText;
  final bool isReadOnly;
  final String labelText;
  final TextEditingController textController;
  final VoidCallback? onTap;
  final TextInputType keyboardType; 
  final int? minLines; 
  final int? maxLines; 
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;

  UIAppTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.isReadOnly,
    required this.textController,
    this.onTap,
    this.keyboardType = TextInputType.text, 
    this.minLines, 
    this.maxLines, 
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        readOnly: isReadOnly,
        controller: textController,
        keyboardType: keyboardType, 
        minLines: minLines, 
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
          filled: isReadOnly,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black)),
          fillColor: isReadOnly ? Colors.transparent : Colors.transparent,
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(
              color: textController.text.isEmpty
                  ? Colors.grey
                  : Colors.transparent),
                  counterText: '',
                  prefixIcon: prefixIcon,
        ),
        onTap: onTap,
      ),
    );
  }
}
