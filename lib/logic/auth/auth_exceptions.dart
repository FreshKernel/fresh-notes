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
  String toString() => name;
}

class AuthException extends AppException {
  const AuthException(String super.message, {required this.type});
  final AuthErrorType type;

  @override
  String toString() {
    return 'Auth exception of type: ${type.name}, message: \n$message.';
  }
}
