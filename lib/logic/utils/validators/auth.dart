import 'global.dart';

class AuthValidator {
  AuthValidator._();
  static const _emailRegex =
      '''[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+''';

  static String? validateEmail(
    String email, {
    required String pleaseEnterYourEmailAddress,
    required String pleaseEnterAValidEmailAddress,
  }) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      email,
      errorMessage: pleaseEnterYourEmailAddress,
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }

    if (!RegExp(_emailRegex).hasMatch(email)) {
      return pleaseEnterAValidEmailAddress;
    }
    return null;
  }

  static String? validatePassword(String password,
      {required String pleaseEnterAPassword,
      required String passwordShouldBeMoreThan6}) {
    final validateNotTextHasError = GlobalValidator.validateTextIsEmpty(
      password,
      errorMessage: pleaseEnterAPassword,
    );
    if (validateNotTextHasError != null) {
      return validateNotTextHasError;
    }
    if (password.length < 6) {
      return passwordShouldBeMoreThan6;
    }

    return null;
  }
}
