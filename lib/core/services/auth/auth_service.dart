import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/core/abstracts/auth_service.dart';

class AuthService implements IAuthService {
  final IAuthService authService;
  const AuthService(this.authService);

  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) =>
      authService.createUser(email: email, password: password);

  @override
  User? get currentUser => authService.currentUser;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) =>
      authService.login(email: email, password: password);

  @override
  Future<void> logout() => authService.logout();

  @override
  Future<void> sendEmailVerification() => authService.sendEmailVerification();
}
