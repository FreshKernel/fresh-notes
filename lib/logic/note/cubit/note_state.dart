part of 'note_cubit.dart';

@freezed
class NoteState with _$NoteState {
  const factory NoteState() = _NoteState;
  factory NoteState.initial() {
    return const NoteState();
  }
}
