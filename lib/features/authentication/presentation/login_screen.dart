import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final AuthRepository _authRepository;
  late final Future<void> _data;
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _authRepository = AuthRepository();
    if (_authRepository.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (route) => route.isCurrent);
      });
    }
    _data = _handleLogin();
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
        context, "/register", (route) => route.isCurrent);
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      User? res = await _authRepository.login(_email.text, _password.text);
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
          future: _data,
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
