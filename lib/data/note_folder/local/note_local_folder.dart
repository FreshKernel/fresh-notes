import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../notes/universal/models/m_note.dart';
import '../models/m_note_folder.dart';
import '../note_folder_repository.dart';

class LocalNoteFolderImpl extends NotesFolderRepository {
  Future<Directory> _getNoteFoldersDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final noteFoldersDirectory =
        Directory(path.join(documentsDirectory.path, 'note-folders'));
    return noteFoldersDirectory;
  }

  @override
  Future<NoteFolder> createFolder(
      {required String folderName, NoteFolder? currentFolder}) async {
    final newFolderPath =
        path.join((await _getNoteFoldersDirectory()).path, folderName);
    await Directory(newFolderPath).create(recursive: true);
    return NoteFolder(
      folderPath: newFolderPath,
      subFolders: const [],
      notes: const [],
    );
  }

  @override
  Future<void> deleteFolder({required String folderName}) async {}

  @override
  Future<List<NoteFolder>> getNoteFolders() async {
    final noteFoldersDirectory = await _getNoteFoldersDirectory();
    await noteFoldersDirectory.create(recursive: true);
    final folders = noteFoldersDirectory
        .listSync()
        .map(
          (event) => NoteFolder(
            folderPath: event.path,
            subFolders: const [],
            notes: [
              // Dump note
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
    return folders;
  }

  @override
  Future<void> updateFolder(
      {required String folderName,
      required List<UniversalNote> noteFolders,
      required List<NoteFolder> subFolders}) async {}
}
