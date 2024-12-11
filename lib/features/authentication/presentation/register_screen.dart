import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => __RegisterScreenState();
}

class __RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final AuthRepository _authRepository;
  late final Future<void> _data;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    if (_authRepository.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      });
    }
    _email = TextEditingController();
    _password = TextEditingController();
    _data = _handleRegister();
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
      final User? res =
          await _authRepository.register(email, password, context);
      print(res);
      if (res != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      }
    } catch (e) {
      print("Error: " + e.toString());
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
        body: FutureBuilder<List<dynamic>>(
          future: null,
          //Firebase.initializeApp(options: DefaultFirebaseOptions.android),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
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
