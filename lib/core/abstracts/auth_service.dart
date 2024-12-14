import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<void> initialize();
  User? get currentUser;
  Future<User> login({required String email, required String password});
  Future<User> createUser({required String email, required String password});
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> sendResetPassword(String email);
  Future<void> deleteUser();
}
