part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    // General
    @Default(AppLanguague.system) AppLanguague appLanguague,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppThemeSystem.material3) AppThemeSystem themeSystem,
    @Default(AppLayoutMode.auto) AppLayoutMode layoutMode,
    @Default(true) bool isAnimationsEnabled,
    @Default(false) darkDuringDayInAutoMode,
    @Default(true) bool openOnBoardingScreen,
    // Notes
    @Default(true) bool confirmDeleteNote,
    @Default(false) bool confirmMoveNoteToTrash,
    @Default(true) bool useNoteGridTile,
    @Default(false) bool syncWithCloudDefaultValue,
    @Default(true) bool onlySaveDataWhenClick,
    @Default(true) bool autoSaveNote,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
