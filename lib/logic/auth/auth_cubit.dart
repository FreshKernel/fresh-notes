import 'package:bloc/bloc.dart';

import '../../core/log/logger.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_user.dart';
import '../../services/data/notes/s_notes_data.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  final _authService = AuthService.getInstance();
  final _notesService = NotesDataService.getInstance();

  Future<void> verifyAccountVerification() async {
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
        // emit(AuthStateNeedAccountVerification(
        //   AuthException(
        //     'Account is still not verified. ${DateTime.now()}', // Workaround for now
        //     type: AuthErrorType.accountNotVerified,
        //   ),
        // ));
        return;
      }

      emit(AuthStateAuthenticated(user: reloadedUser, exception: null));
    } on Exception catch (e, stacktrace) {
      emit(AuthStateAuthenticated(
        user: _authService.requireCurrentUser(null),
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
      await _notesService.syncLocalNotesFromCloud();
      emit(AuthStateAuthenticated(
        user: user,
        exception: null,
      ));
    } on Exception catch (e) {
      emit(AuthStateUnAuthenticated(exception: e));
    }
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
      emit(const AuthStateUnAuthenticated(
        exception: null,
      ));
    } on Exception catch (e) {
      emit(AuthStateUnAuthenticated(exception: e));
    }
  }
}
