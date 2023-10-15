import 'package:meta/meta.dart';

enum AuthProvider { google, apple }

@immutable
sealed class AuthCustomProvider {
  const AuthCustomProvider({
    required this.providerId,
  });

  final String providerId;
}

final class GoogleAuthCustomProvider extends AuthCustomProvider {
  const GoogleAuthCustomProvider({
    required this.idToken,
    required this.accessToken,
  }) : super(
          providerId: 'google.com',
        );

  final String? idToken;
  final String? accessToken;
}

final class AppleAuthCustomProvider extends AuthCustomProvider {
  const AppleAuthCustomProvider({
    required this.identityToken,
    required this.authorizationCode,
    required this.userIdentifier,
  }) : super(providerId: 'apple.com');
  final String? identityToken;
  final String? authorizationCode;
  final String? userIdentifier;

  void get accessToken {}
}
