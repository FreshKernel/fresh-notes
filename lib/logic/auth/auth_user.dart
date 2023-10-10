import 'package:firebase_auth/firebase_auth.dart' as firebase
    show User, ConfirmationResult;
import 'package:meta/meta.dart';

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

  AuthUser copyWith({
    String? id,
    bool? isEmailVerified,
    String? emailAddress,
    UserData? data,
  }) {
    return AuthUser(
      id: id ?? this.id,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      emailAddress: emailAddress ?? this.emailAddress,
      data: data ?? this.data,
    );
  }
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
    return displayName != null;
  }

  UserData copyWith({
    String? displayName,
    String? photoUrl,
  }) {
    return UserData(
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
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
