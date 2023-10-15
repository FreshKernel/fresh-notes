// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      confirmDeleteNote: json['confirmDeleteNote'] as bool? ?? true,
      syncWithCloudDefaultValue:
          json['syncWithCloudDefaultValue'] as bool? ?? false,
      onlySaveDataWhenClick: json['onlySaveDataWhenClick'] as bool? ?? true,
      themeMode:
          $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
              AppThemeMode.system,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'confirmDeleteNote': instance.confirmDeleteNote,
      'syncWithCloudDefaultValue': instance.syncWithCloudDefaultValue,
      'onlySaveDataWhenClick': instance.onlySaveDataWhenClick,
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
    };

const _$AppThemeModeEnumMap = {
  AppThemeMode.dark: 'dark',
  AppThemeMode.light: 'light',
  AppThemeMode.system: 'system',
};
