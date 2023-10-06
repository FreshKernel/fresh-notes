part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();

  factory AuthState.initial() {
    final user = AuthService.getInstance().currentUser;
    if (user == null) {
      return const AuthStateUnAuthenticated(
        exception: null,
      );
    }
    return AuthStateAuthenticated(user: user, exception: null);
  }
}

final class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated({
    required this.user,
    required this.exception,
  });

  final AuthUser user;
  final Exception? exception;
}

enum AuthStateUnAuthenticatedAction {
  sendResetPasswordLinkToEmail,
  none,
}

final class AuthStateUnAuthenticated extends AuthState {
  const AuthStateUnAuthenticated({
    this.exception,
    this.lastAction = AuthStateUnAuthenticatedAction.none,
  });

  final Exception? exception;
  final AuthStateUnAuthenticatedAction lastAction;
}
