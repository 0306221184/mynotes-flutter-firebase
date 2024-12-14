import "package:firebase_auth/firebase_auth.dart";
import "package:my_notes/core/abstracts/auth_service.dart";
import "package:my_notes/core/utils/auth_exceptions.dart";
import "package:test/test.dart";

void main() {}

class NotInitializedException implements Exception {
  @override
  String toString() {
    return "Not initialized yet!!!";
  }
}

class MockAuthService implements IAuthService {
  User? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) {
      throw NotInitializedException();
    }
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  User? get currentUser => _user;

  @override
  Future<void> deleteUser() {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) {
      throw NotInitializedException();
    }
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    throw GenericAuthException();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<void> sendResetPassword(String email) {
    // TODO: implement sendResetPassword
    throw UnimplementedError();
  }
}
