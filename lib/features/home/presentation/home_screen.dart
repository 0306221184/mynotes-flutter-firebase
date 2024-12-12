import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/services/auth/auth_service.dart';
import 'package:my_notes/core/shared/config/constants/routes.dart';
import 'package:my_notes/core/shared/widgets/TextButton.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';
import 'package:my_notes/core/shared/widgets/show_message_dialog.dart';
import 'package:my_notes/features/home/data/enum/menu_action.dart';
import 'package:my_notes/features/home/presentation/widgets/dialogs/show_logout_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenState();
}

class __HomeScreenState extends State<HomeScreen> {
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    if (AuthService.firebase().currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, loginRoute, (route) => route.isCurrent);
      });
    }
    if (AuthService.firebase().currentUser?.emailVerified == false) {
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
    final String email = AuthService.firebase().currentUser?.email ?? "";
    try {
      await AuthService.firebase().sendResetPassword(email);
      showMessageDialog(
          context: context, message: 'Password reset email sent to $email');
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
      if (AuthService.firebase().currentUser?.emailVerified == false) {
        Navigator.pushNamed(context, emailVerifyRoute);
      } else {
        showMessageDialog(
            context: context, message: "Email is already verified!!");
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
          showMessageDialog(
              context: context, message: "user:  ${user.uid} email verified");
        } else {
          showMessageDialog(
              context: context,
              message: "user:  ${user.uid} email not verified");
        }
      } else {
        showMessageDialog(context: context, message: "already logged out!!");
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
    try {
      await AuthService.firebase().logout();
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  Future<void> _handleDelete() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      await AuthService.firebase().deleteUser();
      showMessageDialog(context: context, message: "User deleted successfully");
      _handleLogout();
    } catch (e) {
      showErrorDialog(context, e.toString());
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
      if (AuthService.firebase().currentUser?.emailVerified == false) {
        Navigator.pushNamed(context, emailVerifyRoute);
      } else {
        Navigator.pushNamed(context, notesRoute);
      }
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
    String email = AuthService.firebase().currentUser?.email ?? "";
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
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
