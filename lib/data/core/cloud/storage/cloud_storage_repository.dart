import 'dart:io' show File;

abstract class CloudStorageRepository {
  Future<String> uploadFile(String path, File file);
  Future<Iterable<String>> uploadMultipleFiles(
    Iterable<(String path, File file)> list,
  );
  Future<String?> getFileURL(String path);
  Future<void> deleteMultipleFilesByDownloadUrls(Iterable<String> downloadUrls);
  Future<void> deleteFileByDownloadUrl(String downloadUrl);
}
