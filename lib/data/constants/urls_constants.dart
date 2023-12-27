import '../../gen/pubspec.dart' as pubspec;

class UrlConstants {
  const UrlConstants._();
  static const githubRepo = pubspec.repository;
  static const sourceCode = '$githubRepo/tree/main';
  static const privacyPolicy = '$sourceCode/doc/privacy_policy.md';
  static const webUrl = 'https://notes.freshplatform.net';
}
