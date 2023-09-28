import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/database/notes/local_notes_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' as path show join;

import '../../local_database_exceptions.dart';
import '../models/m_local_note.dart';

class SqfliteLocalNotes extends LocalNotesRepository {
  Database? _database;

  static const databaseName = 'notes.db';
  static const databaseVersion = 1;

  @override
  bool get isInitialized => _database != null;

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      // throw const LocalDatabaseAlreadyInitializedException(
      //     'The database is already initlized');
      _database?.close();
    }
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final databasePath = path.join(documentsDirectory.path, databaseName);
      final database = await openDatabase(
        databasePath,
        onCreate: (db, version) async {
          await db.execute(LocalNote.createSqlTable);
        },
        version: databaseVersion,
      );
      _database = database;
    } on MissingPlatformDirectoryException catch (e) {
      throw FailedToInitalizeLocalDatabaseException(
          'Error while get the documents directory ${e.message}');
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while open the database ${e.toString()}');
    }
  }

  @override
  Future<void> close() async {
    try {
      await _database?.close();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Error while closing the database ${e.toString()}');
    }
  }

  @override
  Future<LocalNote> createOne(entity) async {
    try {
      final id = await _database?.insert(
        LocalNote.sqlTableName,
        LocalNote.toSqlite(entity),
      );
      if (id == null) {
        throw const LocalDatabaseOperationFaieldException(
          'The id of the inserted new data is null',
        );
      }
      return NoteInput.toLocalNote(
        entity,
        id: id.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while insert a note ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOneById(String id) async {
    try {
      final deletedCount = await _database?.delete(
            LocalNote.sqlTableName,
            where: 'id = ?',
            whereArgs: [id],
          ) ??
          -1;
      if (deletedCount != 1) {
        throw LocalDatabaseOperationFaieldException(
            'The deletedCount in sqflite should be only one but it $deletedCount');
      }
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while delete note ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _database?.delete(LocalNote.sqlTableName);
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while delete all notes ${e.toString()}');
    }
  }

  @override
  Future<List<LocalNote>> getAll({int limit = -1, int page = 1}) async {
    try {
      final hasNoLimit = limit == -1;
      final offset = (page - 1) * limit;

      final results = await _database!.query(
        LocalNote.sqlTableName,
        orderBy: 'updatedAt DESC',
        limit: hasNoLimit ? null : limit, // limit of each row
        offset: hasNoLimit ? null : offset, // rows to skip
      );

      if (results.isEmpty) {
        return List.empty();
      }
      return results.map((e) => LocalNote.fromSqlite(e)).toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get all notes ${e.toString()}');
    }
  }

  @override
  Future<LocalNote?> getOneById(String id) async {
    try {
      final results = await _database!.query(
        LocalNote.sqlTableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isNotEmpty) {
        return LocalNote.fromSqlite(results.first);
      }
      return null;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get note ${e.toString()}');
    }
  }

  @override
  Future<List<LocalNote>> getAllByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) {
        throw const ParametersErrorLocalDatabaseException(
            'To get itmes by thier ids, the ids should not be empty');
      }
      final idList = ids.join(', ');
      final results = await _database!.query(
        LocalNote.sqlTableName,
        where: 'id IN ($idList)',
        orderBy: 'updatedAt DESC',
      );
      if (results.isEmpty) {
        return List.empty();
      }
      return results.map((e) => LocalNote.fromSqlite(e)).toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get all by ids ${e.toString()}');
    }
  }

  @override
  Future<LocalNote> updateOne(NoteInput entity, String currentId) async {
    try {
      final currentNote = await getOneById(currentId);
      if (currentNote == null) {
        throw LocalDatabaseOperationFaieldException(
            'There is no note with this id $currentId to update');
      }
      final updatedItemsCount = await _database?.update(
        LocalNote.sqlTableName,
        LocalNote.toSqlite(entity),
        where: 'id = ?',
        whereArgs: [currentId],
      );
      if (updatedItemsCount == null) {
        throw const LocalDatabaseOperationFaieldException(
            'the updatedItemsCount is null, please make sure the database is initlized.');
      }
      if (updatedItemsCount == -1) {
        throw LocalDatabaseOperationFaieldException(
            'updatedItemsCount = $updatedItemsCount, the database instance of sqflite could be null.');
      }
      if (updatedItemsCount != 1) {
        throw LocalDatabaseOperationFaieldException(
            'updatedItemsCount = $updatedItemsCount, you asked to delete only one item but we found even more.');
      }
      return NoteInput.toLocalNote(
        entity,
        id: currentId,
        createdAt: currentNote.createdAt,
        updatedAt: DateTime.now(),
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while update note by id ${e.toString()}');
    }
  }

  @override
  Future<void> deleteByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) {
        throw const ParametersErrorLocalDatabaseException(
            'To delete items by ids, the ids should not be empty');
      }
      final idList = ids.join(', ');
      final deletedCount = await _database?.delete(
        LocalNote.sqlTableName,
        where: 'id IN ($idList)',
      );
      if (deletedCount == null) {
        throw const LocalDatabaseOperationFaieldException(
            'The deleted count is null, please make sure you have initlized the database');
      }
      if (deletedCount == 0) {
        throw LocalDatabaseOperationFaieldException(
            'We did not find any matching items. The deleted count is $deletedCount, please check your ids');
      }
      if (deletedCount != ids.length) {
        throw LocalDatabaseOperationFaieldException(
            'The deleted items count is $deletedCount while the length of the ids is ${ids.length}, so not all items has been deleted. Make sure all the ids are exists');
      }
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while update note by id ${e.toString()}');
    }
  }
}
