part of 'settings_cubit.dart';

enum AppThemeMode {
  dark,
  light,
  system,
  auto,
  random,
}

enum AppLanguague {
  system(valueName: 'System'),
  en(valueName: 'English'),
  ar(valueName: 'العربية');

  const AppLanguague({required this.valueName});

  final String valueName;
}

enum AppThemeSystem {
  material3,
  material2,
  cupertino,
  fluentUi,
}

enum AppLayoutMode {
  auto,
  small,
  large,
}

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool confirmDeleteNote,
    @Default(true) bool useNoteGridTile,
    @Default(false) bool syncWithCloudDefaultValue,
    @Default(true) bool onlySaveDataWhenClick,
    @Default(false) darkDuringDayInAutoMode,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppLanguague.system) AppLanguague appLanguague,
    @Default(AppThemeSystem.material3) AppThemeSystem themeSystem,
    @Default(AppLayoutMode.auto) AppLayoutMode layoutMode,
    @Default(true) bool openOnBoardingScreen,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
