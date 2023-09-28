import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
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
}
