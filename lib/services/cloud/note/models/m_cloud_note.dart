import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../models/note/m_note.dart';
import '../../../data/notes/models/m_note_input.dart';
// import 'package:my_notes/services/database/notes/models/m_local_note.dart';

part 'm_cloud_note.freezed.dart';
part 'm_cloud_note.g.dart';

@freezed
class CloudNote with _$CloudNote {
  const factory CloudNote({
    required String id, // the document id
    required String userId,
    required String text,
    required bool isPrivate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CloudNote;

  factory CloudNote.fromJson(Map<String, Object?> json) =>
      _$CloudNoteFromJson(json);

  // factory CloudNote.fromLocalNote(LocalNote note, String cloudId) => CloudNote(
  //       id: cloudId,
  //       userId: note.userId,
  //       text: note.text,
  //       createdAt: note.createdAt,
  //       updatedAt: note.updatedAt,
  //     );

  factory CloudNote.fromCreateNoteInput({
    required CreateNoteInput input,
    required String cloudId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      CloudNote(
        id: cloudId,
        userId: input.userId,
        text: input.text,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isPrivate: input.isPrivate,
      );

  factory CloudNote.fromUpdateNoteInput({
    required UpdateNoteInput input,
    required String cloudId,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      CloudNote(
        id: cloudId,
        userId: userId,
        text: input.text,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isPrivate: input.isPrivate,
      );

  factory CloudNote.fromFirebase(
    Map<String, Object?> map, {
    required String id,
  }) =>
      CloudNote(
        id: id,
        userId: map[NoteProperties.userId] as String,
        text: map[NoteProperties.text] as String,
        isPrivate: map[NoteProperties.isPrivate] as bool,
        createdAt: (map[NoteProperties.createdAt] as Timestamp).toDate(),
        updatedAt: (map[NoteProperties.updatedAt] as Timestamp).toDate(),
      );

  static Map<String, Object?> toFirebaseMapFromCreateInput({
    required CreateNoteInput input,
  }) {
    return {
      NoteProperties.userId: input.userId,
      NoteProperties.text: input.text,
      NoteProperties.isPrivate: input.isPrivate,
      NoteProperties.createdAt: FieldValue.serverTimestamp(),
      NoteProperties.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static Map<String, Object?> toFirebaseMapFromUpdateInput({
    required UpdateNoteInput input,
  }) {
    return {
      NoteProperties.text: input.text,
      NoteProperties.isPrivate: input.isPrivate,
      NoteProperties.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}

typedef CloudNoteProperties = NoteProperties;
