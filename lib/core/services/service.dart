import 'package:my_notes/core/services/exceptions.dart';

abstract class AppService {
  Future<void> initialize();
  bool get isInitialized;
  void requireToBeInitialized({String? errorMessage}) {
    if (!isInitialized) {
      throw ServiceNotInitalizedException(
          errorMessage ?? 'To use this service, please initialize it first.');
    }
  }
}
