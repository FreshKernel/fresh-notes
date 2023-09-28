import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:my_notes/services/auth/packages/firebase.dart';

class AuthService implements AuthProvider {
  factory AuthService.firebase() => AuthService._(FirebaseAuthProvider());
  factory AuthService.getInstance() => AppModule.authService;

  final AuthProvider _authProvider;

  const AuthService._(this._authProvider);

  @override
  Future<void> initialize() => _authProvider.initialize();

  @override
  AuthUser? get currentUser => _authProvider.currentUser;

  @override
  Future<void> deleteTheCurrentUser() => _authProvider.deleteTheCurrentUser();

  @override
  Future<void> logout() => _authProvider.logout();

  @override
  Future<AuthUser?> reloadTheCurrentUser() =>
      _authProvider.reloadTheCurrentUser();

  @override
  Future<void> sendEmailVerification() => _authProvider.sendEmailVerification();

  @override
  Future<AuthUser> signInWithEmailAndPassword(
          {required String email, required String password}) =>
      _authProvider.signInWithEmailAndPassword(
          email: email, password: password);

  @override
  Future<PhoneNumberConfirmation> signInWithPhoneNumber(
          {required String phoneNumber}) =>
      _authProvider.signInWithPhoneNumber(phoneNumber: phoneNumber);

  @override
  Future<AuthUser> confirmPhoneNumber(
          {required String verificationCode,
          required PhoneNumberConfirmation phoneNumberConfirmation}) =>
      _authProvider.confirmPhoneNumber(
          verificationCode: verificationCode,
          phoneNumberConfirmation: phoneNumberConfirmation);

  @override
  Future<AuthUser> signUpWithEmailAndPassword(
          {required String email, required String password}) =>
      _authProvider.signUpWithEmailAndPassword(
          email: email, password: password);

  @override
  bool get isAuthenticated => _authProvider.isAuthenticated;

  @override
  AuthUser requireCurrentUser(String? errorMessage) =>
      _authProvider.requireCurrentUser(errorMessage);
}
