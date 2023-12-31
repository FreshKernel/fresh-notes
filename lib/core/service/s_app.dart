import '../errors/exceptions.dart';

class ServiceNotInitializedException extends AppException {
  const ServiceNotInitializedException(super.message);
}

class ServiceAlreadyInitilizedException extends AppException {
  const ServiceAlreadyInitilizedException(super.message);
}

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
