part of 'note_cubit.dart';

@immutable
class NoteState extends Equatable {
  const NoteState({
    required this.notes,
    this.exception,
  });
  factory NoteState.initial() {
    return const NoteState(notes: [], exception: null);
  }

  final List<UniversalNote> notes;
  final Exception? exception;

  List<UniversalNote> get trashNotes =>
      notes.where((note) => note.isTrash).toList();

  List<UniversalNote> get nonTrashNotes =>
      notes.where((note) => !note.isTrash).toList();

  @override
  List<Object?> get props => [notes, exception];

  NoteState copyWith({
    List<UniversalNote>? notes,
    Exception? exception,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      exception: exception ?? this.exception,
    );
  }
}
