import 'dart:io' show Directory, File;

import '../../../../core/app_module.dart';
import 'local_storage_impl.dart';
import 'local_storage_repository.dart';

class LocalStorageService extends LocalStorageRepository {
  LocalStorageService(this._provider);

  factory LocalStorageService.defaultImpl() =>
      LocalStorageService(LocalStorageImpl());
  factory LocalStorageService.getInstance() => AppModule.localStorageService;

  final LocalStorageRepository _provider;

  @override
  Future<List<File>> copyMultipleFile(
      {required List<File> files,
      required List<String> names,
      required Directory directory}) async {
    await directory.create(recursive: true);
    return _provider.copyMultipleFile(
      files: files,
      names: names,
      directory: directory,
    );
  }

  @override
  Future<void> deleteFile(String path) => _provider.deleteFile(path);
}
