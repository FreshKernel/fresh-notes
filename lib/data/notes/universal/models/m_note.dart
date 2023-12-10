import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/cloud/database/sync_options.dart';
import '../../cloud/models/m_cloud_note.dart';
import '../../local/models/m_local_note.dart';

part 'm_note.freezed.dart';

@freezed
class UniversalNote with _$UniversalNote {
  const factory UniversalNote({
    required String id, // Note id only
    required String userId,
    required String title,
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required bool isTrash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UniversalNote;

  factory UniversalNote.fromLocalNote(
    LocalNote note,
  ) =>
      UniversalNote(
        id: note.noteId,
        userId: note.userId,
        title: note.title,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: note.isSyncWithCloud,
          existingCloudNoteId: note.cloudId,
        ),
        isPrivate: note.isPrivate,
        isTrash: note.isTrash,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );

  factory UniversalNote.fromCloudNote(
    CloudNote note,
  ) =>
      UniversalNote(
        id: note.noteId,
        userId: note.userId,
        title: note.title,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: true,
          existingCloudNoteId: note.id,
        ),
        isPrivate: note.isPrivate,
        isTrash: note.isTrash,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
}

class UniversalNoteProperties {
  const UniversalNoteProperties._();

  static const notes = 'notes';

  /// Id for the item in database, example in Firebase and Sqlite
  static const entryId = 'id';
  static const noteId = 'noteId';
  static const userId = 'userId';
  static const title = 'title';
  static const text = 'text';
  static const cloudId = 'cloudId';
  static const isSyncWithCloud = 'isSyncWithCloud';
  static const isPrivate = 'isPrivate';
  static const isTrash = 'isTrash';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}
