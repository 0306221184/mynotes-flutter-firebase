import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/features/verify_email/presentation/verify_email_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenState();
}

class __HomeScreenState extends State<HomeScreen> {
  late final AuthRepository _authRepository;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    if (_authRepository.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/login", (route) => route.isCurrent);
      });
    }
    if (_authRepository.user?.emailVerified == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, "/verify-email");
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, "/notes");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      isLoading = true; // Start loading
    });
    final String email = _authRepository.user?.email ?? "";
    try {
      await _authRepository.resetPassword(email);
      print('Password reset email sent to $email');
    } catch (e) {
      print("Error: " + e.toString());
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleVerifyEmail() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      if (_authRepository.user?.emailVerified == false) {
        Navigator.pushNamed(context, "/verify-email");
      } else
        print("Email is already verified!!");
    } catch (e) {
      print('Failed to send verification email: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleDisplay() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final User? user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('user: ' + user.uid);
        if (user.emailVerified) {
          print("email verified");
        } else
          print("email not verified");
      } else {
        print("already logged out!!");
      }
    } catch (e) {
      print('Failed to display: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleLogout() async {
    bool logout = await AuthRepository().logout();
    if (logout) {
      print("logout!!!");
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", (route) => route.isCurrent);
    }
  }

  Future<void> _handleDelete() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final String delete = await _authRepository.delete();
      print(delete);
      _handleLogout();
    } catch (e) {
      print('Failed to delete: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleMyNotes() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      if (_authRepository.user?.emailVerified == false) {
        Navigator.pushNamed(context, "/verify-email");
      } else {
        Navigator.pushNamed(context, "/notes");
      }
    } catch (e) {
      print('Failed to send verification email: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Welcome ${_authRepository.user?.email} Home Page"),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        ),
        body: Column(
          children: [
            const Text("Home Page"),
            isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Container(),
            TextButtonWidget(onPressed: _handleMyNotes, data: "My Notes"),
            TextButtonWidget(onPressed: _handleDisplay, data: "Display"),
            TextButtonWidget(
                onPressed: _handleResetPassword, data: "Reset password"),
            TextButtonWidget(onPressed: _handleVerifyEmail, data: "Verify"),
            TextButtonWidget(onPressed: _handleLogout, data: "Logout"),
            TextButtonWidget(onPressed: _handleDelete, data: "Delete"),
          ],
        ));
  }
}
