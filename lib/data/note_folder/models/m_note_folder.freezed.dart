// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_note_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NoteFolder {
  String get folderName => throw _privateConstructorUsedError;
  List<Directory> get folders => throw _privateConstructorUsedError;
  List<UniversalNote> get notes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteFolderCopyWith<NoteFolder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteFolderCopyWith<$Res> {
  factory $NoteFolderCopyWith(
          NoteFolder value, $Res Function(NoteFolder) then) =
      _$NoteFolderCopyWithImpl<$Res, NoteFolder>;
  @useResult
  $Res call(
      {String folderName, List<Directory> folders, List<UniversalNote> notes});
}

/// @nodoc
class _$NoteFolderCopyWithImpl<$Res, $Val extends NoteFolder>
    implements $NoteFolderCopyWith<$Res> {
  _$NoteFolderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folderName = null,
    Object? folders = null,
    Object? notes = null,
  }) {
    return _then(_value.copyWith(
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      folders: null == folders
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<Directory>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<UniversalNote>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteFolderImplCopyWith<$Res>
    implements $NoteFolderCopyWith<$Res> {
  factory _$$NoteFolderImplCopyWith(
          _$NoteFolderImpl value, $Res Function(_$NoteFolderImpl) then) =
      __$$NoteFolderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String folderName, List<Directory> folders, List<UniversalNote> notes});
}

/// @nodoc
class __$$NoteFolderImplCopyWithImpl<$Res>
    extends _$NoteFolderCopyWithImpl<$Res, _$NoteFolderImpl>
    implements _$$NoteFolderImplCopyWith<$Res> {
  __$$NoteFolderImplCopyWithImpl(
      _$NoteFolderImpl _value, $Res Function(_$NoteFolderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? folderName = null,
    Object? folders = null,
    Object? notes = null,
  }) {
    return _then(_$NoteFolderImpl(
      folderName: null == folderName
          ? _value.folderName
          : folderName // ignore: cast_nullable_to_non_nullable
              as String,
      folders: null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<Directory>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<UniversalNote>,
    ));
  }
}

/// @nodoc

class _$NoteFolderImpl implements _NoteFolder {
  const _$NoteFolderImpl(
      {required this.folderName,
      required final List<Directory> folders,
      required final List<UniversalNote> notes})
      : _folders = folders,
        _notes = notes;

  @override
  final String folderName;
  final List<Directory> _folders;
  @override
  List<Directory> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  final List<UniversalNote> _notes;
  @override
  List<UniversalNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  String toString() {
    return 'NoteFolder(folderName: $folderName, folders: $folders, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteFolderImpl &&
            (identical(other.folderName, folderName) ||
                other.folderName == folderName) &&
            const DeepCollectionEquality().equals(other._folders, _folders) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      folderName,
      const DeepCollectionEquality().hash(_folders),
      const DeepCollectionEquality().hash(_notes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteFolderImplCopyWith<_$NoteFolderImpl> get copyWith =>
      __$$NoteFolderImplCopyWithImpl<_$NoteFolderImpl>(this, _$identity);
}

abstract class _NoteFolder implements NoteFolder {
  const factory _NoteFolder(
      {required final String folderName,
      required final List<Directory> folders,
      required final List<UniversalNote> notes}) = _$NoteFolderImpl;

  @override
  String get folderName;
  @override
  List<Directory> get folders;
  @override
  List<UniversalNote> get notes;
  @override
  @JsonKey(ignore: true)
  _$$NoteFolderImplCopyWith<_$NoteFolderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
