import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/core/cloud/sync_options.dart';
import '../../../../data/notes/cloud/models/m_cloud_note.dart';

part 'm_note_input.freezed.dart';

@freezed
class CreateNoteInput with _$CreateNoteInput {
  const factory CreateNoteInput({
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required String userId,
  }) = _CreateNoteInput;
  factory CreateNoteInput.fromCloudNote(CloudNote note) => CreateNoteInput(
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: true,
          existingCloudNoteId: note.id,
        ),
        isPrivate: note.isPrivate,
        userId: note.userId,
      );
}

// extension CreateNoteInputExtensions on CreateNoteInput {}

@freezed
class UpdateNoteInput with _$UpdateNoteInput {
  const factory UpdateNoteInput({
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
  }) = _UpdateNoteInput;
}
