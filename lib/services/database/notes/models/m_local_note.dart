import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_notes/models/note/m_note.dart';

part 'm_local_note.freezed.dart';
part 'm_local_note.g.dart';

@freezed
class LocalNote with _$LocalNote {
  const factory LocalNote({
    required String id,
    required String userId,
    required String text,
    @Default(true) bool isSyncedWithCloud,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _LocalNote;

  factory LocalNote.fromJson(Map<String, Object?> json) =>
      _$LocalNoteFromJson(json);

  // This time I decided to make life simple and easier by
  // use the same exact name of the variable in sqlite and dart.
  factory LocalNote.fromSqlite(Map<String, Object?> map) => LocalNote(
        id: (map['id'] as int).toString(),
        userId: map['userId'] as String,
        text: map['text'] as String,
        isSyncedWithCloud: (map['isSyncedWithCloud'] as int) == 1,
        createdAt: DateTime.parse(map['updatedAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );

  static Map<String, Object?> toSqlite(NoteInput instance) {
    return {
      'userId': instance.userId,
      'text': instance.text,
      'isSyncedWithCloud': instance.isSyncedWithCloud ? 1 : 0,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static const sqlTableName = 'notes';

  static const createSqlTable = '''
    CREATE TABLE IF NOT EXISTS "$sqlTableName" (
      "id"	INTEGER NOT NULL UNIQUE,
      "userId"	TEXT NOT NULL,
      "text"	TEXT NOT NULL,
      "isSyncedWithCloud"	INTEGER NOT NULL DEFAULT 1,
      "createdAt"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      "updatedAt"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    ''';
  // ON UPDATE CURRENT_TIMESTAMP
}
