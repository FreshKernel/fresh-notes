class LocalDatabaseException implements Exception {
  final String? message;

  const LocalDatabaseException(this.message);

  @override
  String toString() => message.toString();
}

class UnknownLocalDatabaseErrorException extends LocalDatabaseException {
  const UnknownLocalDatabaseErrorException(super.message);
}

class GenericLocalDatabaseErrorException extends LocalDatabaseException {
  const GenericLocalDatabaseErrorException(super.message);
}

class LocalDatabaseAlreadyInitializedException extends LocalDatabaseException {
  const LocalDatabaseAlreadyInitializedException(super.message);
}

class FailedToInitalizeLocalDatabaseException extends LocalDatabaseException {
  const FailedToInitalizeLocalDatabaseException(super.message);
}

class LocalDatabaseNotInitalizedException extends LocalDatabaseException {
  const LocalDatabaseNotInitalizedException(super.message);
}

class ParametersErrorLocalDatabaseException extends LocalDatabaseException {
  const ParametersErrorLocalDatabaseException(super.message);
}

class LocalDatabaseOperationFaieldException extends LocalDatabaseException {
  const LocalDatabaseOperationFaieldException(super.message);
}
