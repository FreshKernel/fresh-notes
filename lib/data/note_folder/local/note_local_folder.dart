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
      {required String folderName, required NoteFolder? currentFolder}) async {
    final documentsDirectory = (await _getNoteFoldersDirectory()).path;
    final newFolderPath = currentFolder == null
        ? path.join(documentsDirectory, folderName)
        : path.join(
            documentsDirectory,
            currentFolder.folderName,
            folderName,
          );
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

    final List<NoteFolder> folders = [
      const NoteFolder(
        folderPath: 'Empty folder',
        subFolders: [],
        notes: [],
      ),
      const NoteFolder(
        folderPath: 'V',
        subFolders: [
          NoteFolder(folderPath: 'Adam Smasher', subFolders: [
            NoteFolder(folderPath: 'Arasaka', subFolders: [], notes: [])
          ], notes: []),
          NoteFolder(folderPath: 'Kurt hansan', subFolders: [], notes: []),
        ],
        notes: [],
      )
    ];

    // folders.clear();
    // for (final entity in noteFoldersDirectory.listSync()) {
    //   if (entity is Directory) {
    //     folders.add(
    //       NoteFolder(
    //         folderPath: entity.path,
    //         subFolders: const [],
    //         notes: const [],
    //       ),
    //     );
    //   } else if (entity is File) {}
    // }

    return folders;
  }

  @override
  Future<void> updateFolder(
      {required String folderName,
      required List<UniversalNote> noteFolders,
      required List<NoteFolder> subFolders}) async {}
}
