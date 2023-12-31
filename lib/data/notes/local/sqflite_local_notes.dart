import 'package:path/path.dart' as path show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

import '../../../core/service/s_app.dart';
import '../../../logic/auth/auth_service.dart';
import '../../core/local/database/local_database_exceptions.dart';
import '../../core/local/database/sql_data_type.dart';
import '../../core/shared/database_operations_exceptions.dart';
import '../note_repository.dart';
import '../universal/models/m_note.dart';
import '../universal/models/m_note_inputs.dart';
import 'models/m_local_note.dart';

/// Make sure when you use this class to required the database
/// to be initialized in the parent class
/// otherwise you will get [NullThrownError]
class SqfliteLocalNotesImpl extends NotesRepository implements AppService {
  Database? _database;

  static const databaseName = 'notes.db';
  static const databaseVersion = 1;

  @override
  bool get isInitialized => _database != null;

  Database _requireDatabase() {
    return _database ??
        (throw const ServiceNotInitializedException(
            'Please run initialize first to use the database'));
  }

  @override
  Future<void> initialize() async {
    if (isInitialized) {
      // throw const ServiceAlreadyInitlizedException(
      //   'The database is already initlized',
      // );
      await deInitialize();
    }
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final databasePath =
          path.join(documentsDirectory.path, 'databases', databaseName);
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
      await _requireDatabase().close();
      _database = null;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Error while closing the database ${e.toString()}');
    }
  }

  @override
  Future<UniversalNote> insertNote(CreateNoteInput createInput) async {
    try {
      await _requireDatabase().insert(
        LocalNote.sqlTableName,
        LocalNote.toSqliteMapFromCreateInput(input: createInput).toMap(),
      );
      final currentDate = DateTime.now();
      return UniversalNote.fromCreateInput(
        createInput,
        createdAt: currentDate,
        updatedAt: currentDate,
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while insert a note ${e.toString()}');
    }
  }

  @override
  Future<Iterable<UniversalNote>> insertNotes(
      Iterable<CreateNoteInput> inputs) async {
    try {
      final notesFutures = inputs.map((createInput) async {
        await _requireDatabase().insert(
          LocalNote.sqlTableName,
          LocalNote.toSqliteMapFromCreateInput(input: createInput).toMap(),
        );
        final currentDate = DateTime.now();
        return UniversalNote.fromCreateInput(
          createInput,
          createdAt: currentDate,
          updatedAt: currentDate,
        );
      });
      final notes = await Future.wait(notesFutures);
      return notes;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while insert a note. ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNoteById(String id) async {
    try {
      final deletedCount = await _requireDatabase().delete(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.noteId} = ?',
        whereArgs: [id],
      );
      if (deletedCount != 1) {
        throw DatabaseOperationFaieldException(
            'The deletedCount in sqflite should be only one but it $deletedCount');
      }
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while delete note ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAllNotes() async {
    try {
      final currentUserId = AuthService.getInstance().currentUser?.id;
      if (currentUserId != null) {
        await _requireDatabase().delete(
          LocalNote.sqlTableName,
          where: '${LocalNoteProperties.userId} = ?',
          whereArgs: [currentUserId],
        );
        return;
      }
      await _requireDatabase().delete(
        LocalNote.sqlTableName,
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while delete all notes ${e.toString()}');
    }
  }

  @override
  Future<Iterable<UniversalNote>> getAllNotes({
    required int limit,
    required int page,
  }) async {
    try {
      final hasNoLimit = limit == -1;
      final offset = (page - 1) * limit;

      final results = await _requireDatabase().query(
        LocalNote.sqlTableName,
        orderBy: '${LocalNoteProperties.updatedAt} DESC',
        limit: hasNoLimit ? null : limit, // limit of each row
        offset: hasNoLimit ? null : offset, // rows to skip
      );

      if (results.isEmpty) {
        return List.empty();
      }
      return results
          .map(LocalNote.fromSqlite)
          .map(UniversalNote.fromLocalNote)
          .toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get all notes ${e.toString()}');
    }
  }

  @override
  Future<UniversalNote?> getNoteById(String id) async {
    try {
      final results = await _requireDatabase().query(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.noteId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isNotEmpty) {
        return UniversalNote.fromLocalNote(
          LocalNote.fromSqlite(results.first),
        );
      }
      return null;
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get note ${e.toString()}');
    }
  }

  @override
  Future<Iterable<UniversalNote>> getAllNotesByIds(Iterable<String> ids) async {
    try {
      if (ids.isEmpty) {
        throw const DatabaseOperationInvalidParameterException(
            'To get itmes by thier ids, the ids should not be empty');
      }
      final idList = ids.map((e) => "'$e'").join(', ');
      final results = await _requireDatabase().query(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.noteId} IN ($idList)',
        orderBy: '${LocalNoteProperties.updatedAt} DESC',
      );
      if (results.isEmpty) {
        return List.empty();
      }
      return results
          .map(LocalNote.fromSqlite)
          .map(UniversalNote.fromLocalNote)
          .toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while get all by ids ${e.toString()}');
    }
  }

  @override
  Future<UniversalNote?> updateNote(UpdateNoteInput updateInput) async {
    try {
      final currentNote = await getNoteById(updateInput.noteId);
      if (currentNote == null) {
        return null;
      }
      final updatedItemsCount = await _requireDatabase().update(
        LocalNote.sqlTableName,
        LocalNote.toSqliteMapFromUpdateInput(input: updateInput).toMap(),
        where: '${LocalNoteProperties.noteId} = ?',
        whereArgs: [updateInput.noteId],
      );
      if (updatedItemsCount == -1) {
        return null;
      }
      if (updatedItemsCount != 1) {
        return null;
      }
      final currentUserId = AuthService.getInstance().currentUser?.id;
      return UniversalNote.fromUpdateInput(
        updateInput,
        createdAt: currentNote.createdAt,
        updatedAt: DateTime.now(),
        userId: currentUserId,
      );
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while update note by id ${e.toString()}');
    }
  }

  @override
  Future<void> deleteNotesByIds(Iterable<String> ids) async {
    try {
      if (ids.isEmpty) {
        throw const DatabaseOperationInvalidParameterException(
            'To delete items by ids, the ids should not be empty');
      }
      final idList = ids.map((e) => "'$e'").join(', ');
      final deletedCount = await _requireDatabase().delete(
        LocalNote.sqlTableName,
        where: '${LocalNoteProperties.noteId} IN ($idList)',
      );
      if (deletedCount == 0) {
        throw DatabaseOperationException(
            'We did not find any matching items. The deleted count is $deletedCount, please check your ids');
      }
      if (deletedCount != ids.length) {
        throw DatabaseOperationException(
          'The deleted items count is $deletedCount while the length of the ids is ${ids.length}, so not all items has been deleted. Make sure all the ids are exists',
        );
      }
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
          'Unknown error while update note by id ${e.toString()}');
    }
  }

  @override
  Future<void> updateNotesByIds(Iterable<UpdateNoteInput> inputs) async {
    try {
      await _requireDatabase().transaction((txn) async {
        for (final noteInput in inputs) {
          await txn.update(
            LocalNote.sqlTableName,
            LocalNote.toSqliteMapFromUpdateInput(input: noteInput).toMap(),
            where: '${LocalNoteProperties.noteId} = ?',
            whereArgs: [noteInput.noteId],
          );
        }
      });
    } catch (e) {
      throw UnknownLocalDatabaseErrorException(
        'Unknown error while update notes by ids ${e.toString()}',
      );
    }
  }

  @override
  Future<Iterable<UniversalNote>> searchAllNotes(
      {required String searchQuery}) async {
    try {
      final results = await _requireDatabase().query(
        LocalNote.sqlTableName,
        where:
            'LOWER(${LocalNoteProperties.title}) LIKE ? OR LOWER(${LocalNoteProperties.text}) LIKE ?',
        whereArgs: [
          '%${searchQuery.toLowerCase()}%',
          '%${searchQuery.toLowerCase()}%'
        ],
      );
      if (results.isEmpty) {
        return [];
      }
      return results
          .map(LocalNote.fromSqlite)
          .map(UniversalNote.fromLocalNote)
          .toList();
    } on DatabaseException catch (e) {
      throw UnknownLocalDatabaseErrorException(
        'Unknown error while Search for notes ${e.toString()}',
      );
    }
  }

  @override
  void requireToBeInitialized({String? errorMessage}) {
    throw UnimplementedError();
  }
}
