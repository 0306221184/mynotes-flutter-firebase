import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/features/authentication/presentation/login_screen.dart';
import 'package:my_notes/features/authentication/presentation/register_screen.dart';
import 'package:my_notes/features/home/presentation/home_screen.dart';
import 'package:my_notes/core/shared/config/firebase/firebase_options.dart';
import 'package:my_notes/features/verify_email/presentation/verify_email_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verify-email': (context) => const VerifyEmail(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
