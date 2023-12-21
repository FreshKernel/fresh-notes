import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Timestamp;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../universal/models/m_note.dart';
import '../../universal/models/m_note_inputs.dart';

part 'm_cloud_note.freezed.dart';
part 'm_cloud_note.g.dart';

@freezed
class CloudNote with _$CloudNote {
  const factory CloudNote({
    required String id, // the document id
    required String noteId,
    required String? userId,
    required String title,
    required String text,
    required bool isPrivate,
    required bool isTrash,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CloudNote;

  factory CloudNote.fromJson(Map<String, Object?> json) =>
      _$CloudNoteFromJson(json);

  factory CloudNote.fromCreateNoteInput({
    required CreateNoteInput input,
    required String cloudId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      CloudNote(
        id: cloudId,
        noteId: input.noteId,
        userId: input.userId,
        title: input.title,
        text: input.text,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isPrivate: input.isPrivate,
        isTrash: false,
      );

  factory CloudNote.fromUpdateNoteInput({
    required UpdateNoteInput input,
    required String cloudId,
    required String? userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      CloudNote(
        id: cloudId,
        noteId: input.noteId,
        userId: userId,
        title: input.title,
        text: input.text,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isPrivate: input.isPrivate,
        isTrash: input.isTrash,
      );

  factory CloudNote.fromFirebase(
    Map<String, Object?> map, {
    required String id,
  }) =>
      CloudNote(
        id: id,
        noteId: map[CloudNoteProperties.noteId] as String,
        userId: map[CloudNoteProperties.userId] as String,
        title: map[CloudNoteProperties.title] as String,
        text: map[CloudNoteProperties.text] as String,
        isPrivate: map[CloudNoteProperties.isPrivate] as bool,
        isTrash: map[CloudNoteProperties.isTrash] as bool,
        createdAt: (map[CloudNoteProperties.createdAt] as Timestamp).toDate(),
        updatedAt: (map[CloudNoteProperties.updatedAt] as Timestamp).toDate(),
      );

  /// This will be used in [toFirebaseMapFromCreateInput] and
  /// [toFirebaseMapFromUpdateInput]
  static Map<String, Object?> _toFirebaseMapSharedLogic({
    required bool isPrivate,
    required bool isTrash,
    required String title,
    required String text,
  }) {
    return {
      CloudNoteProperties.title: title,
      CloudNoteProperties.text: text,
      CloudNoteProperties.isPrivate: isPrivate,
      CloudNoteProperties.isTrash: isTrash,
      CloudNoteProperties.updatedAt: FieldValue.serverTimestamp(),
    };
  }

  static Map<String, Object?> toFirebaseMapFromCreateInput({
    required CreateNoteInput input,
  }) {
    final sharedInputData = _toFirebaseMapSharedLogic(
      isPrivate: input.isPrivate,
      title: input.title,
      text: input.text,
      isTrash: false,
    );
    return {
      ...sharedInputData,
      CloudNoteProperties.userId: input.userId,
      CloudNoteProperties.createdAt: FieldValue.serverTimestamp(),
      CloudNoteProperties.noteId: input.noteId,
    };
  }

  static Map<String, Object?> toFirebaseMapFromUpdateInput({
    required UpdateNoteInput input,
  }) {
    final sharedInputData = _toFirebaseMapSharedLogic(
      isPrivate: input.isPrivate,
      title: input.title,
      text: input.text,
      isTrash: input.isTrash,
    );
    return {
      ...sharedInputData,
    };
  }
}

typedef CloudNoteProperties = UniversalNoteProperties;
