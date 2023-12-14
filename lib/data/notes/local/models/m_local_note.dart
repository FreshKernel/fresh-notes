import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../logic/utils/extensions/bool.dart';
import '../../../../logic/utils/extensions/int.dart';
import '../../../core/cloud/database/sync_options.dart';
import '../../../core/local/database/sql_data_type.dart';
import '../../universal/models/m_note.dart';
import '../../universal/models/m_note_inputs.dart';

part 'm_local_note.freezed.dart';
part 'm_local_note.g.dart';

@freezed
class LocalNote with _$LocalNote {
  const factory LocalNote({
    required String id,
    required String noteId,
    required String userId,
    required String title,
    required String text,
    required bool isSyncWithCloud,
    required bool isPrivate,
    required bool isTrash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LocalNote;

  factory LocalNote._fromInputSharedLogic({
    required String id,
    required String noteId,
    required String userId,
    required String title,
    required String text,
    required bool isSyncWithCloud,
    required bool isPrivate,
    required bool isTrash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      LocalNote(
        id: id,
        noteId: noteId,
        userId: userId,
        title: title,
        text: text,
        isPrivate: isPrivate,
        isTrash: isTrash,
        isSyncWithCloud: isSyncWithCloud,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // To return a note after creating it
  factory LocalNote.fromCreateNoteInput({
    required CreateNoteInput input,
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      LocalNote._fromInputSharedLogic(
        id: id,
        noteId: input.noteId,
        userId: input.userId,
        title: input.title,
        text: input.text,
        isSyncWithCloud: input.isSyncWithCloud,
        isPrivate: input.isPrivate,
        isTrash: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  // To return a note after updating it
  factory LocalNote.fromUpdateNoteInput({
    required UpdateNoteInput input,
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) =>
      LocalNote._fromInputSharedLogic(
        id: id,
        noteId: input.noteId,
        userId: userId,
        title: input.title,
        text: input.text,
        isSyncWithCloud: input.isSyncWithCloud,
        isPrivate: input.isPrivate,
        isTrash: input.isTrash,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory LocalNote.fromJson(Map<String, Object?> json) =>
      _$LocalNoteFromJson(json);

  // This time I decided to make life simple and easier by
  // use the same exact name of the variable in sqlite and dart.
  factory LocalNote.fromSqlite(Map<String, Object?> map) => LocalNote(
        id: (map[LocalNoteProperties.entryId] as int).toString(),
        noteId: (map[LocalNoteProperties.noteId] as String).toString(),
        userId: map[LocalNoteProperties.userId] as String,
        title: map[LocalNoteProperties.title] as String,
        text: map[LocalNoteProperties.text] as String,
        isSyncWithCloud:
            (map[LocalNoteProperties.isSyncWithCloud] as int).toBoolean(),
        isPrivate: (map[LocalNoteProperties.isPrivate] as int).toBoolean(),
        isTrash: (map[LocalNoteProperties.isTrash] as int).toBoolean(),
        createdAt: DateTime.parse(map[LocalNoteProperties.createdAt] as String),
        updatedAt: DateTime.parse(map[LocalNoteProperties.updatedAt] as String),
      );

  /// This will be used in [toSqliteMapFromCreateInput] and
  /// [toSqliteMapFromUpdateInput]
  static SqlMapData _toSqliteMapSharedLogic({
    required String title,
    required String text,
    required bool isSyncWithCloud,
    required bool isPrivate,
    required bool isTrash,
  }) {
    return {
      LocalNoteProperties.title: SqlValue.string(title),
      LocalNoteProperties.text: SqlValue.string(text),
      LocalNoteProperties.isSyncWithCloud:
          SqlValue.num(isSyncWithCloud.toInt()),
      LocalNoteProperties.isPrivate: SqlValue.num(isPrivate.toInt()),
      LocalNoteProperties.isTrash: SqlValue.num(isTrash.toInt()),
    };
  }

  static SqlMapData toSqliteMapFromCreateInput({
    required CreateNoteInput input,
  }) {
    final sharedInputData = _toSqliteMapSharedLogic(
      title: input.title,
      text: input.text,
      isSyncWithCloud: input.isSyncWithCloud,
      isPrivate: input.isPrivate,
      isTrash: false,
    );
    final SqlMapData data = {
      ...sharedInputData,
      LocalNoteProperties.noteId: SqlValue.string(input.noteId),
      LocalNoteProperties.userId: SqlValue.string(input.userId),
    };
    return data;
  }

  static SqlMapData toSqliteMapFromUpdateInput({
    required UpdateNoteInput input,
  }) {
    final sharedInputData = _toSqliteMapSharedLogic(
      title: input.title,
      text: input.text,
      isSyncWithCloud: input.isSyncWithCloud,
      isPrivate: input.isPrivate,
      isTrash: input.isTrash,
    );
    return {
      ...sharedInputData,
      LocalNoteProperties.updatedAt:
          SqlValue.string(DateTime.now().toIso8601String()),
    };
  }

  static const sqlTableName = LocalNoteProperties.notes;

  static const createSqlTable = '''
    CREATE TABLE IF NOT EXISTS "$sqlTableName" (
      "${LocalNoteProperties.entryId}"	INTEGER NOT NULL UNIQUE,
      "${LocalNoteProperties.noteId}"	TEXT NOT NULL UNIQUE,
      "${LocalNoteProperties.userId}"	TEXT NOT NULL,
      "${LocalNoteProperties.title}"	TEXT NOT NULL,
      "${LocalNoteProperties.text}"	TEXT NOT NULL,
      "${LocalNoteProperties.isSyncWithCloud}" INTEGER NOT NULL,
      "${LocalNoteProperties.isPrivate}"	INTEGER NOT NULL,
      "${LocalNoteProperties.isTrash}"	INTEGER NOT NULL,
      "${LocalNoteProperties.createdAt}"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      "${LocalNoteProperties.updatedAt}"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY("${LocalNoteProperties.entryId}" AUTOINCREMENT)
    );
    ''';
}

typedef LocalNoteProperties = UniversalNoteProperties;
