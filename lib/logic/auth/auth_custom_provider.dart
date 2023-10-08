import 'package:meta/meta.dart';

enum AuthProvider { google }

@immutable
sealed class AuthCustomProvider {
  const AuthCustomProvider({
    required this.providerId,
    required this.signInMethod,
  });

  final String providerId;
  final String signInMethod;
}

final class GoogleAuthCustomProvider extends AuthCustomProvider {
  const GoogleAuthCustomProvider({
    required this.idToken,
    required this.accessToken,
  }) : super(
          providerId: 'google.com',
          signInMethod: 'google.com',
        );

  final String? idToken;
  final String? accessToken;
}
