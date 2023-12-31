// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'note_cubit.dart';

@immutable
class NoteState extends Equatable {
  const NoteState({
    required this.notes,
    this.isLoading = true,
    this.message = '',
    this.exception,
  });
  factory NoteState.initial() {
    return const NoteState(
      notes: [],
      exception: null,
      isLoading: true,
    );
  }

  final List<UniversalNote> notes;
  final Exception? exception;
  final String message;
  final bool isLoading;

  List<UniversalNote> get trashNotes =>
      notes.where((note) => note.isTrash).toList();

  List<UniversalNote> get nonTrashNotes =>
      notes.where((note) => !note.isTrash).toList();

  @override
  List<Object?> get props => [
        notes,
        isLoading,
        exception,
        message,
      ];

  NoteState copyWith({
    List<UniversalNote>? notes,
    Exception? exception,
    String? message,
    bool? isLoading,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      exception: exception ?? this.exception,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
