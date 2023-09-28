import 'package:firebase_auth/firebase_auth.dart' as firebase
    show User, ConfirmationResult;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String? emailAddress;

  factory AuthUser.fromFirebase(firebase.User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        emailAddress: user.email,
        id: user.uid,
      );

  const AuthUser({
    required this.isEmailVerified,
    required this.emailAddress,
    required this.id,
  });
}

@immutable
class PhoneNumberConfirmation {
  final String verificationId;

  factory PhoneNumberConfirmation.fromFirebase(
          firebase.ConfirmationResult result) =>
      PhoneNumberConfirmation(verificationId: result.verificationId);

  const PhoneNumberConfirmation({required this.verificationId});
}
