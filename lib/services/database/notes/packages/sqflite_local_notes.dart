import 'package:path/path.dart' as path show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

import '../../../../core/data/crud_exceptions.dart';
import '../../../auth/auth_service.dart';
import '../../../data/notes/models/m_note_input.dart';
import '../../shared/local_database_exceptions.dart';
import '../../shared/sql_data_type.dart';
import '../local_notes_repository.dart';
import '../models/m_local_note.dart';

/// Make sure when you use this class to required the database
/// to be initialized in the parent class
/// otherwise you will get [NullThrownError]
class SqfliteLocalNotesImpl extends LocalNotesRepository {
  Database? _database;

  static const databaseName = 'notes.db';
  static const databaseVersion = 1;

  @override
  bool get isInitialized => _database != null;

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      // throw const ServiceAlreadyInitlizedException(
      //   'The database is already initlized',
      // );
      await deInitialize(); // TODO: I might need to change this
    }
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final databasePath = path.join(documentsDirectory.path, databaseName);
      final database = await openDatabase(
        databasePath,
        onCreate: (db, version) async {
          await db.execute(LocalNote.createSqlTable);
        },
        onUpgrade: (db, oldVersion, newVersion) {
          throw UnimplementedError(
            'On database upgrade is not implemented yet.',
          );
        },
        version: databaseVersion,
      );
      _database = database;
    } on MissingPlatformDirectoryException catch (e) {
      throw FailedToInitializeLocalDatabaseException(
          'Error while get the documents directory ${e.message}');
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while open the database ${e.toString()}');
    }
  }

  @override
  Future<void> deInitialize() async {
    try {
      await _database!.close();
      _database = null;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Error while closing the database ${e.toString()}');
    }
  }

  @override
  Future<LocalNote> createOne(CreateNoteInput createInput) async {
    try {
      final id = await _database!.insert(
        LocalNote.sqlTableName,
        LocalNote.toSqliteMapFromCreateInput(input: createInput).toMap(),
      );
      final currentDate = DateTime.now();
      return LocalNote.fromCreateNoteInput(
        input: createInput,
        id: id.toString(),
        createdAt: currentDate,
        updatedAt: currentDate,
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while insert a note ${e.toString()}');
    }
  }

  @override
  Future<List<LocalNote>> createMultiples(List<CreateNoteInput> list) async {
    try {
      final notesFutures = list.map((createInput) async {
        final id = await _database!.insert(
          LocalNote.sqlTableName,
          LocalNote.toSqliteMapFromCreateInput(input: createInput).toMap(),
        );
        final currentDate = DateTime.now();
        return LocalNote.fromCreateNoteInput(
          input: createInput,
          id: id.toString(),
          createdAt: currentDate,
          updatedAt: currentDate,
        );
      });
      final notes = await Future.wait(notesFutures);
      return notes;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while insert a note ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOneById(String id) async {
    try {
      final deletedCount = await _database!.delete(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.id} = ?',
        whereArgs: [id],
      );
      if (deletedCount != 1) {
        throw CrudOperationFaieldException(
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
      final currentUserId = AuthService.getInstance()
          .requireCurrentUser(
            'In order to insert note in local database, user must be authenticated.',
          )
          .id;
      await _database!.delete(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.userId} = ?',
        whereArgs: [currentUserId],
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while delete all notes ${e.toString()}');
    }
  }

  @override
  Future<List<LocalNote>> getAll({
    required int limit,
    required int page,
  }) async {
    try {
      final hasNoLimit = limit == -1;
      final offset = (page - 1) * limit;

      final currentUserId = AuthService.getInstance()
          .requireCurrentUser(
            'In order to insert note in local database, user must be authenticated.',
          )
          .id;

      final results = await _database!.query(
        LocalNote.sqlTableName,
        orderBy: '${LocalNoteProperties.updatedAt} DESC',
        where: '${LocalNoteProperties.userId} = ?',
        whereArgs: [currentUserId],
        limit: hasNoLimit ? null : limit, // limit of each row
        offset: hasNoLimit ? null : offset, // rows to skip
      );

      if (results.isEmpty) {
        return List.empty();
      }
      return results.map(LocalNote.fromSqlite).toList();
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
        where: '${LocalNoteProperties.id} = ?',
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
        throw const InvalidParameterCrudException(
            'To get itmes by thier ids, the ids should not be empty');
      }
      final idList = ids.join(', ');
      final results = await _database!.query(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.id} IN ($idList)',
        orderBy: '${LocalNoteProperties.updatedAt} DESC',
      );
      if (results.isEmpty) {
        return List.empty();
      }
      return results.map(LocalNote.fromSqlite).toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get all by ids ${e.toString()}');
    }
  }

  @override
  Future<LocalNote> updateOne(
      UpdateNoteInput updateInput, String currentId) async {
    try {
      final currentNote = await getOneById(currentId);
      if (currentNote == null) {
        throw CrudOperationFaieldException(
            'There is no note with this id $currentId to update');
      }
      final updatedItemsCount = await _database!.update(
        LocalNote.sqlTableName,
        LocalNote.toSqliteMapFromUpdateInput(input: updateInput).toMap(),
        where: '${LocalNoteProperties.id} = ?',
        whereArgs: [currentId],
      );
      if (updatedItemsCount == -1) {
        throw CrudOperationFaieldException(
            'updatedItemsCount = $updatedItemsCount, the database instance of sqflite could be null.');
      }
      if (updatedItemsCount != 1) {
        throw CrudOperationFaieldException(
            'updatedItemsCount = $updatedItemsCount, you asked to delete only one item but we found even more.');
      }
      final currnetUser = AuthService.getInstance().requireCurrentUser(
          'To update a note, the user must be authenticated');
      return LocalNote.fromUpdateNoteInput(
        input: updateInput,
        id: currentId,
        createdAt: currentNote.createdAt,
        updatedAt: DateTime.now(),
        userId: currnetUser.id,
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
        throw const InvalidParameterCrudException(
            'To delete items by ids, the ids should not be empty');
      }
      final idList = ids.join(', ');
      final deletedCount = await _database!.delete(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.id} IN ($idList)',
      );
      if (deletedCount == 0) {
        throw CrudOperationFaieldException(
            'We did not find any matching items. The deleted count is $deletedCount, please check your ids');
      }
      if (deletedCount != ids.length) {
        throw CrudOperationFaieldException(
            'The deleted items count is $deletedCount while the length of the ids is ${ids.length}, so not all items has been deleted. Make sure all the ids are exists');
      }
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while update note by id ${e.toString()}');
    }
  }
}
