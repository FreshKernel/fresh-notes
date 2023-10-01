import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/services/data/notes/models/m_note_input.dart';
import 'package:my_notes/services/database/notes/local_notes_repository.dart';
import 'package:my_notes/services/database/notes/models/m_local_note.dart';
import 'package:my_notes/services/database/notes/packages/sqflite_local_notes.dart';

import '../shared/local_database_repository.dart';

class LocalNotesService extends LocalNotesRepository {
  final LocalDatabaseRepository _provider;

  LocalNotesService._(this._provider);

  factory LocalNotesService.sqflite() =>
      LocalNotesService._(SqfliteLocalNotesImpl());
  factory LocalNotesService.getInstance() => AppModule.localNotesService;

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
    return notes.cast(); // TODO: Search about why do I have to cast this?
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
    final notes = await _provider.getAll(limit: limit, page: page);
    return notes.cast();
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
  Future<LocalNote> updateOne(
      UpdateNoteInput updateInput, String currentId) async {
    requireToBeInitialized();
    final note = await _provider.updateOne(updateInput, currentId);
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
  Future<void> initialize() async {
    AppLogger.log('Initializing the notes database...');
    await _provider.initialize();
    AppLogger.log('The notes database has been successfully Initialized.');
  }

  @override
  bool get isInitialized => _provider.isInitialized;
}
