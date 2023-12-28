part of 'note_folder_cubit.dart';

class NoteFolderState extends Equatable {
  const NoteFolderState({
    required this.noteFolders,
    required this.currentFolder,
    this.exception,
    this.isLoading = false,
  });

  final List<NoteFolder> noteFolders;
  final NoteFolder? currentFolder;
  final Exception? exception;
  final bool isLoading;

  @override
  List<Object?> get props => [
        currentFolder,
        noteFolders,
        exception,
        isLoading,
      ];

  NoteFolderState copyWith({
    List<NoteFolder>? noteFolders,
    NoteFolder? currentFolder,
    Exception? exception,
    bool? isLoading,
  }) {
    return NoteFolderState(
      noteFolders: noteFolders ?? this.noteFolders,
      currentFolder: currentFolder ?? currentFolder,
      exception: exception ?? this.exception,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
