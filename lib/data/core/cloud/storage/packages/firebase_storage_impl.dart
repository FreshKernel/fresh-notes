import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../cloud_storage_exceptions.dart';
import '../cloud_storage_repository.dart';

class FirebaseCloudStorageImpl extends CloudStorageRepository {
  late final _storage = FirebaseStorage.instance;

  @override
  Future<void> deleteFileByDownloadUrl(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
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
      final result = await ref.putFile(
        file,
        SettableMetadata(
          contentType: lookupMimeType(file.path),
          // customMetadata: // TODO: Set this
        ),
      );
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
  Future<void> deleteMultipleFilesByDownloadUrls(
      Iterable<String> downloadUrls) async {
    for (final downloadUrl in downloadUrls) {
      await deleteFileByDownloadUrl(downloadUrl);
    }
  }
}
