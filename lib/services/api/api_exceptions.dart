import 'package:my_notes/core/errors/exceptions.dart';

class ApiException extends AppException {
  const ApiException(super.message);
}

class NetworkRequestException extends ApiException {
  const NetworkRequestException(super.message);
}
