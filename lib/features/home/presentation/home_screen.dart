import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';
import 'package:my_notes/core/shared/repositories/auth_repository.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';
import 'package:my_notes/features/home/data/enum/menu_action.dart';
import 'package:my_notes/features/home/presentation/widgets/dialogs/show_logout_dialog.dart';

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
            context, loginRoute, (route) => route.isCurrent);
      });
    }
    if (_authRepository.user?.emailVerified == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, emailVerifyRoute);
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
      showErrorDialog(context, 'Password reset email sent to $email');
    } catch (e) {
      showErrorDialog(context, "Error: " + e.toString());
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
        Navigator.pushNamed(context, emailVerifyRoute);
      } else {
        showErrorDialog(context, "Email is already verified!!");
      }
    } catch (e) {
      showErrorDialog(context, 'Failed to send verification email: $e');
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
        if (user.emailVerified) {
          showErrorDialog(context, "user:  ${user.uid} email verified");
        } else {
          showErrorDialog(context, "user:  ${user.uid} email not verified");
        }
      } else {
        showErrorDialog(context, "already logged out!!");
      }
    } catch (e) {
      showErrorDialog(context, 'Failed to display: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _handleLogout() async {
    bool logout = await AuthRepository().logout();
    if (logout) {
      Navigator.pushNamedAndRemoveUntil(
          context, loginRoute, (route) => route.isCurrent);
    }
  }

  Future<void> _handleDelete() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final String delete = await _authRepository.delete();
      showErrorDialog(context, delete);
      _handleLogout();
    } catch (e) {
      showErrorDialog(context, 'Failed to delete: $e');
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
        Navigator.pushNamed(context, emailVerifyRoute);
      } else {
        Navigator.pushNamed(context, notesRoute);
      }
    } catch (e) {
      showErrorDialog(context, 'Failed to send verification email: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = _authRepository.user?.email ?? "";
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Welcome to ${email.split("@")[0]} Home Page"),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 140, 255),
          actions: [
            PopupMenuButton<MenuAction>(
                //icon: const Icon(Icons.menu_open_rounded),
                onSelected: (value) {
              switch (value) {
                case MenuAction.myNotes:
                  _handleMyNotes();
                  break;
                case MenuAction.logout:
                  showLogOutDialog(context, _handleLogout);
                  break;
                default:
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.myNotes, child: Text("My Notes")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.display, child: Text("Display")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.resetPassword,
                    child: Text("Reset password")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.verifyEmail, child: Text("Verify Email")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Log out")),
                PopupMenuItem<MenuAction>(
                    value: MenuAction.delete, child: Text("Delete")),
              ];
            })
          ],
        ),
        body: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return Column(
                  children: [
                    const Text("Home Page"),
                    isLoading == true
                        ? const Center(child: CircularProgressIndicator())
                        : Container(),
                    TextButtonWidget(
                        onPressed: _handleMyNotes, data: "My Notes"),
                    TextButtonWidget(
                        onPressed: _handleDisplay, data: "Display"),
                    TextButtonWidget(
                        onPressed: _handleResetPassword,
                        data: "Reset password"),
                    TextButtonWidget(
                        onPressed: _handleVerifyEmail, data: "Verify"),
                    TextButtonWidget(onPressed: _handleLogout, data: "Logout"),
                    TextButtonWidget(onPressed: _handleDelete, data: "Delete"),
                  ],
                );
              } else {
                return const Text("Loading...");
              }
            }));
  }
}
