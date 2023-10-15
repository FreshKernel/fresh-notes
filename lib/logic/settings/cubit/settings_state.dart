part of 'settings_cubit.dart';

enum AppThemeMode {
  dark,
  light,
  system,
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool confirmDeleteNote,
    @Default(false) bool syncWithCloudDefaultValue,
    @Default(true) bool onlySaveDataWhenClick,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
