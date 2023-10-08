import '../../shared/file_storage_exceptions.dart';

sealed class CloudStorageException extends FileStorageException {
  const CloudStorageException(super.message);
}

final class CloudStorageUploadException extends CloudStorageException {
  const CloudStorageUploadException(super.message);
}

final class CloudStorageGetFileUrlException extends CloudStorageException {
  const CloudStorageGetFileUrlException(super.message);
}

final class CloudStorageDeleteFileException extends CloudStorageException {
  const CloudStorageDeleteFileException(super.message);
}

final class CloudStorageFileNoFoundException extends CloudStorageException {
  const CloudStorageFileNoFoundException(super.message);
}
