import '../../../core/errors/exceptions.dart';

class DatabaseOperationException extends AppException {
  const DatabaseOperationException(super.message);
}

final class DatabaseOperationInvalidParameterException
    extends DatabaseOperationException {
  const DatabaseOperationInvalidParameterException(super.message);
}

final class DatabaseOperationFaieldException
    extends DatabaseOperationException {
  const DatabaseOperationFaieldException(super.message);
}

final class DatabaseOperationCannotFindResourcesException
    extends DatabaseOperationFaieldException {
  const DatabaseOperationCannotFindResourcesException(super.message);
}
