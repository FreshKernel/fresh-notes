// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) {
  return _SettingsState.fromJson(json);
}

/// @nodoc
mixin _$SettingsState {
  bool get confirmDeleteNote => throw _privateConstructorUsedError;
  bool get syncWithCloudDefaultValue => throw _privateConstructorUsedError;
  bool get onlySaveDataWhenClick => throw _privateConstructorUsedError;
  dynamic get darkDuringDayInAutoMode => throw _privateConstructorUsedError;
  AppThemeMode get themeMode => throw _privateConstructorUsedError;
  AppLanguague get appLanguague => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call(
      {bool confirmDeleteNote,
      bool syncWithCloudDefaultValue,
      bool onlySaveDataWhenClick,
      dynamic darkDuringDayInAutoMode,
      AppThemeMode themeMode,
      AppLanguague appLanguague});
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmDeleteNote = null,
    Object? syncWithCloudDefaultValue = null,
    Object? onlySaveDataWhenClick = null,
    Object? darkDuringDayInAutoMode = freezed,
    Object? themeMode = null,
    Object? appLanguague = null,
  }) {
    return _then(_value.copyWith(
      confirmDeleteNote: null == confirmDeleteNote
          ? _value.confirmDeleteNote
          : confirmDeleteNote // ignore: cast_nullable_to_non_nullable
              as bool,
      syncWithCloudDefaultValue: null == syncWithCloudDefaultValue
          ? _value.syncWithCloudDefaultValue
          : syncWithCloudDefaultValue // ignore: cast_nullable_to_non_nullable
              as bool,
      onlySaveDataWhenClick: null == onlySaveDataWhenClick
          ? _value.onlySaveDataWhenClick
          : onlySaveDataWhenClick // ignore: cast_nullable_to_non_nullable
              as bool,
      darkDuringDayInAutoMode: freezed == darkDuringDayInAutoMode
          ? _value.darkDuringDayInAutoMode
          : darkDuringDayInAutoMode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      appLanguague: null == appLanguague
          ? _value.appLanguague
          : appLanguague // ignore: cast_nullable_to_non_nullable
              as AppLanguague,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
          _$SettingsStateImpl value, $Res Function(_$SettingsStateImpl) then) =
      __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool confirmDeleteNote,
      bool syncWithCloudDefaultValue,
      bool onlySaveDataWhenClick,
      dynamic darkDuringDayInAutoMode,
      AppThemeMode themeMode,
      AppLanguague appLanguague});
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
      _$SettingsStateImpl _value, $Res Function(_$SettingsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmDeleteNote = null,
    Object? syncWithCloudDefaultValue = null,
    Object? onlySaveDataWhenClick = null,
    Object? darkDuringDayInAutoMode = freezed,
    Object? themeMode = null,
    Object? appLanguague = null,
  }) {
    return _then(_$SettingsStateImpl(
      confirmDeleteNote: null == confirmDeleteNote
          ? _value.confirmDeleteNote
          : confirmDeleteNote // ignore: cast_nullable_to_non_nullable
              as bool,
      syncWithCloudDefaultValue: null == syncWithCloudDefaultValue
          ? _value.syncWithCloudDefaultValue
          : syncWithCloudDefaultValue // ignore: cast_nullable_to_non_nullable
              as bool,
      onlySaveDataWhenClick: null == onlySaveDataWhenClick
          ? _value.onlySaveDataWhenClick
          : onlySaveDataWhenClick // ignore: cast_nullable_to_non_nullable
              as bool,
      darkDuringDayInAutoMode: freezed == darkDuringDayInAutoMode
          ? _value.darkDuringDayInAutoMode!
          : darkDuringDayInAutoMode,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as AppThemeMode,
      appLanguague: null == appLanguague
          ? _value.appLanguague
          : appLanguague // ignore: cast_nullable_to_non_nullable
              as AppLanguague,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl(
      {this.confirmDeleteNote = true,
      this.syncWithCloudDefaultValue = false,
      this.onlySaveDataWhenClick = true,
      this.darkDuringDayInAutoMode = false,
      this.themeMode = AppThemeMode.system,
      this.appLanguague = AppLanguague.system});

  factory _$SettingsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsStateImplFromJson(json);

  @override
  @JsonKey()
  final bool confirmDeleteNote;
  @override
  @JsonKey()
  final bool syncWithCloudDefaultValue;
  @override
  @JsonKey()
  final bool onlySaveDataWhenClick;
  @override
  @JsonKey()
  final dynamic darkDuringDayInAutoMode;
  @override
  @JsonKey()
  final AppThemeMode themeMode;
  @override
  @JsonKey()
  final AppLanguague appLanguague;

  @override
  String toString() {
    return 'SettingsState(confirmDeleteNote: $confirmDeleteNote, syncWithCloudDefaultValue: $syncWithCloudDefaultValue, onlySaveDataWhenClick: $onlySaveDataWhenClick, darkDuringDayInAutoMode: $darkDuringDayInAutoMode, themeMode: $themeMode, appLanguague: $appLanguague)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.confirmDeleteNote, confirmDeleteNote) ||
                other.confirmDeleteNote == confirmDeleteNote) &&
            (identical(other.syncWithCloudDefaultValue,
                    syncWithCloudDefaultValue) ||
                other.syncWithCloudDefaultValue == syncWithCloudDefaultValue) &&
            (identical(other.onlySaveDataWhenClick, onlySaveDataWhenClick) ||
                other.onlySaveDataWhenClick == onlySaveDataWhenClick) &&
            const DeepCollectionEquality().equals(
                other.darkDuringDayInAutoMode, darkDuringDayInAutoMode) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.appLanguague, appLanguague) ||
                other.appLanguague == appLanguague));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      confirmDeleteNote,
      syncWithCloudDefaultValue,
      onlySaveDataWhenClick,
      const DeepCollectionEquality().hash(darkDuringDayInAutoMode),
      themeMode,
      appLanguague);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsStateImplToJson(
      this,
    );
  }
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState(
      {final bool confirmDeleteNote,
      final bool syncWithCloudDefaultValue,
      final bool onlySaveDataWhenClick,
      final dynamic darkDuringDayInAutoMode,
      final AppThemeMode themeMode,
      final AppLanguague appLanguague}) = _$SettingsStateImpl;

  factory _SettingsState.fromJson(Map<String, dynamic> json) =
      _$SettingsStateImpl.fromJson;

  @override
  bool get confirmDeleteNote;
  @override
  bool get syncWithCloudDefaultValue;
  @override
  bool get onlySaveDataWhenClick;
  @override
  dynamic get darkDuringDayInAutoMode;
  @override
  AppThemeMode get themeMode;
  @override
  AppLanguague get appLanguague;
  @override
  @JsonKey(ignore: true)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
