import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/database/local_database_repository.dart';
import 'package:my_notes/services/database/notes/local_notes_repository.dart';
import 'package:my_notes/services/database/notes/models/m_local_note.dart';
import 'package:my_notes/services/database/notes/packages/sqflite_local_notes.dart';

import '../local_database_exceptions.dart';

class LocalNotesService implements LocalNotesRepository {
  final LocalDatabaseRepository _provider;

  const LocalNotesService._(this._provider);

  factory LocalNotesService.sqflite() =>
      LocalNotesService._(SqfliteLocalNotes());
  factory LocalNotesService.getInstance() => AppModule.localNotesService;

  void _requireDatabaseToBeInitalized() {
    if (!_provider.isInitialized) {
      throw const LocalDatabaseNotInitalizedException(
          'The database should be open when request to close it.');
    }
  }

  @override
  Future<void> close() async {
    _requireDatabaseToBeInitalized();
    await _provider.close();
  }

  @override
  Future<LocalNote> createOne(NoteInput entity) async {
    _requireDatabaseToBeInitalized();
    final note = await _provider.createOne(entity);
    return note;
  }

  @override
  Future<void> deleteOneById(String id) async {
    _requireDatabaseToBeInitalized();
    await _provider.deleteOneById(id);
  }

  @override
  Future<List<LocalNote>> getAll({int limit = -1, int page = 1}) async {
    _requireDatabaseToBeInitalized();
    final notes = await _provider.getAll(limit: limit, page: page);
    return notes.cast();
  }

  @override
  Future<List<LocalNote>> getAllByIds(List<String> ids) async {
    _requireDatabaseToBeInitalized();
    final notes = await _provider.getAllByIds(ids);
    return notes.cast();
  }

  @override
  Future<LocalNote?> getOneById(String id) async {
    _requireDatabaseToBeInitalized();
    final note = await _provider.getOneById(id);
    return note;
  }

  @override
  Future<LocalNote> updateOne(NoteInput newEntity, String currentId) async {
    _requireDatabaseToBeInitalized();
    final note = await _provider.updateOne(newEntity, currentId);
    return note;
  }

  @override
  Future<void> deleteAll() async {
    _requireDatabaseToBeInitalized();
    await _provider.deleteAll();
  }

  @override
  Future<void> deleteByIds(List<String> ids) async {
    _requireDatabaseToBeInitalized();
    await _provider.deleteByIds(ids);
  }

  @override
  Future<void> initialize() async {
    await _provider.initialize();
  }

  @override
  bool get isInitialized => _provider.isInitialized;
}
