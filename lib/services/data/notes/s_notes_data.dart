import 'dart:async';

import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';

import 'package:my_notes/utils/bool.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'dart:convert' show jsonEncode;
import 'dart:io' show File;

class NotesDataService {
  NotesDataService._();

  static final _instance = NotesDataService._();
  factory NotesDataService.getInstance() => _instance;

  final List<Note> _notes = [];
  final _notesStreamController = StreamController<List<Note>>.broadcast();

  StreamController<List<Note>> get notesStreamController =>
      _notesStreamController;
  final _localNotesService = LocalNotesService.getInstance();

  Future<void> loadNotesAndCacheThem() async {
    await _localNotesService.initialize();
    await getAll();
  }

  // @override
  Future<void> close() async {
    await _localNotesService.close();
  }

  Future<void> createOne(NoteInput entity) async {
    final note = Note.fromLocalNote(await _localNotesService.createOne(entity));
    _notes.add(note);
    _notesStreamController.add(_notes);
  }

  Iterable<String> getImagesPathsFromDocument(
    quill.Document document,
  ) {
    final images = document.root.children
        .whereType<quill.Line>()
        .where((node) {
          if (node.isEmpty) {
            return false;
          }
          final firstNode = node.children.first;
          if (firstNode is! quill.Embed) {
            return false;
          }
          if (firstNode.value.type != 'image') {
            return false;
          }
          final imageSource = firstNode.value.data;
          if (imageSource is! String) {
            return false;
          }
          if (isHttpBasedUrl(imageSource)) {
            return false;
          }
          return imageSource.trim().isNotEmpty;
        })
        .toList()
        .map((e) => (e.children.first as quill.Embed).value.data as String);
    return images;
  }

  Future<void> insertOneOrReplace(
    quill.Document document, {
    String? currentId,
    bool isSyncedWithCloud = true,
  }) async {
    final isEditing = currentId != null;
    final user = AuthService.getInstance().requireCurrentUser(
      'In order to create or update note, the user must be authenticated.',
    );

    final cachedImages = getImagesPathsFromDocument(document);
    // If we are able to create the database then we should not
    // get MissingPlatformDirectoryException but only in rare cases
    final documentsDir = await getApplicationDocumentsDirectory();

    // Save all the cached images from the editor to the documents directory
    final newImagesFutures = cachedImages.map((cachedImagePath) async {
      final cachedImageFile = File(cachedImagePath);
      final newImageFileExtension = path.extension(cachedImagePath);
      final newImageFileName =
          'image-${DateTime.now().toIso8601String()}$newImageFileExtension';
      final newImagePath = path.join(documentsDir.path, newImageFileName);
      final newImageFile = await cachedImageFile.copy(newImagePath);
      return newImageFile.path;
    });
    final newImages = await Future.wait(newImagesFutures);

    // Then we want to replace all the cached images with the saved ones
    String documentInJson = jsonEncode(document.toDelta().toJson());
    cachedImages.toList().asMap().forEach((index, cachedImage) {
      final savedImage = newImages[index];
      documentInJson = documentInJson.replaceFirst(cachedImage, savedImage);
    });
    if (isEditing) {
      await updateOne(
        NoteInput(
          text: documentInJson,
          isSyncedWithCloud: isSyncedWithCloud,
          userId: user.id,
        ),
        currentId,
      );
    } else {
      final input = NoteInput(
        isSyncedWithCloud: true,
        text: documentInJson,
        userId: user.id,
      );
      await createOne(
        input,
      );
    }
  }

  Future<void> deleteAll() async {
    await _localNotesService.deleteAll();
    _notes.clear();
    _notesStreamController.add(_notes);
  }

  Future<void> deleteByIds(List<String> ids) async {
    await _localNotesService.deleteByIds(ids);
    _notes.removeWhere((note) => ids.contains(note.id));
    _notesStreamController.add(_notes);
  }

  Future<void> deleteOneById(String id) async {
    await _localNotesService.deleteOneById(id);

    final noteIndex = _notes.indexWhere((note) => note.id == id);
    if (noteIndex != -1) {
      _notes.removeAt(noteIndex);
      _notesStreamController.add(_notes);
      return;
    }
    AppLogger.error(
      "We couldn't find the index for the currentId of the deleting note in NoteDataService, the id is $id",
    );
  }

  Future<void> getAll({int limit = -1, int page = 1}) async {
    final localNotes = (await _localNotesService.getAll())
        .map((e) => Note.fromLocalNote(e))
        .toList();
    _notes.addAll(localNotes);
    _notesStreamController.add(_notes);
  }

  Future<void> updateOne(NoteInput newEntity, String currentId) async {
    final newNote = Note.fromLocalNote(
      await _localNotesService.updateOne(newEntity, currentId),
    );
    final index =
        _notes.indexWhere((currentNote) => currentNote.id == currentId);
    if (index != -1) {
      _notes.removeAt(index);
      _notes.add(newNote);
      _notesStreamController.add(_notes);
      return;
    }
    AppLogger.error(
      "We couldn't find the index for the currentId of the updating note in NoteDataService, the id is = $currentId",
    );
  }

  // @override
  // Future<List<Note>> getAllByIds(List<String> ids) async {
  //   final localNotes = (await _localNotesService.getAllByIds(ids))
  //       .map((e) => Note.fromLocalNote(e))
  //       .toList();
  //   _notes.addAll(localNotes);
  //   _notesStreamController.add(_notes);
  //   return localNotes;
  // }

  // @override
  // Future<Note?> getOneById(String id) async {
  //   final note = await _localNotesService.getOneById(id);
  //   if (note == null) return null;
  //   return Note.fromLocalNote(note);
  // }

  Future<void> initialize() async {
    await _localNotesService.initialize();
  }

  bool get isInitialized => _localNotesService.isInitialized;
}
