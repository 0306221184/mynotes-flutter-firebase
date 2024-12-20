import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context, VoidCallback? onSignOut) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel")),
            TextButton(onPressed: onSignOut, child: const Text("Sign out")),
          ],
        );
      }).then((value) => value ?? false);
}
