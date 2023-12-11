import '../../gen/pubspec.dart' as pubspec;

class UrlConstants {
  const UrlConstants._();
  static const githubRepo = pubspec.repository;
  static const privacyPolicy = '$githubRepo/tree/main/doc/privacy_policy.md';
}
