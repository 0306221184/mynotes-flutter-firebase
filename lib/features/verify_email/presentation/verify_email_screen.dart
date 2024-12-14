import 'package:flutter/material.dart';
import 'package:my_notes/core/patterns/factory/auth_factory.dart';
import 'package:my_notes/core/services/auth/auth_service.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';
import 'package:my_notes/core/shared/widgets/show_message_dialog.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleVerifyEmail() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      await AuthFactory.firebase().sendEmailVerification();
      showMessageDialog(
          context: context,
          message:
              "Email verification was send to  ${AuthFactory.firebase().currentUser?.email}");
    } catch (e) {
      showErrorDialog(context, e.toString());
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
