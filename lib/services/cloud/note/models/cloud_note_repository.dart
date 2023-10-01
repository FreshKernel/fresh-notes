import 'package:my_notes/services/cloud/shared/cloud_database_repository.dart';
import 'package:my_notes/services/data/notes/models/m_note_input.dart';

import 'm_cloud_note.dart';

abstract class CloudNotesRepository extends CloudDatabaseRepository<CloudNote,
    CreateNoteInput, UpdateNoteInput, String> {}
