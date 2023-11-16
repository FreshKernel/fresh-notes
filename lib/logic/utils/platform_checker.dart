import 'package:flutter/foundation.dart'
    show
        TargetPlatform,
        immutable,
        kIsWeb,
        visibleForTesting,
        defaultTargetPlatform;

@immutable
class PlatformChecker {
  factory PlatformChecker.nativePlatform() => _nativePlatform;
  factory PlatformChecker.defaultLogic() => _defaultLogic;
  const PlatformChecker._({
    required this.shouldItWeb,
  });
  static const PlatformChecker _nativePlatform =
      PlatformChecker._(shouldItWeb: false);
  static const PlatformChecker _defaultLogic =
      PlatformChecker._(shouldItWeb: true);
  final bool shouldItWeb;

  static bool isWeb({
    @visibleForTesting bool? overrideValue,
  }) =>
      overrideValue ?? kIsWeb;

  static const applePlatforms = [
    TargetPlatform.iOS,
    TargetPlatform.macOS,
  ];

  bool get _sharedShouldReturnFalse => isWeb() && !shouldItWeb;

  TargetPlatform get _defaultTargetPlatform => defaultTargetPlatform;

  bool isAppleSystem({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return applePlatforms.contains(targetPlatform);
  }

  bool isIOS({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return targetPlatform == TargetPlatform.iOS;
  }

  bool isAndroid({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return targetPlatform == TargetPlatform.android;
  }

  bool isFuchsia({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return targetPlatform == TargetPlatform.fuchsia;
  }

  static const mobilePlatforms = [
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.fuchsia,
  ];

  bool isMobile({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return mobilePlatforms.contains(targetPlatform);
  }

  static const desktopPlatforms = [
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  ];

  bool isDesktop({TargetPlatform? targetPlatform}) {
    if (_sharedShouldReturnFalse) return false;
    targetPlatform ??= _defaultTargetPlatform;
    return desktopPlatforms.contains(targetPlatform);
  }
}
