import 'package:firebase_auth/firebase_auth.dart'
    show
        AppleAuthProvider,
        ConfirmationResult,
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        OAuthProvider;

import '../../core/api/api_exceptions.dart';
import '../auth_custom_provider.dart';
import '../auth_exceptions.dart';
import '../auth_repository.dart';
import '../auth_user.dart';

class FirebaseAuthProviderImpl extends AuthRepository {
  const FirebaseAuthProviderImpl();

  @override
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  @override
  AuthUser requireCurrentUser([String? errorMessage]) {
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
        case 'user-token-expired':
          return null;
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
      _defaultErrorHandlersForAuthProcess(e);
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
      _defaultErrorHandlersForAuthProcess(e);
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
      _defaultErrorHandlersForAuthProcess(e);
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
        case 'user-not-found':
          throw const AuthException(
            'Can not find user with this email to sign in',
            type: AuthErrorType.userNotFound,
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
  Future<AuthUser> authenticateWithCustomProvider(
    AuthCustomProvider authCustomProvider,
  ) async {
    try {
      switch (authCustomProvider) {
        case GoogleAuthCustomProvider():
          final result = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: authCustomProvider.accessToken,
              idToken: authCustomProvider.idToken,
            ),
          );
          final user = result.user;
          if (user == null) {
            throw const AuthException(
              'We have logged in but firebase sdk stil return the user as nullable.',
              type: AuthErrorType.userStillNotLoggedIn,
            );
          }
          return AuthUser.fromFirebase(user);
        case AppleAuthCustomProvider():
          final identityToken = authCustomProvider.identityToken;
          final oAuthProvider = OAuthProvider('apple.com');

          final result = identityToken != null
              ? await FirebaseAuth.instance.signInWithCredential(
                  oAuthProvider.credential(
                    accessToken: authCustomProvider.authorizationCode,
                    idToken: identityToken,
                  ),
                )
              : await FirebaseAuth.instance
                  .signInWithProvider(AppleAuthProvider()..addScope('email'));
          final user = result.user;
          if (user == null) {
            throw const AuthException(
              'We have logged in but firebase sdk stil return the user as nullable.',
              type: AuthErrorType.userStillNotLoggedIn,
            );
          }
          return AuthUser.fromFirebase(user);
      }
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      _defaultErrorHandlersForAuthProcess(e);
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw const AuthException(
            'In firebase: Thrown if there already exists an account with the email '
            'address asserted by the credential. Resolve this by calling '
            '[fetchSignInMethodsForEmail] and then asking the user to sign in '
            'using one of the returned providers.'
            'Once the user is signed in, the original credential can be linked '
            'to the user with [linkWithCredential]',
            type: AuthErrorType.accountExistsWithDifferentCredential,
          );
        case 'invalid-credential':
          throw const AuthException(
            'in firebase: Thrown if the credential is malformed or has expired.',
            type: AuthErrorType.invalidCredentials,
          );
        case 'operation-not-allowed':
          throw const AuthException(
            'in firebase: Thrown if the type of account corresponding to the '
            'credential is '
            'not enabled. Enable the account type in the Firebase Console, '
            'under the Auth tab.',
            type: AuthErrorType.authProviderNotEnabled,
          );
        case 'user-disabled':
          throw const AuthException(
            'Thrown if the user corresponding to the given credential has been'
            'disabled.',
            type: AuthErrorType.userAccountIsDisabled,
          );
        case 'user-not-found':
          throw const AuthException(
            'Thrown if signing in with a credential from [EmailAuthProvider.credential]'
            'and there is no user corresponding to the given email.',
            type: AuthErrorType.userNotFound,
          );
        case 'wrong-password':
          throw const AuthException(
            'Thrown if signing in with a credential from '
            '[EmailAuthProvider.credential]'
            'and the password is invalid for the given email, or if the account'
            ' corresponding to the email does not have a password set.',
            type: AuthErrorType.wrongPassword,
          );
        case 'invalid-verification-code':
          throw const AuthException(
            'Thrown if the credential is a [PhoneAuthProvider.credential] and the'
            'verification code of the credential is not valid.',
            type: AuthErrorType.invalidVerificationCode,
          );
        case 'invalid-verification-id':
          throw const AuthException(
            'Thrown if the credential is a [PhoneAuthProvider.credential] and the'
            'verification ID of the credential is not valid.id.',
            type: AuthErrorType.invalidVerificationId,
          );
        default:
          throw AuthException(
            'Unknown error while authenticate with third party provider using firebase. ${e.message}, ${e.code}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic error while authenticateWithCustomProvider $e',
        type: AuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<void> sendResetPasswordLinkToEmail({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _defaultErrorHandlersForAuthProcess(e);
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'user-not-found':
          throw const AuthException(
            'Can not find user with this email to send reset password link to email',
            type: AuthErrorType.userNotFound,
          );
        case 'invalid-email':
          throw const AuthException('message',
              type: AuthErrorType.invalidEmail);
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

  @override
  Future<AuthUser> updateUserData(UserData userData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const AuthException(
          'The user should be logged in when he wants to update his profile',
          type: AuthErrorType.userRequiredToLoggedIn,
        );
      }
      final displayName = userData.displayName;
      final photoUrl = userData.photoUrl;
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
      final appAuthUser = requireCurrentUser(null);

      return appAuthUser.copyWith(
        data: appAuthUser.data.copyWith(
          displayName: displayName,
          photoUrl: photoUrl,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _defaultErrorHandlersForAuthProcess(e);
      _defaultErrorsHanlders(e);
      switch (e.code) {
        default:
          throw AuthException(
            'Unknown auth error: ${e.toString()}',
            type: AuthErrorType.unknownAuthError,
          );
      }
    } catch (e) {
      throw AuthException(
        'Generic error while updateUserData $e',
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

  void _defaultErrorHandlersForAuthProcess(FirebaseAuthException e) {
    switch (e.code) {
      case 'too-many-requests':
        throw const AuthException(
          'Firebase sdk told us that the user is trying to authenticate with wrong informations too many times, please ask him to try again.',
          type: AuthErrorType.tooManyAuthenticateRequests,
        );
      case 'user-token-expired':
        throw const AuthException(
          'The user is no longer authenticated since his token has been expired',
          type: AuthErrorType.userNotLoggedInAnymore,
        );
    }
  }
}
