import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_notes/services/cloud/shared/sync_options.dart';
import 'package:my_notes/services/database/notes/models/m_local_note.dart';

part 'm_note.freezed.dart';

// @freezed
// class NoteInput with _$NoteInput {
//   const factory NoteInput({
//     required String text,
//     required bool isSyncedWithCloud,
//     required String userId,
//   }) = _NoteInput;
//   factory NoteInput.fromNote(Note note) => NoteInput(
//         text: note.text,
//         isSyncedWithCloud: note.isSyncedWithCloud,
//         userId: note.userId,
//       );
//   static LocalNote toLocalNote(
//     NoteInput input, {
//     required String id,
//     required DateTime createdAt,
//     required DateTime updatedAt,
//   }) =>
//       LocalNote(
//         id: id,
//         userId: input.userId,
//         text: input.text,
//         createdAt: createdAt,
//         updatedAt: updatedAt,
//       );
// }

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String userId,
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;
  factory Note.fromLocalNote(
    LocalNote note,
  ) =>
      Note(
        id: note.id,
        userId: note.userId,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: note.isSyncWithCloud,
          existingCloudNoteId: note.cloudId,
        ),
        isPrivate: note.isPrivate,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );
}

class NoteProperties {
  const NoteProperties._();

  static const notes = 'notes';

  static const id = 'id';
  static const userId = 'userId';
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
//   text,
//   cloudId,
//   isPrivate,
//   createdAt,
//   updatedAt;

//   @override
//   String toString() => name;
// }
