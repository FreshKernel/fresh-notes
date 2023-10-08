import 'dart:io' show File;

import '../../shared/file_storage_repository.dart';

// For now, we don't need this to be a service
abstract class CloudStorageRepository extends FileStorageRepository {
  Future<String?> uploadFile(String path, File file);
  Future<Iterable<String?>> uploadMultipleFiles(
    Iterable<(String path, File file)> list,
  );
  Future<String?> getFileURL(String path);
}
