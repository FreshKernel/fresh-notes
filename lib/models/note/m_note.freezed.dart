// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NoteInput {
  String get text => throw _privateConstructorUsedError;
  bool get isSyncedWithCloud => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteInputCopyWith<NoteInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteInputCopyWith<$Res> {
  factory $NoteInputCopyWith(NoteInput value, $Res Function(NoteInput) then) =
      _$NoteInputCopyWithImpl<$Res, NoteInput>;
  @useResult
  $Res call({String text, bool isSyncedWithCloud, String userId});
}

/// @nodoc
class _$NoteInputCopyWithImpl<$Res, $Val extends NoteInput>
    implements $NoteInputCopyWith<$Res> {
  _$NoteInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isSyncedWithCloud = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isSyncedWithCloud: null == isSyncedWithCloud
          ? _value.isSyncedWithCloud
          : isSyncedWithCloud // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NoteInputCopyWith<$Res> implements $NoteInputCopyWith<$Res> {
  factory _$$_NoteInputCopyWith(
          _$_NoteInput value, $Res Function(_$_NoteInput) then) =
      __$$_NoteInputCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, bool isSyncedWithCloud, String userId});
}

/// @nodoc
class __$$_NoteInputCopyWithImpl<$Res>
    extends _$NoteInputCopyWithImpl<$Res, _$_NoteInput>
    implements _$$_NoteInputCopyWith<$Res> {
  __$$_NoteInputCopyWithImpl(
      _$_NoteInput _value, $Res Function(_$_NoteInput) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isSyncedWithCloud = null,
    Object? userId = null,
  }) {
    return _then(_$_NoteInput(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isSyncedWithCloud: null == isSyncedWithCloud
          ? _value.isSyncedWithCloud
          : isSyncedWithCloud // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_NoteInput implements _NoteInput {
  const _$_NoteInput(
      {required this.text,
      required this.isSyncedWithCloud,
      required this.userId});

  @override
  final String text;
  @override
  final bool isSyncedWithCloud;
  @override
  final String userId;

  @override
  String toString() {
    return 'NoteInput(text: $text, isSyncedWithCloud: $isSyncedWithCloud, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NoteInput &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isSyncedWithCloud, isSyncedWithCloud) ||
                other.isSyncedWithCloud == isSyncedWithCloud) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, isSyncedWithCloud, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoteInputCopyWith<_$_NoteInput> get copyWith =>
      __$$_NoteInputCopyWithImpl<_$_NoteInput>(this, _$identity);
}

abstract class _NoteInput implements NoteInput {
  const factory _NoteInput(
      {required final String text,
      required final bool isSyncedWithCloud,
      required final String userId}) = _$_NoteInput;

  @override
  String get text;
  @override
  bool get isSyncedWithCloud;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$_NoteInputCopyWith<_$_NoteInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isSyncedWithCloud => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String text,
      bool isSyncedWithCloud,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? text = null,
    Object? isSyncedWithCloud = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isSyncedWithCloud: null == isSyncedWithCloud
          ? _value.isSyncedWithCloud
          : isSyncedWithCloud // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NoteCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$_NoteCopyWith(_$_Note value, $Res Function(_$_Note) then) =
      __$$_NoteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String text,
      bool isSyncedWithCloud,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$_NoteCopyWithImpl<$Res> extends _$NoteCopyWithImpl<$Res, _$_Note>
    implements _$$_NoteCopyWith<$Res> {
  __$$_NoteCopyWithImpl(_$_Note _value, $Res Function(_$_Note) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? text = null,
    Object? isSyncedWithCloud = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_Note(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isSyncedWithCloud: null == isSyncedWithCloud
          ? _value.isSyncedWithCloud
          : isSyncedWithCloud // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_Note implements _Note {
  const _$_Note(
      {required this.id,
      required this.userId,
      required this.text,
      this.isSyncedWithCloud = true,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String text;
  @override
  @JsonKey()
  final bool isSyncedWithCloud;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, text: $text, isSyncedWithCloud: $isSyncedWithCloud, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Note &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isSyncedWithCloud, isSyncedWithCloud) ||
                other.isSyncedWithCloud == isSyncedWithCloud) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, text, isSyncedWithCloud, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NoteCopyWith<_$_Note> get copyWith =>
      __$$_NoteCopyWithImpl<_$_Note>(this, _$identity);
}

abstract class _Note implements Note {
  const factory _Note(
      {required final String id,
      required final String userId,
      required final String text,
      final bool isSyncedWithCloud,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$_Note;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get text;
  @override
  bool get isSyncedWithCloud;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_NoteCopyWith<_$_Note> get copyWith => throw _privateConstructorUsedError;
}
