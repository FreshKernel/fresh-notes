import 'exceptions.dart';

abstract class AppService {
  const AppService();
  Future<void> initialize();
  bool get isInitialized;
  void requireToBeInitialized({String? errorMessage}) {
    if (!isInitialized) {
      throw ServiceNotInitializedException(
          errorMessage ?? 'To use this service, please initialize it first.');
    }
  }

  Future<void> deInitialize();
}
