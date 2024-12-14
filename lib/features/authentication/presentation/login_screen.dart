import 'package:flutter/material.dart';
import 'package:my_notes/core/services/auth/auth_service.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    if (AuthService.firebase().currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _handleRegister() {
    Navigator.pushNamedAndRemoveUntil(
        context, registerRoute, (route) => route.isCurrent);
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      await AuthService.firebase()
          .login(email: _email.text, password: _password.text);
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (route) => route.isCurrent);
    } catch (e) {
      showErrorDialog(context, "Error: " + e.toString());
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
          title: const Center(
            child: Text("Login"),
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
                      TextButtonWidget(onPressed: _handleLogin, data: "Login"),
                      TextButtonWidget(
                          onPressed: _handleRegister, data: "Register"),
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
