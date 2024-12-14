import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/services/auth/auth_service.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => __RegisterScreenState();
}

class __RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    if (AuthService.firebase().currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      });
    }
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      isLoading = true; // Start loading
    });
    final email = _email.text;
    final password = _password.text;
    try {
      final User? res = await AuthService.firebase()
          .createUser(email: email, password: password);
      if (res != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      }
    } catch (e) {
      showErrorDialog(context, "Error: " + e.toString());
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleLogin() async {
    Navigator.pushNamedAndRemoveUntil(
        context, loginRoute, (route) => route.isCurrent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Register"),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        ),
        body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          //Firebase.initializeApp(options: DefaultFirebaseOptions.android),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  Column(
                    children: [
                      isLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : Container(),
                      TextButtonWidget(
                          onPressed: _handleRegister, data: "Register"),
                      TextButtonWidget(onPressed: _handleLogin, data: "Login"),
                    ],
                  ),
                ],
              );
            } else {
              return const Text("Loading...");
            }
          },
        ));
  }
}
