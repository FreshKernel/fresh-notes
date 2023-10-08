import '../../../core/errors/exceptions.dart';

abstract class FileStorageException extends AppException {
  const FileStorageException(super.message);
}
