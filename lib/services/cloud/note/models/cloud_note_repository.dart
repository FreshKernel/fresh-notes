import '../../../data/notes/models/m_note_input.dart';
import '../../shared/cloud_database_repository.dart';
import 'm_cloud_note.dart';

abstract class CloudNotesRepository extends CloudDatabaseRepository<CloudNote,
    CreateNoteInput, UpdateNoteInput, String> {}
