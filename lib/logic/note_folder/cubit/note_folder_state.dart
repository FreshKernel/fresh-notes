part of 'note_folder_cubit.dart';

class NoteFolderState extends Equatable {
  const NoteFolderState({
    required this.noteFolders,
    this.exception,
    this.isLoading = false,
  });

  final List<NoteFolder> noteFolders;
  final Exception? exception;
  final bool isLoading;

  @override
  List<Object?> get props => [
        noteFolders,
        exception,
        isLoading,
      ];

  NoteFolderState copyWith({
    List<NoteFolder>? noteFolders,
    Exception? exception,
  }) {
    return NoteFolderState(
      noteFolders: noteFolders ?? this.noteFolders,
      exception: exception ?? this.exception,
    );
  }
}
