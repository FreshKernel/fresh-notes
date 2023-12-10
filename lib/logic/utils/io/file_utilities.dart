import 'package:cross_file/cross_file.dart';
import 'package:path/path.dart' as path;

class FileUtilities {
  const FileUtilities._();

  static Iterable<String> generateNewFileNames({
    required Iterable<String> paths,
    required String newFileStartsWith,
  }) {
    final files = paths.map(XFile.new);
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
