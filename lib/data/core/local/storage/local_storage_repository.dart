import 'dart:io' show Directory, File;

import '../../shared/file_storage_repository.dart';

abstract class LocalStorageRepository extends FileStorageRepository {
  Future<List<File>> copyMultipleFile({
    required List<File> files,
    required List<String> names,
    required Directory directory,
  });
}
