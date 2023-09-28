import 'dart:async';

import 'package:my_notes/core/errors/exceptions.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';

import 'package:my_notes/utils/bool.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show File, Platform;

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
    _notes.clear();
    await initialize();
    await getAll();
  }

  // @override
  Future<void> close() async {
    await _localNotesService.close();
  }

  Future<void> createOne(NoteInput entity) async {
    final note = Note.fromLocalNote(await _localNotesService.createOne(entity));
    _notes.insert(0, note);
    _notesStreamController.add(_notes);
  }

  Iterable<String> _getLocalImagesPathsFromDocument(
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

  /// I'm too lazy to write comments to explain
  /// the logic, but when I work with team I will.
  Future<Iterable<String>> _getCachedImagePathsFromDocumentAndMakeSureItExists(
    quill.Document document,
  ) async {
    final imagePaths = _getLocalImagesPathsFromDocument(document);

    final cachesImagePaths = imagePaths.where((imagePath) {
      // We don't want the not cached images to be saved again in
      // the function insertOrReplaceOne
      // Since when we update the note, we only want to save
      // The new images in the note after edit it

      // TODO: Hardcoded and could be different from platform to another
      if (Platform.isAndroid) {
        if (!imagePath.contains('cache')) {
          return false;
        }
      } else if (Platform.isIOS) {
        if (!imagePath.contains('tmp')) {
          return false;
        }
      }
      return true;
    }).toList();
    // Remove all the images that doesn't exists
    for (final imagePath in cachesImagePaths) {
      final file = File(imagePath);
      final exists = await file.exists();
      if (!exists) {
        AppLogger.error(
          'This path: $imagePath has index of cacges image paths in notes data service is does not exists, maybe the user deleted it in root or another way.',
          stackTrace: StackTrace.current,
        );
        final index = cachesImagePaths.indexOf(imagePath);
        if (index == -1) {
          throw AppException(
              'This path: $imagePath has index of cacges image paths in notes data service is -1');
        }
        cachesImagePaths.removeAt(index);
        cachesImagePaths.insert(index,
            'https://images.uncyclomedia.co/uncyclopedia/en/thumb/0/0e/No_image.PNG/300px-No_image.PNG'); // TODO: Change this later or remove it
      }
    }
    return cachesImagePaths;
  }

  Future<void> insertOrReplaceOne(
    quill.Document document, {
    String? currentId,
    bool isSyncedWithCloud = true,
  }) async {
    final isEditing = currentId != null;
    final user = AuthService.getInstance().requireCurrentUser(
      'In order to create or update note, the user must be authenticated.',
    );

    final cachedImages =
        await _getCachedImagePathsFromDocumentAndMakeSureItExists(document);
    AppLogger.log(
      'Local images: ${_getLocalImagesPathsFromDocument(document).toString()}',
    );
    // If we are able to create the database then we should not
    // get MissingPlatformDirectoryException but only in rare cases
    final documentsDir = await getApplicationDocumentsDirectory();

    // Save all the cached images from the editor to the documents directory
    final newImagesFutures = cachedImages.map((cachedImagePath) async {
      final cachedImageFile = File(cachedImagePath);
      final newImageFileExtensionWithDot = path.extension(cachedImagePath);
      final newImageFileName =
          'note-image-${DateTime.now().toIso8601String()}$newImageFileExtensionWithDot';
      final newImagePath = path.join(documentsDir.path, newImageFileName);
      final newImageFile = await cachedImageFile.copy(newImagePath);
      return newImageFile.path;
    });
    // Await for the saving process for each image
    final newImages = await Future.wait(newImagesFutures);

    // Then we want to replace all the cached images with the saved ones
    String documentInJson = jsonEncode(document.toDelta().toJson());
    AppLogger.log(
      'The document data before replace the cached images with saved one: $documentInJson',
    );
    cachedImages.toList().asMap().forEach((index, cachedImage) {
      final savedImage = newImages[index];
      documentInJson = documentInJson.replaceAll(cachedImage, savedImage);
    });
    AppLogger.log(
      'The document data after replacing the cached images with saved one: $documentInJson',
    );
    if (isEditing) {
      await updateOne(
        NoteInput(
          text: documentInJson,
          isSyncedWithCloud: isSyncedWithCloud,
          userId: user.id,
        ),
        currentId,
      );
      return;
    }
    final input = NoteInput(
      isSyncedWithCloud: true,
      text: documentInJson,
      userId: user.id,
    );
    await createOne(
      input,
    );
  }

  Future<void> deleteAll() async {
    await _localNotesService.deleteAll();
    for (final note in _notes) {
      _deleteAllImagesOfNote(note.text);
    }
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
      await _deleteAllImagesOfNote(_notes[noteIndex].text);
      _notes.removeAt(noteIndex);
      _notesStreamController.add(_notes);
      return;
    }
    throw AppException(
      "We couldn't find the index for the currentId of the deleting note in NoteDataService, the id is $id",
    );
  }

  // TODO: After save a note with image in it, there is a bug
  // and click on the note again to update it, and then remove the
  // image without remove the note, the note actually will not
  // deleted, I will fix that bug in the future.

  // TODO: Also don't forgot to reset cache of the app after all the tests
  // of notes functionallities and see if the images still there
  Future<void> _deleteAllImagesOfNote(String jsonDocument) async {
    final document = quill.Document.fromJson(jsonDecode(jsonDocument));
    final imagesPaths = _getLocalImagesPathsFromDocument(document);
    for (final image in imagesPaths) {
      final imageFile = File(image);
      final fileExists = await imageFile.exists();
      if (!fileExists) {
        return;
      }
      final deletedFile = await imageFile.delete();
      final deletedFileStillExists = await deletedFile.exists();
      if (deletedFileStillExists) {
        throw const AppException(
          'We have successfully deleted the file and it is still exists!!',
        );
      }
      AppLogger.log('We have successfully deleted image in: $image');
    }
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

  bool get isInitialized => _localNotesService.isInitialized && true;
}
