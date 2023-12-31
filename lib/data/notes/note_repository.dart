import 'universal/models/m_note.dart';
import 'universal/models/m_note_inputs.dart';

abstract class NotesRepository {
  Future<UniversalNote> insertNote(CreateNoteInput createInput);
  Future<Iterable<UniversalNote>> insertNotes(Iterable<CreateNoteInput> inputs);
  Future<UniversalNote?> getNoteById(String id);
  Future<Iterable<UniversalNote>> getAllNotes({
    required int limit, // Defaults to -1
    required int page, // Defaults to 1
  });
  Future<Iterable<UniversalNote>> searchAllNotes({
    required String searchQuery,
  });
  Future<Iterable<UniversalNote>> getAllNotesByIds(Iterable<String> ids);
  Future<void> deleteNotesByIds(Iterable<String> ids);
  Future<void> updateNotesByIds(Iterable<UpdateNoteInput> inputs);
  Future<UniversalNote?> updateNote(UpdateNoteInput updateInput);
  Future<void> deleteNoteById(String id);
  Future<void> deleteAllNotes();
}
