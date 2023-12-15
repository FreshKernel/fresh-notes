import 'package:bloc/bloc.dart';
import 'package:fresh_base_package/fresh_base_package.dart'
    show PlatformChecker;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/log/logger.dart';
import '../../note/cubit/note_cubit.dart';
import '../auth_custom_provider.dart';
import '../auth_exceptions.dart';
import '../auth_service.dart';
import '../auth_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthService authService,
    required this.noteCubit,
  })  : _authService = authService,
        super(AuthState.initial());

  final AuthService _authService;
  final NoteCubit noteCubit;

  Future<void> verifyAccountVerification() async {
    final currentUser = _authService.requireCurrentUser(
        'In order to verify the account, user must be authenticated.');
    try {
      final reloadedUser = await _authService.reloadTheCurrentUser();
      if (reloadedUser == null) {
        emit(const AuthStateUnAuthenticated(
          exception: AuthException(
            'You are not authenticated anymore',
            type: AuthErrorType.userNotLoggedInAnymore,
          ),
        ));
        return;
      }

      if (!reloadedUser.isEmailVerified) {
        emit(AuthStateAuthenticated(
          user: reloadedUser,
          exception: const AuthException(
            'Account is still not verified.',
            type: AuthErrorType.accountNotVerified,
          ),
        ));
        return;
      }

      emit(AuthStateAuthenticated(user: reloadedUser, exception: null));
    } on Exception catch (e, stacktrace) {
      emit(AuthStateAuthenticated(
        user: currentUser,
        exception: e,
      ));
      AppLogger.error(
        e.toString(),
        stackTrace: stacktrace,
      );
    }
  }

  Future<void> authenticateWithEmailAndPassword({
    required String email,
    required String password,
    required bool isSignUp,
  }) async {
    try {
      final user = isSignUp
          ? (await _authService.signUpWithEmailAndPassword(
              email: email, password: password))
          : await _authService.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
      final isEmailVerified = user.isEmailVerified;
      if (!isEmailVerified) {
        await _authService.sendEmailVerification();
        emit(AuthStateAuthenticated(
          user: user,
          exception: null,
        ));
        return;
      }
      await _sharedAuthenticateLogic(user);
      emit(AuthStateAuthenticated(
        user: user,
        exception: null,
      ));
    } on Exception catch (e) {
      emit(AuthStateUnAuthenticated(exception: e));
    }
  }

  Future<void> authenticateWithCustomProvider(
    AuthProvider provider,
  ) async {
    try {
      final AuthCustomProvider authCustomProvider;
      switch (provider) {
        case AuthProvider.google:
          final googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          final googleUser = await googleSignIn.signIn();
          final googleAuth = await googleUser?.authentication;
          if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
            return;
          }
          authCustomProvider = GoogleAuthCustomProvider(
            idToken: googleAuth?.idToken,
            accessToken: googleAuth?.accessToken,
          );
          break;
        case AuthProvider.apple:
          final isAvaliable = await SignInWithApple.isAvailable();
          if (!isAvaliable) {
            AppLogger.error('Sign in with apple is not avaliable.');
            return;
          }
          if (!PlatformChecker.nativePlatform().isAppleSystem()) {
            // Let firebase handle the process for other platform using web page
            authCustomProvider = const AppleAuthCustomProvider(
              identityToken: null,
              authorizationCode: null,
              userIdentifier: null,
            );
          } else {
            try {
              final credential = await SignInWithApple.getAppleIDCredential(
                scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ],
              );
              final identitiyToken = credential.identityToken;
              if (identitiyToken == null) {
                AppLogger.error('Identity token is null');
                return;
              }
              authCustomProvider = AppleAuthCustomProvider(
                identityToken: identitiyToken,
                authorizationCode: credential.authorizationCode,
                userIdentifier: credential.userIdentifier,
              );
            } on SignInWithAppleException catch (e) {
              if (e is SignInWithAppleAuthorizationException) {
                AppLogger.log('Sign in with apple result is ${e.code}');
                switch (e.code) {
                  case AuthorizationErrorCode.canceled:
                    return;
                  case AuthorizationErrorCode.failed:
                    rethrow;
                  case AuthorizationErrorCode.invalidResponse:
                    rethrow;
                  case AuthorizationErrorCode.notHandled:
                    rethrow;
                  case AuthorizationErrorCode.notInteractive:
                    return;
                  case AuthorizationErrorCode.unknown:
                    // return;
                    rethrow;
                }
              }
              AppLogger.error(
                'Error in sign in with apple: ${e.toString()} ${e.runtimeType}',
              );
              rethrow;
            }
          }
      }
      final user =
          await _authService.authenticateWithCustomProvider(authCustomProvider);
      final isEmailVerified = user.isEmailVerified;
      if (!isEmailVerified) {
        await _authService.sendEmailVerification();
        emit(AuthStateAuthenticated(
          user: user,
          exception: null,
        ));
        return;
      }
      await _sharedAuthenticateLogic(user);
      emit(AuthStateAuthenticated(
        user: user,
        exception: null,
      ));
    } on Exception catch (e) {
      emit(AuthStateUnAuthenticated(exception: e));
    }
  }

  /// Shared logic between social authentication and email/password providers
  Future<void> _sharedAuthenticateLogic(AuthUser user) async {
    await noteCubit.syncLocalNotesFromCloud();
  }

  Future<void> logout() async {
    final currentUser = _authService.requireCurrentUser(null);
    try {
      await _authService.logout();
      emit(const AuthStateUnAuthenticated(exception: null));
    } on Exception catch (e) {
      emit(AuthStateAuthenticated(user: currentUser, exception: e));
    }
  }

  Future<void> sendForgotPasswordLink({
    required String email,
  }) async {
    try {
      await _authService.sendResetPasswordLinkToEmail(email: email);
      emit(AuthStateUnAuthenticated(
          exception: null,
          lastAction:
              AuthStateUnAuthenticatedAction.sendResetPasswordLinkToEmail,
          message: DateTime.now().toIso8601String() // Workaround
          ));
    } on Exception catch (e) {
      emit(AuthStateUnAuthenticated(exception: e));
    }
  }

  Future<void> updateUserProfile({
    required String displayName,
  }) async {
    final currentUser = _authService.requireCurrentUser(
      'To update the user profile '
      'user must be authenticated',
    );
    try {
      final newUser = await _authService.updateUserData(UserData(
        displayName: displayName,
        photoUrl: null,
      ));
      emit(AuthStateAuthenticated(user: newUser, exception: null));
    } on Exception catch (e) {
      emit(AuthStateAuthenticated(
        user: currentUser,
        exception: e,
      ));
    }
  }
}
