// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      appLanguague:
          $enumDecodeNullable(_$AppLanguagueEnumMap, json['appLanguague']) ??
              AppLanguague.system,
      themeMode:
          $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
              AppThemeMode.system,
      themeSystem:
          $enumDecodeNullable(_$AppThemeSystemEnumMap, json['themeSystem']) ??
              AppThemeSystem.material3,
      layoutMode:
          $enumDecodeNullable(_$AppLayoutModeEnumMap, json['layoutMode']) ??
              AppLayoutMode.auto,
      isAnimationsEnabled: json['isAnimationsEnabled'] as bool? ?? true,
      darkDuringDayInAutoMode: json['darkDuringDayInAutoMode'] ?? false,
      openOnBoardingScreen: json['openOnBoardingScreen'] as bool? ?? true,
      confirmDeleteNote: json['confirmDeleteNote'] as bool? ?? true,
      confirmMoveNoteToTrash: json['confirmMoveNoteToTrash'] as bool? ?? false,
      useNoteGridTile: json['useNoteGridTile'] as bool? ?? true,
      syncWithCloudDefaultValue:
          json['syncWithCloudDefaultValue'] as bool? ?? false,
      onlySaveDataWhenClick: json['onlySaveDataWhenClick'] as bool? ?? true,
      autoSaveNote: json['autoSaveNote'] as bool? ?? true,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'appLanguague': _$AppLanguagueEnumMap[instance.appLanguague]!,
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'themeSystem': _$AppThemeSystemEnumMap[instance.themeSystem]!,
      'layoutMode': _$AppLayoutModeEnumMap[instance.layoutMode]!,
      'isAnimationsEnabled': instance.isAnimationsEnabled,
      'darkDuringDayInAutoMode': instance.darkDuringDayInAutoMode,
      'openOnBoardingScreen': instance.openOnBoardingScreen,
      'confirmDeleteNote': instance.confirmDeleteNote,
      'confirmMoveNoteToTrash': instance.confirmMoveNoteToTrash,
      'useNoteGridTile': instance.useNoteGridTile,
      'syncWithCloudDefaultValue': instance.syncWithCloudDefaultValue,
      'onlySaveDataWhenClick': instance.onlySaveDataWhenClick,
      'autoSaveNote': instance.autoSaveNote,
    };

const _$AppLanguagueEnumMap = {
  AppLanguague.system: 'system',
  AppLanguague.en: 'en',
  AppLanguague.ar: 'ar',
};

const _$AppThemeModeEnumMap = {
  AppThemeMode.dark: 'dark',
  AppThemeMode.light: 'light',
  AppThemeMode.system: 'system',
  AppThemeMode.auto: 'auto',
  AppThemeMode.random: 'random',
};

const _$AppThemeSystemEnumMap = {
  AppThemeSystem.material3: 'material3',
  AppThemeSystem.material2: 'material2',
  AppThemeSystem.cupertino: 'cupertino',
};

const _$AppLayoutModeEnumMap = {
  AppLayoutMode.auto: 'auto',
  AppLayoutMode.small: 'small',
  AppLayoutMode.large: 'large',
};
