import '../../../core/app_module.dart';
import '../../../core/log/logger.dart';
import '../../core/local/database/local_database_repository.dart';
import '../universal/models/m_note_inputs.dart';
import 'local_notes_repository.dart';
import 'models/m_local_note.dart';
import 'packages/sqflite_local_notes.dart';

class LocalNotesService extends LocalNotesRepository {
  LocalNotesService(this._provider);

  factory LocalNotesService.sqflite() =>
      LocalNotesService(SqfliteLocalNotesImpl());
  factory LocalNotesService.getInstance() => AppModule.localNotesService;
  final LocalDatabaseRepository _provider;

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      AppLogger.log('Local database is already initialized.');
      return;
    }
    AppLogger.log('Initializing the notes database...');
    await _provider.initialize();
    AppLogger.log('The notes database has been successfully Initialized.');
  }

  @override
  bool get isInitialized => _provider.isInitialized;

  @override
  Future<void> deInitialize() async {
    requireToBeInitialized();
    AppLogger.log('Closing the notes database...');
    await _provider.deInitialize();
    AppLogger.log('The notes database has been successfully closed.');
  }

  @override
  Future<LocalNote> createOne(CreateNoteInput createInput) async {
    requireToBeInitialized();
    final note = await _provider.createOne(createInput);
    return note;
  }

  @override
  Future<List<LocalNote>> createMultiples(List<CreateNoteInput> list) async {
    requireToBeInitialized();
    final notes = await _provider.createMultiples(list);
    return notes.cast();
  }

  @override
  Future<void> deleteOneById(String id) async {
    requireToBeInitialized();
    await _provider.deleteOneById(id);
  }

  @override
  Future<List<LocalNote>> getAll({
    required int limit,
    required int page,
  }) async {
    requireToBeInitialized();
    final result = await _provider.getAll(limit: limit, page: page);
    final List<LocalNote> notes = result.cast();
    return notes.where((localNote) => !localNote.isSyncWithCloud).toList();
  }

  @override
  Future<List<LocalNote>> getAllByIds(List<String> ids) async {
    requireToBeInitialized();
    final notes = await _provider.getAllByIds(ids);
    return notes.cast();
  }

  @override
  Future<LocalNote?> getOneById(String id) async {
    requireToBeInitialized();
    final note = await _provider.getOneById(id);
    return note;
  }

  @override
  Future<LocalNote?> updateOne(
    UpdateNoteInput updateInput,
  ) async {
    requireToBeInitialized();
    final note = await _provider.updateOne(updateInput);
    return note;
  }

  @override
  Future<void> deleteAll() async {
    requireToBeInitialized();
    await _provider.deleteAll();
  }

  @override
  Future<void> deleteByIds(List<String> ids) async {
    requireToBeInitialized();
    await _provider.deleteByIds(ids);
  }

  @override
  Future<void> updateByIds(List<UpdateNoteInput> entities) async {
    requireToBeInitialized();
    await _provider.updateByIds(entities);
  }
}
