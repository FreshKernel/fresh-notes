abstract class AppReport {
  Future<void> reportError(
      {required Exception exception, required StackTrace stackTrace});
}
