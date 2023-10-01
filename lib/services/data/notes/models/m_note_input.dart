import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_notes/services/cloud/shared/sync_options.dart';

part 'm_note_input.freezed.dart';

/// This is for creating a note but also for updating a note
/// it might changed in the future
@freezed
class CreateNoteInput with _$CreateNoteInput {
  const factory CreateNoteInput({
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
    required String userId,
  }) = _CreateNoteInput;
}

// If it works, then don't touch it for now.

@freezed
class UpdateNoteInput with _$UpdateNoteInput {
  const factory UpdateNoteInput({
    required String text,
    required SyncOptions syncOptions,
    required bool isPrivate,
  }) = _UpdateNoteInput;
}
