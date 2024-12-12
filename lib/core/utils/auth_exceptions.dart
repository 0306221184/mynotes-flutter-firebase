class UserNotFoundAuthException implements Exception {
  final String message;
  UserNotFoundAuthException([this.message = "User not found"]);
  @override
  String toString() {
    return message;
  }
}

class WrongPasswordAuthException implements Exception {
  final String message;
  WrongPasswordAuthException([this.message = "Wrong password"]);
  @override
  String toString() {
    return message;
  }
}

class WeakPasswordAuthException implements Exception {
  final String message;
  WeakPasswordAuthException([this.message = "Weak password"]);
  @override
  String toString() {
    return message;
  }
}

class EmailAlreadyInUseAuthException implements Exception {
  final String message;
  EmailAlreadyInUseAuthException([this.message = "Email already in use"]);
  @override
  String toString() {
    return message;
  }
}

class InvalidEmailAuthException implements Exception {
  final String message;
  InvalidEmailAuthException([this.message = "Invalid email"]);
  @override
  String toString() {
    return message;
  }
}

class UserNotLoginAuthException implements Exception {
  final String message;
  UserNotLoginAuthException([this.message = "User not logged in"]);
  @override
  String toString() {
    return message;
  }
}

class GenericAuthException implements Exception {}
