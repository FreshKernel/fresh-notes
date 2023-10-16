part of 'settings_cubit.dart';

enum AppThemeMode {
  dark,
  light,
  system,
  auto,
}

enum AppLanguague {
  en,
  ar,
  system,
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool confirmDeleteNote,
    @Default(false) bool syncWithCloudDefaultValue,
    @Default(true) bool onlySaveDataWhenClick,
    @Default(false) darkDuringDayInAutoMode,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppLanguague.system) AppLanguague appLanguague,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
