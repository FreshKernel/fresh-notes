import 'package:firebase_auth/firebase_auth.dart' as firebase
    show User, ConfirmationResult;
import 'package:meta/meta.dart';

import '../../core/log/logger.dart';

@immutable
class AuthUser {
  const AuthUser({
    required this.isEmailVerified,
    required this.emailAddress,
    required this.id,
    required this.data,
  });

  factory AuthUser.fromFirebase(firebase.User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        emailAddress: user.email,
        id: user.uid,
        data: UserData(
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ),
      );
  final String id;
  final bool isEmailVerified;
  final String? emailAddress;
  final UserData data;
}

@immutable
class UserData {
  const UserData({
    required this.displayName,
    required this.photoUrl,
  });

  final String? displayName;
  final String? photoUrl;

  bool get hasUserData {
    AppLogger.log('Data $displayName == $photoUrl');
    return displayName != null && photoUrl != null;
  }
}

@immutable
class PhoneNumberConfirmation {
  const PhoneNumberConfirmation({required this.verificationId});

  factory PhoneNumberConfirmation.fromFirebase(
          firebase.ConfirmationResult result) =>
      PhoneNumberConfirmation(verificationId: result.verificationId);
  final String verificationId;
}
