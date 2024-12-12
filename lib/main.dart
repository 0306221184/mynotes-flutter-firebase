import 'package:flutter/material.dart';
import 'package:my_notes/core/services/auth/auth_service.dart';
import 'package:my_notes/features/authentication/presentation/login_screen.dart';
import 'package:my_notes/features/authentication/presentation/register_screen.dart';
import 'package:my_notes/features/home/presentation/home_screen.dart';
import 'package:my_notes/features/notes/presentation/note_screen.dart';
import 'package:my_notes/features/verify_email/presentation/verify_email_screen.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        emailVerifyRoute: (context) => const VerifyEmail(),
        notesRoute: (context) => const NoteScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
