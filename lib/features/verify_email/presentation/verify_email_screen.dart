import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isLoading = false;
  late final AuthRepository _authRepository;
  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
  }

  Future<void> _handleVerifyEmail() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final String verify = await _authRepository.verifyEmail();
      print(verify);
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
        title: const Text("Verify Email"),
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      ),
      body: Column(
        children: [
          const Text("Verify Email"),
          isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Container(),
          TextButtonWidget(
              onPressed: _handleVerifyEmail, data: "Send verify email")
        ],
      ),
    );
  }
}
