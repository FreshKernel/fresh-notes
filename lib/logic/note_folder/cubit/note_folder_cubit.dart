import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/note_folder/models/m_note_folder.dart';
import '../../../data/note_folder/note_folder_repository.dart';

part 'note_folder_state.dart';

class NoteFolderCubit extends Cubit<NoteFolderState> {
  NoteFolderCubit({required this.noteFoldersService})
      : super(const NoteFolderState(
          noteFolders: [],
          navigationStack: [],
        )) {
    getFolders();
  }

  final NotesFolderRepository noteFoldersService;

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
      // final folder = await noteFoldersService.createFolder(
      //   folderName: folderName,
      //   currentFolder: state.navigationStack.lastOrNull,
      // );

      // final newFolder = NoteFolder(
      //   folderPath: folderName,
      //   subFolders: const [],
      //   notes: const [],
      // );
      // final currentFolder = state.navigationStack.lastOrNull;
      // if (currentFolder != null) {
      //   final noteFolders = [...state.noteFolders];
      //   final index = noteFolders.indexOf(currentFolder);
      //   noteFolders.removeAt(index);
      //   noteFolders.insert(
      //     index,
      //     currentFolder.copyWith(
      //       subFolders: [...currentFolder.subFolders, newFolder],
      //     ),
      //   );
      //   emit(
      //     state.copyWith(
      //       noteFolders: noteFolders,
      //     ),
      //   );
      //   return;
      // }
      // emit(state.copyWith(
      //   noteFolders: [
      //     ...state.noteFolders,
      //   ],
      // ));
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  void navigateToFolder(NoteFolder folder) {
    emit(state.copyWith(navigationStack: [
      ...state.navigationStack,
      folder,
    ]));
  }

  void navigateBack() {
    assert(
      state.navigationStack.isNotEmpty,
      'The navigation stack should not be empty to navigate back',
    );
    final navigationStack = [...state.navigationStack];
    navigationStack.removeLast();
    emit(state.copyWith(
      navigationStack: navigationStack,
    ));
  }
}
