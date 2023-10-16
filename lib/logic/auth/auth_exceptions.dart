import 'package:flutter/foundation.dart' show describeEnum;
import '../../core/errors/exceptions.dart';

enum AuthErrorType {
  userNotFound,
  userStillNotLoggedIn,
  invalidCredentials,
  wrongPassword,
  weakPassword,
  emailAlreadyInUse,
  invalidEmail,
  accountNotVerified,
  unknownAuthError,
  genericAuthError,
  userRequiredToLoggedIn,
  userNotLoggedInAnymore,
  userAccountIsDisabled,
  actionRequiresRecentLogin,
  deleteUserRequiresRecentLogin,
  authProviderNotEnabled,
  tooManyAuthenticateRequests,
  accountExistsWithDifferentCredential,
  invalidVerificationCode,
  invalidVerificationId;

  @override
  String toString() {
    return describeEnum(this);
  }
}

class AuthException extends AppException {
  const AuthException(String message, {required this.type}) : super(message);
  final AuthErrorType type;

  @override
  String toString() {
    return 'Auth exception of type: ${type.name} and message $message';
  }
}
