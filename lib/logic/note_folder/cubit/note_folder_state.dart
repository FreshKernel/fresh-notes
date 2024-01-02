part of 'note_folder_cubit.dart';

class NoteFolderState extends Equatable {
  const NoteFolderState({
    required this.noteFolders,
    required this.navigationStack,
    this.exception,
    this.isLoading = true,
  });

  final List<NoteFolder> noteFolders;
  final List<NoteFolder> navigationStack;
  final Exception? exception;
  final bool isLoading;

  @override
  List<Object?> get props => [
        navigationStack,
        noteFolders,
        exception,
        isLoading,
      ];

  NoteFolderState copyWith({
    List<NoteFolder>? noteFolders,
    List<NoteFolder>? navigationStack,
    Exception? exception,
    bool? isLoading,
  }) {
    return NoteFolderState(
      noteFolders: noteFolders ?? this.noteFolders,
      navigationStack: navigationStack ?? this.navigationStack,
      exception: exception ?? this.exception,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
