import 'package:my_notes/services/api/api_exceptions.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, ConfirmationResult;

class FirebaseAuthProvider extends AuthProvider {
  @override
  Future<void> initialize() async {
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
      throw const UserNotLoggedInAuthException(
          'The user should be logged in when he want to delete his data.');
    }
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'requires-recent-login':
          throw const DeleteTheUserRequiresRecentLoginAuthException(
              'For security reasons the user should have recently logged in. Please ask him to authenticate again.');
        default:
          throw throw UnknownAuthErrorException(
              'Unknown error while deleting the user: ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException(
          'Generic error error while deleting the user: $e');
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const UserNotLoggedInAuthException(
          'The user should be logged in when he want to sign out.');
    }
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'requires-recent-login':
          throw const SignOutUserRequiresRecentLoginAuthException(
              'For security reasons the user should have recently logged in. Please ask him to authenticate again.');
        default:
          throw UnknownAuthErrorException(
              'Unknown error while logout in firebase: ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException(
          'Generic errror while deleting the user: $e');
    }
  }

  @override
  Future<AuthUser?> reloadTheCurrentUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const UserNotLoggedInAuthException(
            'The user should be logged in when he want to reload his data.');
      }
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw const UserNotLoggedInAnymoreAuthException(
            'The user is not logged in anymore, please ask him to sign in again.');
      }
      return AuthUser.fromFirebase(user);
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        default:
          throw UnknownAuthErrorException(
              'Unknown error while reload the current user. ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException('Generic error $e');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const UserNotLoggedInAuthException(
          'The user should be logged in when he wants to sendEmailVerification.');
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        default:
          throw UnknownAuthErrorException(
              'Unknown error while sendEmailVerification ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException(
          'Generic errror while sendEmailVerification $e');
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
          throw UnknownAuthErrorException(e.message);
      }
    } catch (e) {
      throw GenericAuthErrorException(e.toString());
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
      throw const UserNotLoggedInAuthException(
          'We have logged in but firebase sdk stil return the user as nullable.');
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
        throw const UserNotLoggedInAuthException(
            'We have logged create the account but firebase sdk stil return the user as nullable.');
      }
      return newUser;
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'invalid-email':
          throw const InvalidEmailAuthException(
              'This email is not valid, please enter a valid one.');
        case 'weak-password':
          throw const WeakPasswordAuthException(
              'The firebase sdk doesn\'t allow this password and mark it as weak');
        case 'email-already-in-use':
          throw const EmailAlreadyInUseAuthException(
              'This email is already in use, please ask the user to use different email address.');
        case 'operation-not-allowed':
          throw AuthProviderNotEnabledException(
              'This auth method is not enabled. ${e.message}');
        case 'too-many-requests':
          throw const TooManyAuthenticateRequests(
              'Firebase sdk told us that the user is trying to authenticate with wrong informations too many times, please ask him to try again.');
        default:
          throw UnknownAuthErrorException(
              'Unknown error while sign up with firebase. ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException(
          'Generic error while signUpWithEmailAndPassword $e');
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
        throw const UserNotLoggedInAuthException(
            'We have logged in but firebase sdk stil return the user as nullable.');
      }
      return newUser;
    } on FirebaseAuthException catch (e) {
      _defaultErrorsHanlders(e);
      switch (e.code) {
        case 'invalid-email':
          throw const InvalidEmailAuthException(
              'This email is not valid, please enter a valid one.');
        case 'wrong-password':
          throw const WrongPasswordAuthException('This password is incorrect.');
        case 'INVALID_LOGIN_CREDENTIALS':
          throw const InvalidCredentialsAuthException(
              'Firebase api told the sdk and the sdk told us the login info is not correct.');
        case 'user-not-found':
          throw const UserNotFoundAuthException(
              'The firebase api can\'t find this user. it could be disabled');
        case 'weak-password':
          throw const WeakPasswordAuthException(
              'The firebase sdk doesn\'t allow this password and mark it as weak.');
        case 'operation-not-allowed':
          throw AuthProviderNotEnabledException(
              'This auth method is not enabled. ${e.message}');
        case 'user-disabled':
          throw const UserDisabledAuthException(
              'This account is disabled. Please contact with the support for more information.');
        case 'too-many-requests':
          throw const TooManyAuthenticateRequests(
              'Firebase sdk told us that the user is trying to authenticate with wrong informations too many times, please try again later.');
        default:
          throw UnknownAuthErrorException(
              'Unknown error while sign in with firebase. ${e.message}, ${e.code}');
      }
    } catch (e) {
      throw GenericAuthErrorException(
          'Generic error while signUpWithEmailAndPassword $e');
    }
  }

  void _defaultErrorsHanlders(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        throw NetworkRequestException(
            'An errror happen while sending the network request. ${e.message}');
    }
  }

  @override
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  @override
  AuthUser requireCurrentUser(String? errorMessage) {
    if (!isAuthenticated) {
      throw UserNotLoggedInAuthException(errorMessage ??
          'User is required to be authenticated to do this action.');
    }
    return currentUser!;
  }
}
