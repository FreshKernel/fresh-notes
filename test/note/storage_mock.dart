import 'dart:io';

import 'package:fresh_notes/data/core/cloud/storage/cloud_storage_repository.dart';
import 'package:fresh_notes/data/core/local/storage/local_storage_repository.dart';

class LocalStorageMock extends LocalStorageRepository {
  @override
  Future<List<File>> copyMultipleFile(
      {required List<File> files,
      required List<String> names,
      required Directory directory}) async {
    return files;
  }
}

class CloudStorageMock extends CloudStorageRepository {
  @override
  Future<void> deleteFileByDownloadUrl(String downloadUrl) async {}

  @override
  Future<void> deleteMultipleFilesByDownloadUrls(
      Iterable<String> downloadUrls) async {}

  @override
  Future<String?> getFileURL(String path) async {
    return path;
  }

  @override
  Future<String> uploadFile(String path, File file) async {
    return path;
  }

  @override
  Future<Iterable<String>> uploadMultipleFiles(
      Iterable<(String, File)> list) async {
    return [];
  }
}
