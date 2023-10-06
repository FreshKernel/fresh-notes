import '../errors/exceptions.dart';

// TODO: All of the app exceptions should implements AppException
// TODO: All services should implements AppService
// TODO: Improve Auth exceptions, LocalDatabase Exceptions
// TODO: See the app again and try to share common things, for example
// isInitialized should be shared into the AppService and not repeeat it again and again

class ServiceNotInitializedException extends AppException {
  const ServiceNotInitializedException(super.message);
}

class ServiceAlreadyInitilizedException extends AppException {
  const ServiceAlreadyInitilizedException(super.message);
}
