import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/note_folder/models/m_note_folder.dart';
import '../../../data/note_folder/note_folder_repository.dart';

part 'note_folder_state.dart';

class NoteFolderCubit extends Cubit<NoteFolderState> {
  NoteFolderCubit({required this.noteFoldersService})
      : super(const NoteFolderState(noteFolders: [])) {
    emit(const NoteFolderState(noteFolders: [], isLoading: true));
    getFolders();
  }

  final NoteFolderRepository noteFoldersService;

  Future<void> getFolders() async {
    emit(
      NoteFolderState(
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
        NoteFolderState(
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
}
