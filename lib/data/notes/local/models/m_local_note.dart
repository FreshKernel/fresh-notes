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
    required String userId,
    required String text,
    required String? cloudId,
    required bool isSyncWithCloud,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LocalNote;
  // ON UPDATE CURRENT_TIMESTAMP

  factory LocalNote._fromInputSharedLogic({
    required String id,
    required String userId,
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      LocalNote(
        id: id,
        userId: userId,
        text: text,
        isPrivate: isPrivate,
        cloudId: syncOptions.getCloudNoteId(),
        isSyncWithCloud: syncOptions.isSyncWithCloud,
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
        userId: input.userId,
        text: input.text,
        syncOptions: input.syncOptions,
        isPrivate: input.isPrivate,
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
        userId: userId,
        text: input.text,
        syncOptions: input.syncOptions,
        isPrivate: input.isPrivate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory LocalNote.fromJson(Map<String, Object?> json) =>
      _$LocalNoteFromJson(json);

  // factory LocalNote.fromCloudNote(CloudNote note) => LocalNote(
  //       id: note.id,
  //       userId: note.userId,
  //       text: note.text,
  //       cloudId: note.id,
  //       isSyncWithCloud: true,
  //       isPrivate: note.isPrivate,
  //       createdAt: note.createdAt,
  //       updatedAt: note.updatedAt,
  //     );

  // This time I decided to make life simple and easier by
  // use the same exact name of the variable in sqlite and dart.
  factory LocalNote.fromSqlite(Map<String, Object?> map) => LocalNote(
        id: (map[LocalNoteProperties.id] as int).toString(),
        userId: map[LocalNoteProperties.userId] as String,
        text: map[LocalNoteProperties.text] as String,
        cloudId: map[LocalNoteProperties.cloudId] as String?,
        isSyncWithCloud:
            (map[LocalNoteProperties.isSyncWithCloud] as int).toBoolean(),
        isPrivate: (map[LocalNoteProperties.isPrivate] as int).toBoolean(),
        createdAt: DateTime.parse(map[LocalNoteProperties.createdAt] as String),
        updatedAt: DateTime.parse(map[LocalNoteProperties.updatedAt] as String),
      );

  static SqlMapData _toSqliteMapSharedLogic({
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
  }) {
    return {
      LocalNoteProperties.text: SqlValue.string(text),
      LocalNoteProperties.cloudId:
          SqlValue.string(syncOptions.getCloudNoteId()),
      LocalNoteProperties.isSyncWithCloud:
          SqlValue.num(syncOptions.isSyncWithCloud.toInt()),
      LocalNoteProperties.isPrivate: SqlValue.num(isPrivate.toInt()),
    };
  }

  static SqlMapData toSqliteMapFromCreateInput(
      {required CreateNoteInput input}) {
    final sharedInputData = _toSqliteMapSharedLogic(
      text: input.text,
      syncOptions: input.syncOptions,
      isPrivate: input.isPrivate,
    );
    final SqlMapData data = {
      ...sharedInputData,
      LocalNoteProperties.userId: SqlValue.string(input.userId),
    };
    return data;
  }

  static SqlMapData toSqliteMapFromUpdateInput({
    required UpdateNoteInput input,
  }) {
    final sharedInputData = _toSqliteMapSharedLogic(
      text: input.text,
      syncOptions: input.syncOptions,
      isPrivate: input.isPrivate,
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
      "${LocalNoteProperties.id}"	INTEGER NOT NULL UNIQUE,
      "${LocalNoteProperties.userId}"	TEXT NOT NULL,
      "${LocalNoteProperties.text}"	TEXT NOT NULL,
      "${LocalNoteProperties.cloudId}" TEXT,
      "${LocalNoteProperties.isSyncWithCloud}" INTEGER NOT NULL,
      "${LocalNoteProperties.isPrivate}"	INTEGER NOT NULL,
      "${LocalNoteProperties.createdAt}"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      "${LocalNoteProperties.updatedAt}"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY("${LocalNoteProperties.id}" AUTOINCREMENT)
    );
    ''';
}

typedef LocalNoteProperties = UniversalNoteProperties;
