import 'dart:io' show File;
import 'package:path/path.dart' as path;

class FileUtilities {
  const FileUtilities._();

  static Iterable<String> generateNewFileNames(
    Iterable<File> files, {
    required String newFileStartsWith,
  }) {
    return files.map((file) {
      final fileExtensionWithDot = path.extension(file.path);
      final currentDateAsString = DateTime.now().toIso8601String();
      final newImageFileName =
          '$newFileStartsWith$currentDateAsString$fileExtensionWithDot';
      final newFilePath = path.join(newImageFileName);
      return newFilePath;
    });
  }
}
