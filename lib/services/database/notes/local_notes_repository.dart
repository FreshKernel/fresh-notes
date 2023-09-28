import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/database/notes/models/m_local_note.dart';

import '../shared/local_database_repository.dart';

// I abstracted this functionallities of the notes
// I don't plan to use another database or sql with different library
// but I want to add support for web later since sqflite doesn't support web
abstract class LocalNotesRepository
    extends LocalDatabaseRepository<LocalNote, NoteInput, String> {}
