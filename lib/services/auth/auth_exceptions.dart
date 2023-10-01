import 'package:flutter/foundation.dart' show describeEnum;
import 'package:my_notes/core/errors/exceptions.dart';

enum AuthErrorType {
  userNotFound,
  userStillNotLoggedIn,
  invalidCredentials,
  wrongPassword,
  weakPassword,
  signUp,
  emailAlreadyInUse,
  invalidEmail,
  unknownAuthError,
  genericAuthError,
  userRequiredToLoggedIn,
  userNotLoggedInAnymore,
  userAccountIsDisabled,
  actionRequiresRecentLogin,
  deleteUserRequiresRecentLogin,
  signOutUserRequiresRecentLogin,
  authProviderNotEnabled,
  tooManyAuthenticateRequests;

  @override
  String toString() {
    return describeEnum(this);
  }
}

class AuthException extends AppException {
  final AuthErrorType type;

  const AuthException(String message, {required this.type}) : super(message);

  @override
  String toString() {
    return 'Auth exception of type: ${type.name}';
  }
}
