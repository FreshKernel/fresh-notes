import 'dart:io';

import '../../../../core/app_module.dart';
import 'cloud_storage_exceptions.dart';
import 'cloud_storage_repository.dart';
import 'packages/firebase_storage_impl.dart';

class CloudStorageService extends CloudStorageRepository {
  CloudStorageService(this._provider);

  factory CloudStorageService.firebase() => CloudStorageService(
        FirebaseCloudStorageImpl(),
      );

  factory CloudStorageService.getInstance() => AppModule.cloudStorageService;

  final CloudStorageRepository _provider;
  @override
  Future<void> deleteFile(String path) => _provider.deleteFile(path);

  @override
  Future<String?> getFileURL(String path) => _provider.getFileURL(path);

  @override
  Future<String> uploadFile(String path, File file) async {
    final fileExists = await file.exists();
    if (!fileExists) {
      throw CloudStorageFileNoFoundException(
        "The file: ${file.path} does not exists so can't upload it to $path",
      );
    }
    final downloadUrl = await _provider.uploadFile(path, file);
    return downloadUrl;
  }

  @override
  Future<Iterable<String>> uploadMultipleFiles(Iterable<(String, File)> list) =>
      _provider.uploadMultipleFiles(list);

  @override
  Future<void> deleteMultipleFiles(Iterable<String> paths) =>
      _provider.deleteMultipleFiles(paths);
}
