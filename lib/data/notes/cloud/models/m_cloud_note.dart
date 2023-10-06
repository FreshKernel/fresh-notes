import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../universal/models/m_note.dart';
import '../../universal/models/m_note_inputs.dart';

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
        userId: map[CloudNoteProperties.userId] as String,
        text: map[CloudNoteProperties.text] as String,
        isPrivate: map[CloudNoteProperties.isPrivate] as bool,
        createdAt: (map[CloudNoteProperties.createdAt] as Timestamp).toDate(),
        updatedAt: (map[CloudNoteProperties.updatedAt] as Timestamp).toDate(),
      );

  static Map<String, Object?> toFirebaseMapFromCreateInput({
    required CreateNoteInput input,
  }) {
    return {
      CloudNoteProperties.userId: input.userId,
      CloudNoteProperties.text: input.text,
      CloudNoteProperties.isPrivate: input.isPrivate,
      CloudNoteProperties.createdAt: FieldValue.serverTimestamp(),
      CloudNoteProperties.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static Map<String, Object?> toFirebaseMapFromUpdateInput({
    required UpdateNoteInput input,
  }) {
    return {
      CloudNoteProperties.text: input.text,
      CloudNoteProperties.isPrivate: input.isPrivate,
      CloudNoteProperties.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}

typedef CloudNoteProperties = UniversalNoteProperties;
