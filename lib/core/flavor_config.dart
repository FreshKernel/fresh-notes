import 'package:meta/meta.dart';

@immutable
class FlavorConfig {
  const FlavorConfig._();

  /// Example `Android`
  static late final String _name;
  static String get name => _name;

  /// Example `Google Play`
  static late final String _appStore;
  static String get appStore => _appStore;

  static late final bool _isShouldCheckForUpdates;
  static bool get isShouldCheckForUpdates => _isShouldCheckForUpdates;

  static void setup({
    required String name,
    required String appStore,
    required bool isShouldCheckForUpdates,
  }) {
    _name = name;
    _appStore = appStore;
    _isShouldCheckForUpdates = isShouldCheckForUpdates;
  }
}
