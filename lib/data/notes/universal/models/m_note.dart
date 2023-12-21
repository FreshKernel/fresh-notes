import 'package:equatable/equatable.dart';

import '../../cloud/models/m_cloud_note.dart';
import '../../local/models/m_local_note.dart';
import 'm_note_inputs.dart';

// part 'm_note.freezed.dart';

class UniversalNote extends Equatable {
  const UniversalNote({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.text,
    required this.isSyncWithCloud,
    required this.isPrivate,
    required this.isTrash,
    required this.createdAt,
    required this.updatedAt,
  });
  factory UniversalNote.fromLocalNote(
    LocalNote note,
  ) =>
      UniversalNote(
        noteId: note.noteId,
        userId: note.userId,
        title: note.title,
        text: note.text,
        isSyncWithCloud: note.isSyncWithCloud,
        isPrivate: note.isPrivate,
        isTrash: note.isTrash,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );

  factory UniversalNote.fromCloudNote(
    CloudNote note,
  ) =>
      UniversalNote(
        noteId: note.noteId,
        userId: note.userId,
        title: note.title,
        text: note.text,
        isSyncWithCloud: true,
        isPrivate: note.isPrivate,
        isTrash: note.isTrash,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
      );

  factory UniversalNote.fromCreateInput(
    CreateNoteInput input, {
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isExistsInTheCloud,
  }) =>
      UniversalNote(
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

  factory UniversalNote.fromUpdateInput(
    UpdateNoteInput input, {
    required DateTime createdAt,
    required DateTime updatedAt,
    required String? userId,
  }) =>
      UniversalNote(
        noteId: input.noteId,
        userId: userId,
        title: input.title,
        text: input.text,
        isSyncWithCloud: input.isSyncWithCloud,
        isPrivate: input.isPrivate,
        isTrash: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  final String noteId;
  final String? userId;
  final String title;
  final String text;
  final bool isSyncWithCloud;
  final bool isPrivate;
  final bool isTrash;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        noteId,
        userId,
        title,
        text,
        isPrivate,
        isTrash,
      ];

  UniversalNote copyWith({
    String? noteId,
    String? userId,
    String? title,
    String? text,
    bool? isSyncWithCloud,
    bool? isPrivate,
    bool? isTrash,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UniversalNote(
      noteId: noteId ?? this.noteId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      text: text ?? this.text,
      isSyncWithCloud: isSyncWithCloud ?? this.isSyncWithCloud,
      isPrivate: isPrivate ?? this.isPrivate,
      isTrash: isTrash ?? this.isTrash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
  // static const cloudId = 'cloudId';
  static const isSyncWithCloud = 'isSyncWithCloud';
  static const isPrivate = 'isPrivate';
  static const isTrash = 'isTrash';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}
