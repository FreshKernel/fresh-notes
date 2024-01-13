import 'package:meta/meta.dart';

import '../extensions/uri.dart';

@immutable
class GlobalValidator {
  const GlobalValidator._();
  static String? validateTextIsEmpty(String text,
      {required String errorMessage}) {
    if (text.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static bool isValidImageUrl(String url) {
    try {
      final allowedExtensions = [
        'png',
        'jpg',
        'jpeg',
        'gif',
        'bmp',
        'webp',
        'tiff'
      ];
      final uri = Uri.parse(url);
      return uri.isHttpsBasedUrl() &&
          uri.isAbsolute &&
          allowedExtensions.contains(
            uri.pathSegments.last.split('.').last,
          );
    } catch (_) {
      return false;
    }
  }
}
