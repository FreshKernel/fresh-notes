import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/notes/cloud/models/m_cloud_note.dart';
import '../../../core/cloud/database/sync_options.dart';

part 'm_note_inputs.freezed.dart';

@freezed
class CreateNoteInput with _$CreateNoteInput {
  const factory CreateNoteInput({
    required String title,
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required String userId,
  }) = _CreateNoteInput;
  factory CreateNoteInput.fromCloudNote(CloudNote note) => CreateNoteInput(
        title: note.title,
        text: note.text,
        syncOptions: SyncOptions.getSyncOptions(
          isSyncWithCloud: true,
          existingCloudNoteId: note.id,
        ),
        isPrivate: note.isPrivate,
        userId: note.userId,
      );
  factory CreateNoteInput.fromUpdateInput(
    UpdateNoteInput input, {
    required String userId,
  }) =>
      CreateNoteInput(
        title: input.title,
        text: input.text,
        syncOptions: input.syncOptions,
        isPrivate: input.isPrivate,
        userId: userId,
      );
}

// extension CreateNoteInputExtensions on CreateNoteInput {}

@freezed
class UpdateNoteInput with _$UpdateNoteInput {
  const factory UpdateNoteInput({
    required String text,
    required String title,
    required SyncOptions syncOptions,
    required bool isPrivate,
  }) = _UpdateNoteInput;
}
