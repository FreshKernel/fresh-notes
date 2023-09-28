import 'dart:math' show Random;

import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

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

    test('We can\'t be able to initialize the provider again', () async {
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
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );

        // Should not be await
        final badPasswordUser = provider.signUpWithEmailAndPassword(
            email: 'any@bar.com', password: 'foobar');

        expect(
          badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()),
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

class MockAuthProvider extends AuthProvider {
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
      throw const UserNotFoundAuthException(
          'Wrong emaill address for testing.');
    }
    if (password == 'foobar') {
      throw const WrongPasswordAuthException('Wrong Password for testing.');
    }
    const user = AuthUser(
        isEmailVerified: false,
        emailAddress: 'test@flutter.dart',
        id: 'doesn-not-matter');
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
      throw const UserNotFoundAuthException(
          'User is not found. can not logout');
    }
    await Future.delayed(Duration(milliseconds: Random().nextInt(800)));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) {
      throw const UserNotFoundAuthException(
        'User is not found. can not logout',
      );
    }
    await Future.delayed(Duration(seconds: Random().nextInt(4)));
    _user = AuthUser(
        isEmailVerified: true,
        emailAddress: _user?.emailAddress,
        id: 'doesn-not-matter');
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
}
