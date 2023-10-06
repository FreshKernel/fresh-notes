import '../errors/exceptions.dart';

class ServiceNotInitializedException extends AppException {
  const ServiceNotInitializedException(super.message);
}

class ServiceAlreadyInitilizedException extends AppException {
  const ServiceAlreadyInitilizedException(super.message);
}
