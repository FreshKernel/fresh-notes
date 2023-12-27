import 'dart:io' show Directory;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import '../../../data/note_folder/models/m_note_folder.dart';
import '../../../data/notes/universal/models/m_note.dart';

part 'note_folder_state.dart';

class NoteFolderCubit extends Cubit<NoteFolderState> {
  NoteFolderCubit() : super(const NoteFolderState(folders: []));

  Future<void> getFolders() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final noteFoldersDirectory =
        Directory(path.join(documentsDirectory.path, 'note-folders'));
    final folders = noteFoldersDirectory
        .listSync()
        .map(
          (event) => NoteFolder(
            folderName: path.basename(event.path),
            folders: [],
            notes: [
              UniversalNote(
                noteId: 'noteId',
                userId: 'userId',
                title: 'title',
                text: 'text',
                isSyncWithCloud: true,
                isPrivate: false,
                isTrash: false,
                isFavorite: false,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            ],
          ),
        )
        .toList();
    emit(NoteFolderState(
      folders: folders,
    ));
  }
}
