import '../../core/app_module.dart';
import 'auth_custom_provider.dart';
import 'auth_repository.dart';
import 'auth_user.dart';
import 'packages/firebase_provider.dart';

class AuthService extends AuthRepository {
  const AuthService(this._authProvider);
  factory AuthService.firebase() =>
      const AuthService(FirebaseAuthProviderImpl());
  factory AuthService.getInstance() => AppModule.authService;

  final AuthRepository _authProvider;

  @override
  Future<void> initialize() => _authProvider.initialize();

  @override
  bool get isInitialized => _authProvider.isInitialized;

  @override
  Future<void> deInitialize() => _authProvider.deInitialize();

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

  @override
  Future<void> sendResetPasswordLinkToEmail({required String email}) =>
      _authProvider.sendResetPasswordLinkToEmail(email: email);

  @override
  Future<AuthUser> authenticateWithCustomProvider(
          AuthCustomProvider authCustomProvider) =>
      _authProvider.authenticateWithCustomProvider(authCustomProvider);

  @override
  Future<AuthUser> updateUserData(UserData userData) =>
      _authProvider.updateUserData(userData);
}
