import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../cloud_storage_exceptions.dart';
import '../cloud_storage_repository.dart';

class FirebaseCloudStorageImpl extends CloudStorageRepository {
  late final _storage = FirebaseStorage.instance;

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw CloudStorageDeleteFileException(
        'Error while delete file in firebase storage: ${e.toString()}',
      );
    }
  }

  @override
  Future<String?> getFileURL(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw CloudStorageGetFileUrlException(
        'Error while get download url in firebase storage: ${e.toString()}',
      );
    }
  }

  @override
  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.putFile(file);
      final url = await result.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw CloudStorageUploadException(
        'Error while upload file in firebase storage: ${e.toString()}\n',
      );
    }
  }

  @override
  Future<Iterable<String>> uploadMultipleFiles(
      Iterable<(String, File)> list) async {
    final fileUrls = <String>[];
    for (final (path, file) in list) {
      final url = await uploadFile(path, file);
      fileUrls.add(url);
    }
    return fileUrls;
  }

  @override
  Future<void> deleteMultipleFiles(Iterable<String> paths) async {
    for (final path in paths) {
      await deleteFile(path);
    }
  }
}
