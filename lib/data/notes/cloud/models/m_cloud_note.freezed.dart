// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_cloud_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CloudNote _$CloudNoteFromJson(Map<String, dynamic> json) {
  return _CloudNote.fromJson(json);
}

/// @nodoc
mixin _$CloudNote {
  String get id => throw _privateConstructorUsedError; // the document id
  String get noteId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  bool get isTrash => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CloudNoteCopyWith<CloudNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CloudNoteCopyWith<$Res> {
  factory $CloudNoteCopyWith(CloudNote value, $Res Function(CloudNote) then) =
      _$CloudNoteCopyWithImpl<$Res, CloudNote>;
  @useResult
  $Res call(
      {String id,
      String noteId,
      String userId,
      String title,
      String text,
      bool isPrivate,
      bool isTrash,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CloudNoteCopyWithImpl<$Res, $Val extends CloudNote>
    implements $CloudNoteCopyWith<$Res> {
  _$CloudNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noteId = null,
    Object? userId = null,
    Object? title = null,
    Object? text = null,
    Object? isPrivate = null,
    Object? isTrash = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      noteId: null == noteId
          ? _value.noteId
          : noteId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrash: null == isTrash
          ? _value.isTrash
          : isTrash // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CloudNoteImplCopyWith<$Res>
    implements $CloudNoteCopyWith<$Res> {
  factory _$$CloudNoteImplCopyWith(
          _$CloudNoteImpl value, $Res Function(_$CloudNoteImpl) then) =
      __$$CloudNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String noteId,
      String userId,
      String title,
      String text,
      bool isPrivate,
      bool isTrash,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$CloudNoteImplCopyWithImpl<$Res>
    extends _$CloudNoteCopyWithImpl<$Res, _$CloudNoteImpl>
    implements _$$CloudNoteImplCopyWith<$Res> {
  __$$CloudNoteImplCopyWithImpl(
      _$CloudNoteImpl _value, $Res Function(_$CloudNoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noteId = null,
    Object? userId = null,
    Object? title = null,
    Object? text = null,
    Object? isPrivate = null,
    Object? isTrash = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CloudNoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      noteId: null == noteId
          ? _value.noteId
          : noteId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrash: null == isTrash
          ? _value.isTrash
          : isTrash // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$CloudNoteImpl implements _CloudNote {
  const _$CloudNoteImpl(
      {required this.id,
      required this.noteId,
      required this.userId,
      required this.title,
      required this.text,
      required this.isPrivate,
      required this.isTrash,
      required this.createdAt,
      required this.updatedAt});

  factory _$CloudNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$CloudNoteImplFromJson(json);

  @override
  final String id;
// the document id
  @override
  final String noteId;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String text;
  @override
  final bool isPrivate;
  @override
  final bool isTrash;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CloudNote(id: $id, noteId: $noteId, userId: $userId, title: $title, text: $text, isPrivate: $isPrivate, isTrash: $isTrash, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CloudNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.noteId, noteId) || other.noteId == noteId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.isTrash, isTrash) || other.isTrash == isTrash) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, noteId, userId, title, text,
      isPrivate, isTrash, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CloudNoteImplCopyWith<_$CloudNoteImpl> get copyWith =>
      __$$CloudNoteImplCopyWithImpl<_$CloudNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CloudNoteImplToJson(
      this,
    );
  }
}

abstract class _CloudNote implements CloudNote {
  const factory _CloudNote(
      {required final String id,
      required final String noteId,
      required final String userId,
      required final String title,
      required final String text,
      required final bool isPrivate,
      required final bool isTrash,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CloudNoteImpl;

  factory _CloudNote.fromJson(Map<String, dynamic> json) =
      _$CloudNoteImpl.fromJson;

  @override
  String get id;
  @override // the document id
  String get noteId;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get text;
  @override
  bool get isPrivate;
  @override
  bool get isTrash;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CloudNoteImplCopyWith<_$CloudNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
