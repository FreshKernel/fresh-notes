import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/models/note/m_note.dart';
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
  Future<void> close() async {
    requireToBeInitialized();
    await _provider.close();
  }

  @override
  Future<LocalNote> createOne(NoteInput entity) async {
    requireToBeInitialized();
    final note = await _provider.createOne(entity);
    return note;
  }

  @override
  Future<void> deleteOneById(String id) async {
    requireToBeInitialized();
    await _provider.deleteOneById(id);
  }

  @override
  Future<List<LocalNote>> getAll({int limit = -1, int page = 1}) async {
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
  Future<LocalNote> updateOne(NoteInput newEntity, String currentId) async {
    requireToBeInitialized();
    final note = await _provider.updateOne(newEntity, currentId);
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
    await _provider.initialize();
  }

  @override
  bool get isInitialized => _provider.isInitialized;
}
