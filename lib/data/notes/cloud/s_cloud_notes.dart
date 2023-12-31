import '../../../core/app_module.dart';
import '../note_repository.dart';
import '../universal/models/m_note.dart';
import '../universal/models/m_note_inputs.dart';
import 'packages/firebase_cloud_notes.dart';

class CloudNotesService extends NotesRepository {
  CloudNotesService(this._provider);

  factory CloudNotesService.firebaseFirestore() => CloudNotesService(
        FirebaseCloudNotesImpl(),
      );
  factory CloudNotesService.getInstance() => AppModule.cloudNotesService;

  final NotesRepository _provider;

  @override
  Future<Iterable<UniversalNote>> insertNotes(
          Iterable<CreateNoteInput> inputs) =>
      _provider.insertNotes(inputs);

  @override
  Future<UniversalNote> insertNote(CreateNoteInput createInput) =>
      _provider.insertNote(createInput);

  @override
  Future<void> deleteAllNotes() => _provider.deleteAllNotes();

  @override
  Future<void> deleteNotesByIds(Iterable<String> ids) =>
      _provider.deleteNotesByIds(ids);

  @override
  Future<void> deleteNoteById(String id) => _provider.deleteNoteById(id);

  @override
  Future<Iterable<UniversalNote>> getAllNotes({
    required int limit,
    required int page,
  }) =>
      _provider.getAllNotes(
        limit: limit,
        page: page,
      );

  @override
  Future<Iterable<UniversalNote>> getAllNotesByIds(Iterable<String> ids) =>
      _provider.getAllNotesByIds(ids);

  @override
  Future<UniversalNote?> getNoteById(String id) => _provider.getNoteById(id);

  @override
  Future<UniversalNote?> updateNote(UpdateNoteInput updateInput) =>
      _provider.updateNote(updateInput);

  @override
  Future<void> updateNotesByIds(Iterable<UpdateNoteInput> inputs) =>
      _provider.updateNotesByIds(inputs);

  @override
  Future<Iterable<UniversalNote>> searchAllNotes(
          {required String searchQuery}) =>
      _provider.searchAllNotes(
        searchQuery: searchQuery,
      );
}
