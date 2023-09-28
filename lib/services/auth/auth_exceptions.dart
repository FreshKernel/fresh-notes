import 'package:my_notes/core/errors/exceptions.dart';

class AuthException extends AppException {
  const AuthException(super.message);
}

class UserNotFoundAuthException extends AuthException {
  const UserNotFoundAuthException(super.message);
}

class InvalidCredentialsAuthException extends AuthException {
  const InvalidCredentialsAuthException(super.message);
}

class WrongPasswordAuthException extends InvalidCredentialsAuthException {
  const WrongPasswordAuthException(super.message);
}

class WeakPasswordAuthException extends AuthException {
  const WeakPasswordAuthException(super.message);
}

class SignUpAuthException extends AuthException {
  const SignUpAuthException(super.message);
}

class EmailAlreadyInUseAuthException extends SignUpAuthException {
  const EmailAlreadyInUseAuthException(super.message);
}

class InvalidEmailAuthException extends AuthException {
  const InvalidEmailAuthException(super.message);
}

class UnknownAuthErrorException extends AuthException {
  const UnknownAuthErrorException(super.message);
}

class GenericAuthErrorException extends AuthException {
  const GenericAuthErrorException(super.message);
}

class UserNotLoggedInAuthException extends AuthException {
  const UserNotLoggedInAuthException(super.message);
}

class UserNotLoggedInAnymoreAuthException extends AuthException {
  const UserNotLoggedInAnymoreAuthException(super.message);
}

class ActionRequiresRecentLoginAuthException extends AuthException {
  const ActionRequiresRecentLoginAuthException(super.message);
}

class DeleteTheUserRequiresRecentLoginAuthException
    extends ActionRequiresRecentLoginAuthException {
  const DeleteTheUserRequiresRecentLoginAuthException(super.message);
}

class SignOutUserRequiresRecentLoginAuthException
    extends ActionRequiresRecentLoginAuthException {
  const SignOutUserRequiresRecentLoginAuthException(super.message);
}

class UserDisabledAuthException extends AuthException {
  const UserDisabledAuthException(super.message);
}

class AuthProviderNotEnabledException extends AuthException {
  const AuthProviderNotEnabledException(super.message);
}

class TooManyAuthenticateRequests extends AuthException {
  const TooManyAuthenticateRequests(super.message);
}
