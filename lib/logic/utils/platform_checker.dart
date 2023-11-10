import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformChecker {
  const PlatformChecker._();

  static bool isWeb() => kIsWeb;

  static bool isAppleSystem() {
    if (isWeb()) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  static bool isIOS() {
    if (isWeb()) return false;
    return Platform.isIOS;
  }

  static bool isAndroid() {
    if (isWeb()) return false;
    return Platform.isAndroid;
  }

  static bool isFuchsia() {
    if (isWeb()) return false;
    return Platform.isAndroid;
  }

  static bool isMobile() {
    if (isWeb()) return false;
    return isIOS() || isAndroid() | isFuchsia();
  }
}
