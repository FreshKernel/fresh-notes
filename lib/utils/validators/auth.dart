import 'global.dart';

class AuthValidator {
  AuthValidator._();
  static const _emailRegex =
      '''[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+''';

  static String? validateEmail(String email) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      email,
      errorMessage: 'Please enter your email address.',
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }

    if (!RegExp(_emailRegex).hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String password) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      password,
      errorMessage: 'Please enter a password.',
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }
    if (password.length < 6) {
      return 'Password should be at least 6 characters.';
    }

    return null;
  }
}
