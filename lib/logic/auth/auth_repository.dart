import '../../core/services/s_app.dart';
import 'auth_custom_provider.dart';
import 'auth_user.dart';

abstract class AuthRepository extends AppService {
  const AuthRepository();
  AuthUser? get currentUser;
  bool get isAuthenticated;
  AuthUser requireCurrentUser(String? errorMessage);

  Future<AuthUser?> reloadTheCurrentUser();
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<AuthUser> authenticateWithCustomProvider(
      AuthCustomProvider authCustomProvider);
  Future<void> sendResetPasswordLinkToEmail({
    required String email,
  });
  Future<PhoneNumberConfirmation> signInWithPhoneNumber({
    required String phoneNumber,
  });
  Future<AuthUser> confirmPhoneNumber({
    required String verificationCode,
    required PhoneNumberConfirmation phoneNumberConfirmation,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
  Future<void> deleteTheCurrentUser();
  Future<AuthUser> updateUserData(UserData userData);
}
