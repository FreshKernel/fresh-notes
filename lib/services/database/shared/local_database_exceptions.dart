import 'package:my_notes/core/errors/exceptions.dart';

class LocalDatabaseException extends AppException {
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

class ParametersErrorLocalDatabaseException extends LocalDatabaseException {
  const ParametersErrorLocalDatabaseException(super.message);
}

class LocalDatabaseOperationFaieldException extends LocalDatabaseException {
  const LocalDatabaseOperationFaieldException(super.message);
}
