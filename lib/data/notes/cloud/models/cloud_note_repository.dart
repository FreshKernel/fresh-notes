import '../../../core/cloud/database/cloud_database_repository.dart';
import '../../universal/models/m_note_inputs.dart';
import 'm_cloud_note.dart';

abstract class CloudNotesRepository extends CloudDatabaseRepository<CloudNote,
    CreateNoteInput, UpdateNoteInput, String> {}
