part of 'note_folder_cubit.dart';

class NoteFolderState extends Equatable {
  const NoteFolderState({required this.folders});

  final List<NoteFolder> folders;

  @override
  List<Object?> get props => [
        folders,
      ];
}
