import 'dart:io' show Directory, File;

abstract class LocalStorageRepository {
  Future<List<File>> copyMultipleFile({
    required List<File> files,
    required List<String> names,
    required Directory directory,
  });
}
