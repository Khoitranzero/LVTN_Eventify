import 'package:flutter/material.dart';

class UIButtonNN extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const UIButtonNN(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  State<UIButtonNN> createState() => _UIButtonNNState();
}

class _UIButtonNNState extends State<UIButtonNN> {
  var _isLoading = false;
  var _isDisposed = false;
  void _onSubmit() async {
    //hạ bàn phím ảo xuống
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (!_isDisposed) {
      await Future.delayed(const Duration(seconds: 0), () {
        if (!_isDisposed) {
          setState(() {
            _isLoading = false;
          });
          widget.onPressed();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: _isLoading ? null : _onSubmit,
        label: Text(
          widget.buttonText,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        icon: _isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 3,
                ),
              )
            : Icon(
                widget.buttonText == 'Đăng xuất' ? Icons.logout : Icons.login,
                color: Colors.white,
              ),
      ),
    );
  }
}
