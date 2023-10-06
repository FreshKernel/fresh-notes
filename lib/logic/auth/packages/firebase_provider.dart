import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, ConfirmationResult;

import '../../core/api/api_exceptions.dart';
import '../auth_exceptions.dart';
import '../auth_provider.dart';
import '../auth_user.dart';

class FirebaseAuthProviderImpl extends AuthProvider {
  const FirebaseAuthProviderImpl();

  @override
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  @override
  AuthUser requireCurrentUser(String? errorMessage) {
    if (!isAuthenticated) {
      throw AuthException(
        errorMessage ??
            'User is required to be authenticated to do this action.',
        type: AuthErrorType.userRequiredToLoggedIn,
      );
    }
    return currentUser!;
  }

  @override
  Future<void> initialize() async {
    // Nothing is required...
  }

  @override
  bool get isInitialized => true;

  @override
  Future<void> deInitialize() async {
    // Nothing is required...
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return AuthUser.fromFirebase(user);
  }

  @override
  Future<void> deleteTheCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException(
        'The user should be logged in when he want to delete his data.',
        type: AuthErrorType.userRequiredToLoggedIn,
      );
    }
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'requires-recent-login':
          throw const AuthException(
            'For security reasons the user should have recently logged in. Please ask him to authenticate again.',
            type: AuthErrorType.deleteUserRequiresRecentLogin,
          );
        default:
          throw throw AuthException(
              'Unknown error while deleting the user: ${e.message}, ${e.code}',
              type: AuthErrorType.unknownAuthError);
      }
    } catch (e) {
      throw AuthException(
        'Generic error error while deleting the user: $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException(
        'The user should be logged in when he want to sign out.',
        type: AuthErrorType.userRequiredToLoggedIn,
      );
    }
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'requires-recent-login':
          throw const AuthException(
            'For security reasons the user should have recently logged in. Please ask him to authenticate again.',
            type: AuthErrorType.actionRequiresRecentLogin,
          );
        default:
          throw AuthException(
            'Unknown error while logout in firebase: ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic errror while deleting the user: $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<AuthUser?> reloadTheCurrentUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const AuthException(
          'The user should be logged in when he want to reload his data.',
          type: AuthErrorType.userRequiredToLoggedIn,
        );
      }
      // If the user is not logged in anymore then
      // it will throw firebase exception with code 'user-not-found'
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // We won't reach this but just in case
        throw const AuthException(
          'The user is not logged in anymore, please ask him to sign in again.',
          type: AuthErrorType.userNotLoggedInAnymore,
        );
      }
      return AuthUser.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'user-not-found':
          return null; // handle when the user is not logged in anymore
        default:
          throw AuthException(
              'Unknown error while reload the current user. ${e.message}, ${e.code}',
              type: AuthErrorType.unknownAuthError);
      }
    } catch (e) {
      throw AuthException(
        'Generic error $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const AuthException(
        'The user should be logged in when he wants to sendEmailVerification.',
        type: AuthErrorType.userRequiredToLoggedIn,
      );
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      _defaultErrorHandlersForAuth(e);
      switch (e.code) {
        default:
          throw AuthException(
            'Unknown error while sendEmailVerification ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic errror while sendEmailVerification $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<PhoneNumberConfirmation> signInWithPhoneNumber(
      {required String phoneNumber}) async {
    try {
      final result =
          await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
      return PhoneNumberConfirmation.fromFirebase(result);
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        default:
          throw AuthException(
            e.message.toString(),
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw const AuthException(
        'Generic exception while sign in with phone number',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<AuthUser> confirmPhoneNumber(
      {required String verificationCode,
      required PhoneNumberConfirmation phoneNumberConfirmation}) async {
    final confirmResult = phoneNumberConfirmation
        as ConfirmationResult; // TODO: I know it won't work but it's not important for now
    await confirmResult.confirm(verificationCode);
    final newUser = currentUser;
    if (newUser == null) {
      throw const AuthException(
        'We have logged in but firebase sdk stil return the user as nullable.',
        type: AuthErrorType.userStillNotLoggedIn,
      );
    }
    return newUser;
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final newUser = currentUser;
      if (newUser == null) {
        throw const AuthException(
          'We have logged create the account but firebase sdk stil return the user as nullable.',
          type: AuthErrorType.userRequiredToLoggedIn,
        );
      }
      return newUser;
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      _defaultErrorHandlersForAuth(e);
      switch (e.code) {
        case 'invalid-email':
          throw const AuthException(
            'This email is not valid, please enter a valid one.',
            type: AuthErrorType.invalidEmail,
          );
        case 'weak-password':
          throw const AuthException(
            "The firebase sdk doesn't allow this password and mark it as weak",
            type: AuthErrorType.weakPassword,
          );
        case 'email-already-in-use':
          throw const AuthException(
              'This email is already in use, please ask the user to use different email address.',
              type: AuthErrorType.emailAlreadyInUse);
        case 'operation-not-allowed':
          throw AuthException(
            'This auth method is not enabled. ${e.message}',
            type: AuthErrorType.authProviderNotEnabled,
          );
        default:
          throw AuthException(
            'Unknown error while sign up with firebase. ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic error while signUpWithEmailAndPassword $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final newUser = currentUser;
      if (newUser == null) {
        throw const AuthException(
          'We have logged in but firebase sdk stil return the user as nullable.',
          type: AuthErrorType.userStillNotLoggedIn,
        );
      }
      return newUser;
    } on FirebaseAuthException catch (e) {
      _defaultErrorHandlersForAuth(e);
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'invalid-email':
          throw const AuthException(
            'This email is not valid, please enter a valid one.',
            type: AuthErrorType.invalidEmail,
          );
        case 'wrong-password':
          throw const AuthException(
            'This password is incorrect.',
            type: AuthErrorType.wrongPassword,
          );
        case 'INVALID_LOGIN_CREDENTIALS':
          throw const AuthException(
            'Firebase api told the sdk and the sdk told us the login info is not correct.',
            type: AuthErrorType.invalidCredentials,
          );
        case 'weak-password':
          throw const AuthException(
            "The firebase sdk doesn't allow this password and mark it as weak.",
            type: AuthErrorType.weakPassword,
          );
        case 'operation-not-allowed':
          throw AuthException(
            'This auth method is not enabled. ${e.message}',
            type: AuthErrorType.authProviderNotEnabled,
          );
        case 'user-disabled':
          throw const AuthException(
            'This account is disabled. Please contact with the support for more information.',
            type: AuthErrorType.userAccountIsDisabled,
          );
        default:
          throw AuthException(
            'Unknown error while sign in with firebase. ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException('Generic error while signUpWithEmailAndPassword $e',
          type: AuthErrorType.genericAuthError);
    }
  }

  @override
  Future<void> sendResetPasswordLinkToEmail({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _defaultErrorHandlersForAuth(e);
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'user-not-found':
          throw const AuthException(
            'Can not find user with this email to send reset password link to email',
            type: AuthErrorType.userNotFound,
          );
        default:
          throw AuthException(
            'Unknown error while send . ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic error while sendResetPasswordLinkToEmail $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  void _defaultErrorsHanlders(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-disabled':
        throw const AuthException(
          'The user account has been disabled by an administrator.',
          type: AuthErrorType.userAccountIsDisabled,
        );
      case 'network-request-failed':
        throw NetworkRequestException(
          'An errror happen while sending the network request. ${e.message}',
        );
    }
  }

  void _defaultErrorHandlersForAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'too-many-requests':
        throw const AuthException(
          'Firebase sdk told us that the user is trying to authenticate with wrong informations too many times, please ask him to try again.',
          type: AuthErrorType.tooManyAuthenticateRequests,
        );
    }
  }
}
