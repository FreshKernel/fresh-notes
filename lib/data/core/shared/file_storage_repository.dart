// For now, we don't need this to be a service
abstract class FileStorageRepository {
  Future<void> deleteFile(String path);
}
