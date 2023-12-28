import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;

import '../../../data/note_folder/models/m_note_folder.dart';
import '../../../data/note_folder/note_folder_repository.dart';

part 'note_folder_state.dart';

class NoteFolderCubit extends Cubit<NoteFolderState> {
  NoteFolderCubit({required this.noteFoldersService})
      : super(const NoteFolderState(noteFolders: [], currentFolder: null)) {
    emit(state.copyWith(isLoading: true));
    getFolders();
  }

  final NoteFolderRepository noteFoldersService;

  Future<void> getFolders() async {
    emit(
      state.copyWith(
        noteFolders: await noteFoldersService.getNoteFolders(),
        isLoading: false,
      ),
    );
  }

  Future<void> createNote(String folderName) async {
    try {
      final folder =
          await noteFoldersService.createFolder(folderName: folderName);
      emit(
        state.copyWith(
          noteFolders: [
            ...state.noteFolders,
            folder,
          ],
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  void navigateToFolder(NoteFolder folder) {
    emit(state.copyWith(currentFolder: folder));
  }

  void navigateBack() {
    assert(
      state.currentFolder != null,
      'The current folder should not be null to navigate back',
    );
    final currentFolder = state.currentFolder;
    if (currentFolder == null) {
      return;
    }

    final parentFolderPath = path.dirname(currentFolder.folderPath);

    NoteFolder? targetFolder;
    NoteFolder searchingFolder = currentFolder;
    for (final subFolder in searchingFolder.subFolders) {
      if (subFolder.folderPath == parentFolderPath) {
        targetFolder = subFolder;
        break;
      }
      if (subFolder.subFolders.isEmpty) {
        emit(state.copyWith(currentFolder: null));
        break;
      }
      searchingFolder = subFolder;
    }

    emit(state.copyWith(currentFolder: targetFolder));
  }
}
