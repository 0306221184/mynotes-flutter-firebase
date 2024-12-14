import 'package:my_notes/core/abstracts/auth_service.dart';
import 'package:my_notes/core/services/auth/firebase_auth_service.dart';

class AuthFactory {
  static IAuthService firebase([IAuthService? override]) {
    return override ?? FirebaseAuthService();
  }
}
