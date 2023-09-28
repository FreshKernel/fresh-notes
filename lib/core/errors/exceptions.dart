class AppException implements Exception {
  final String? message;

  const AppException(this.message);

  @override
  String toString() => 'App exception: $message';
}
