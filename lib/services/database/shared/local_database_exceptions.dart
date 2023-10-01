import 'package:my_notes/core/data/crud_exceptions.dart';

class LocalDatabaseException extends CrudException {
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

class FailedToInitalizeLocalDatabaseException extends LocalDatabaseException {
  const FailedToInitalizeLocalDatabaseException(super.message);
}
