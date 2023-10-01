import 'dart:ui' show Rect;

abstract class AppShare {
  Future<void> shareText(
    String text, {
    required String? subject,
    required Rect? sharePositionOrigin,
  });
}
