import 'package:meta/meta.dart';

enum AppStore { googlePlay, unknown }

@immutable
class FlavorConfig {
  const FlavorConfig._();

  /// Example `Google Play`
  static late final AppStore _appStore;
  static AppStore get appStore => _appStore;

  static late final bool _isShouldCheckForUpdates;
  static bool get isShouldCheckForUpdates => _isShouldCheckForUpdates;

  static void setup({
    required String appStore,
    required bool isShouldCheckForUpdates,
  }) {
    _appStore = switch (appStore) {
      'Google Play' => AppStore.googlePlay,
      String() => AppStore.unknown,
    };
    _isShouldCheckForUpdates = isShouldCheckForUpdates;
  }
}
