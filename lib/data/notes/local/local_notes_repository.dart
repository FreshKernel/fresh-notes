import '../../core/local/database/local_database_repository.dart';
import '../universal/models/m_note_inputs.dart';
import 'models/m_local_note.dart';

// I abstracted this functionallities of the notes
// I don't plan to use another database or sql with different library
// but I want to add support for web later since sqflite doesn't support web
abstract class LocalNotesRepository extends LocalDatabaseRepository<LocalNote,
    CreateNoteInput, UpdateNoteInput, String> {}
