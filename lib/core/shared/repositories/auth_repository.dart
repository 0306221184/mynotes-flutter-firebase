import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/core/shared/widgets/show_error_dialog.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return res.user;
    } on FirebaseAuthException catch (e) {
      final String error = e.code.replaceAll(r'-', ' ');
      showErrorDialog(context, error);
      return null;
    }
  }

  Future<User?> register(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential res = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return res.user;
    } on FirebaseAuthException catch (e) {
      final String error = e.code.replaceAll(r'-', ' ');
      showErrorDialog(context, error);
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
      return true;
    } catch (e) {
      print("Error: " + e.toString());
      return false;
    }
  }

  Future<String> verifyEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return 'Verification email sent successfully!';
      }
      if (user?.emailVerified ?? false) {
        return 'Email is already verified.';
      }
      return 'Failed to send verification email';
    } catch (e) {
      return 'Failed to send verification email: $e';
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> delete() async {
    try {
      final User? user = await _firebaseAuth.currentUser;
      if (user != null) {
        user.delete();
        return 'User is deleted!';
      } else {
        return "already logged out!!";
      }
    } catch (e) {
      return 'Failed to delete: $e.';
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get user => _firebaseAuth.currentUser;
}
