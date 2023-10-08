import '../../shared/file_storage_exceptions.dart';

sealed class LocalStorageException extends FileStorageException {
  const LocalStorageException(super.message);
}

final class LocalStorageCopyException extends FileStorageException {
  const LocalStorageCopyException(super.message);
}

final class LocalStorageDeleteException extends FileStorageException {
  const LocalStorageDeleteException(super.message);
}
