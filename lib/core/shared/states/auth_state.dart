import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';

class AuthGlobalState extends StatefulWidget {
  final Widget child;

  const AuthGlobalState({super.key, required this.child});

  @override
  _AuthGlobalStateState createState() => _AuthGlobalStateState();

  static _AuthGlobalStateState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AuthGlobalStateState>();
  }
}

class _AuthGlobalStateState extends State<AuthGlobalState> {
  User? user = AuthRepository().user;

  // Method to update the user when there's a state change
  void updateUser(User? newUser) {
    setState(() {
      user = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AuthInherited(
      user: user,
      updateUser: updateUser,
      child: widget.child,
    );
  }
}

// InheritedWidget to pass data to the widget tree
class _AuthInherited extends InheritedWidget {
  final User? user;
  final void Function(User? newUser) updateUser;

  const _AuthInherited({
    super.key,
    required this.user,
    required this.updateUser,
    required super.child,
  });

  static _AuthInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AuthInherited>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true; // Notify when the user changes
  }
}
