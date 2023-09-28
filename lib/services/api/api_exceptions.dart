class ApiException implements Exception {
  final String? message;

  const ApiException(this.message);
}

class NetworkRequestException extends ApiException {
  const NetworkRequestException(super.message);
}

class TooManyNetworkRequestsException extends NetworkRequestException {
  const TooManyNetworkRequestsException(super.message);
}
