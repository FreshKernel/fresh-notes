import 'package:equatable/equatable.dart';

import '../../../core/cloud/database/sync_options.dart';
import '../../cloud/models/m_cloud_note.dart';
import '../../local/models/m_local_note.dart';
import 'm_note_inputs.dart';

// part 'm_note.freezed.dart';

class UniversalNote extends Equatable {
  // const factory UniversalNote({
  //   required String id, // Note id only
  //   required String userId,
  //   required String title,
  //   required String text,
  //   required SyncOptions syncOptions,
  //   required bool isPrivate,
  //   required bool isTrash,
  //   required DateTime createdAt,
  //   required DateTime updatedAt,
  // }) = _UniversalNote;

  const UniversalNote({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.text,
    required this.syncOptions,
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
        noteId: note.noteId,
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

  factory UniversalNote.fromCreateInput(
    CreateNoteInput input, {
    required DateTime createdAt,
    required DateTime updatedAt,
  }) =>
      UniversalNote(
        noteId: input.noteId,
        userId: input.userId,
        title: input.title,
        text: input.text,
        syncOptions: input.syncOptions,
        isPrivate: input.isPrivate,
        isTrash: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory UniversalNote.fromUpdateInput(
    UpdateNoteInput input, {
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) =>
      UniversalNote(
        noteId: input.noteId,
        userId: userId,
        title: input.title,
        text: input.text,
        syncOptions: input.syncOptions,
        isPrivate: input.isPrivate,
        isTrash: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  final String noteId;
  final String userId;
  final String title;
  final String text;
  final SyncOptions syncOptions;
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
    SyncOptions? syncOptions,
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
      syncOptions: syncOptions ?? this.syncOptions,
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
  static const cloudId = 'cloudId';
  static const isSyncWithCloud = 'isSyncWithCloud';
  static const isPrivate = 'isPrivate';
  static const isTrash = 'isTrash';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
}
