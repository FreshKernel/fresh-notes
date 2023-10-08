import 'dart:math' show Random;

// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_notes/logic/auth/auth_custom_provider.dart';
import 'package:my_notes/logic/auth/auth_exceptions.dart';
import 'package:my_notes/logic/auth/auth_repository.dart';
import 'package:my_notes/logic/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider._isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(
        provider.logout(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test("We can't be able to initialize the provider again", () async {
      expect(
        provider.initialize(),
        throwsA(const TypeMatcher<AlreadyInitalizedException>()),
      );
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 3 seconds',
      () async {
        try {
          await provider.initialize();
          expect(provider._isInitialized, true);
        } catch (e) {
          // Already initialized
        }
      },
      timeout: const Timeout(Duration(seconds: 3)),
    );

    test(
      'signUpWithEmailAndPassword() should be delegate to signInWithEmailAndPassword()',
      () async {
        // Should not be await
        final badEmailUser = provider.signInWithEmailAndPassword(
          email: 'foo@bar.com',
          password: 'anypassword',
        );

        expect(
          badEmailUser,
          throwsA(
            const TypeMatcher<AuthException>().having(
              (p0) => p0.type,
              'User not found',
              AuthErrorType.userNotFound,
            ),
          ),
        );

        // Should not be await
        final badPasswordUser = provider.signUpWithEmailAndPassword(
            email: 'any@bar.com', password: 'foobar');

        expect(
          badPasswordUser,
          throwsA(
            const TypeMatcher<AuthException>().having(
              (p0) => p0.type,
              'Error type',
              AuthErrorType.wrongPassword,
            ),
          ),
        );

        // Should be await
        final user = await provider.signUpWithEmailAndPassword(
          email: 'foo@emai.com',
          password: 'bar',
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );

    test('Logged in user should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;

      expect(user, isNotNull);

      expect(user?.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logout();
      await provider.signInWithEmailAndPassword(
          email: 'user', password: 'password');

      expect(provider.currentUser, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class AlreadyInitalizedException implements Exception {}

class MockAuthProvider extends AuthRepository {
  AuthUser? _user;
  bool _isInitialized = false;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      throw AlreadyInitalizedException();
    }
    Future.delayed(const Duration(milliseconds: 800));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(Duration(seconds: Random().nextInt(2)));
    if (email == 'foo@bar.com') {
      throw const AuthException(
        'Wrong emaill address for testing.',
        type: AuthErrorType.userNotFound,
      );
    }
    if (password == 'foobar') {
      throw const AuthException(
        'Wrong Password for testing.',
        type: AuthErrorType.wrongPassword,
      );
    }
    const user = AuthUser(
        isEmailVerified: false,
        emailAddress: 'test@flutter.dart',
        id: 'doesn-not-matter',
        data: UserData(displayName: 'Hello', photoUrl: 'asd'));
    _user = user;
    return user;
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(Duration(milliseconds: Random().nextInt(500)));
    return signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) {
      throw const AuthException(
        'User is not found. can not logout',
        type: AuthErrorType.userNotFound,
      );
    }
    await Future.delayed(Duration(milliseconds: Random().nextInt(800)));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) {
      throw const AuthException(
        'User is not found. can not send email verification',
        type: AuthErrorType.userNotFound,
      );
    }
    await Future.delayed(Duration(seconds: Random().nextInt(4)));
    _user = AuthUser(
        isEmailVerified: true,
        emailAddress: _user?.emailAddress,
        id: 'doesn-not-matter',
        data: const UserData(displayName: 'displayName', photoUrl: 'photoUrl'));
  }

  @override
  Future<AuthUser?> reloadTheCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<PhoneNumberConfirmation> signInWithPhoneNumber(
      {required String phoneNumber}) {
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> confirmPhoneNumber(
      {required String verificationCode,
      required PhoneNumberConfirmation phoneNumberConfirmation}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTheCurrentUser() {
    throw UnimplementedError();
  }

  @override
  bool get isAuthenticated => _user != null;

  @override
  bool get isInitialized => _isInitialized;

  @override
  AuthUser requireCurrentUser(String? errorMessage) {
    throw UnimplementedError(errorMessage);
  }

  @override
  Future<void> deInitialize() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendResetPasswordLinkToEmail({required String email}) {
    // TODO: implement sendResetPasswordLinkToEmail
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> authenticateWithCustomProvider(
      AuthCustomProvider authCustomProvider) {
    // TODO: implement authenticateWithCustomProvider
    throw UnimplementedError();
  }
}
