import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/cloud/database/sync_options.dart';
import '../../cloud/models/m_cloud_note.dart';
import '../../local/models/m_local_note.dart';

part 'm_note.freezed.dart';

@freezed
class UniversalNote with _$UniversalNote {
  const factory UniversalNote({
    required String id,
    required String userId,
    required String title,
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UniversalNote;

  factory UniversalNote.fromLocalNote(
    LocalNote note,
  ) =>
      UniversalNote(
        id: note.id,
        userId: note.userId,
        title: note.title,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: note.isSyncWithCloud,
          existingCloudNoteId: note.cloudId,
        ),
        isPrivate: note.isPrivate,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );

  factory UniversalNote.fromCloudNote(
    CloudNote note,
  ) =>
      UniversalNote(
        id: note.id,
        userId: note.userId,
        title: note.title,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: true,
          existingCloudNoteId: note.id,
        ),
        isPrivate: note.isPrivate,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
}

class UniversalNoteProperties {
  const UniversalNoteProperties._();

  static const notes = 'notes';

  static const id = 'id';
  static const userId = 'userId';
  static const title = 'title';
  static const text = 'text';
  static const cloudId = 'cloudId';
  static const isSyncWithCloud = 'isSyncWithCloud';
  static const isPrivate = 'isPrivate';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}

// enum NotePropertiesEnum {
//   id,
//   userId,
//   title,
//   text,
//   cloudId,
//   isPrivate,
//   createdAt,
//   updatedAt;

//   @override
//   String toString() => name;
// }
