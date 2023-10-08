import '../../shared/database_operations_exceptions.dart';

class LocalDatabaseException extends DatabaseOperationException {
  const LocalDatabaseException(super.message);
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

class FailedToInitializeLocalDatabaseException extends LocalDatabaseException {
  const FailedToInitializeLocalDatabaseException(super.message);
}
