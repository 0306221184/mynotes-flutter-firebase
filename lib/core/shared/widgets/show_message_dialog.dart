import 'package:flutter/material.dart';

Future<void> showMessageDialog(
    {required context, String? title, required String message}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? "Message"),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      });
}
