import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final VoidCallback _onPressed; // Function type for onPressed
  final String _data;

  // Constructor to accept the parameters
  const TextButtonWidget({
    super.key,
    required VoidCallback onPressed,
    required String data,
  })  : _onPressed = onPressed,
        _data = data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: _onPressed,
        child: Text(_data),
      ),
    );
  }
}
