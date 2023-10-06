import '../../core/errors/exceptions.dart';

class CrudException extends AppException {
  const CrudException(super.message);
}

class InvalidParameterCrudException extends CrudException {
  const InvalidParameterCrudException(super.message);
}

class CrudOperationFaieldException extends CrudException {
  const CrudOperationFaieldException(super.message);
}

class CrudCannotFindResourcesexception extends CrudOperationFaieldException {
  const CrudCannotFindResourcesexception(super.message);
}
