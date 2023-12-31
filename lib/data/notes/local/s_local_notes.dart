import '../../../core/app_module.dart';
import '../../../core/service/s_app.dart';
import '../note_repository.dart';
import '../universal/models/m_note.dart';
import '../universal/models/m_note_inputs.dart';
import 'sqflite_local_notes.dart';

class LocalNotesService extends NotesRepository implements AppService {
  LocalNotesService(this._provider);

  factory LocalNotesService.sqflite() =>
      LocalNotesService(SqfliteLocalNotesImpl());
  factory LocalNotesService.getInstance() => AppModule.localNotesService;
  final NotesRepository _provider;

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    if (_provider is SqfliteLocalNotesImpl) {
      await _provider.initialize();
    }
  }

  @override
  Future<void> deInitialize() async {
    if (_provider is SqfliteLocalNotesImpl) {
      await _provider.deInitialize();
    }
  }

  @override
  Future<void> deleteAllNotes() => _provider.deleteAllNotes();

  @override
  Future<void> deleteNoteById(String id) => _provider.deleteNoteById(id);

  @override
  Future<void> deleteNotesByIds(Iterable<String> ids) =>
      _provider.deleteNotesByIds(ids);

  @override
  Future<Iterable<UniversalNote>> getAllNotes(
          {required int limit, required int page}) =>
      _provider.getAllNotes(limit: limit, page: page);

  @override
  Future<Iterable<UniversalNote>> getAllNotesByIds(Iterable<String> ids) =>
      _provider.getAllNotesByIds(ids);

  @override
  Future<UniversalNote?> getNoteById(String id) => _provider.getNoteById(id);

  @override
  Future<UniversalNote> insertNote(CreateNoteInput createInput) =>
      _provider.insertNote(createInput);

  @override
  Future<Iterable<UniversalNote>> insertNotes(
          Iterable<CreateNoteInput> inputs) =>
      _provider.insertNotes(inputs);

  @override
  bool get isInitialized {
    if (_provider is SqfliteLocalNotesImpl) {
      return _provider.isInitialized;
    }
    return false;
  }

  @override
  Future<Iterable<UniversalNote>> searchAllNotes(
          {required String searchQuery}) =>
      _provider.searchAllNotes(searchQuery: searchQuery);

  @override
  Future<UniversalNote?> updateNote(UpdateNoteInput updateInput) =>
      _provider.updateNote(updateInput);

  @override
  Future<void> updateNotesByIds(Iterable<UpdateNoteInput> inputs) =>
      _provider.updateNotesByIds(inputs);

  @override
  void requireToBeInitialized({String? errorMessage}) {
    throw UnimplementedError();
  }
}
