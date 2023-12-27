import '../notes/universal/models/m_note.dart';
import 'models/m_note_folder.dart';

abstract class NoteFolderRepository {
  Future<NoteFolder> createFolder({required String folderName});
  Future<void> deleteFolder({required String folderName});
  Future<void> updateFolder({
    required String folderName,
    required List<UniversalNote> noteFolders,
    required List<NoteFolder> subFolders,
  });
  Future<List<NoteFolder>> getNoteFolders();
}
