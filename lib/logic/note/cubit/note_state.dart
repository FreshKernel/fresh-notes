// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'note_cubit.dart';

@immutable
class NoteState extends Equatable {
  const NoteState({required this.notes, this.exception});
  factory NoteState.initial() {
    return const NoteState(notes: [], exception: null);
  }

  final List<UniversalNote> notes;
  final Exception? exception;

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
