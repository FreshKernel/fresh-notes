import 'dart:async';

import 'package:my_notes/core/data/crud_exceptions.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/note/s_cloud_notes.dart';
import 'package:my_notes/services/cloud/shared/sync_options.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';
import 'package:path/path.dart';

import 'dart:convert' show jsonEncode;

import '../../../utils/packages/quill.dart';
import 'models/m_note_input.dart';

class NotesDataService {
  NotesDataService._();

  static final _instance = NotesDataService._();
  factory NotesDataService.getInstance() => _instance;

  final List<Note> _notes = [];
  final StreamController<List<Note>> _notesStreamController =
      StreamController<List<Note>>.broadcast(
    onListen: () {
      AppLogger.log(
        'onListen: A new user is now listenting for the notes stream controller.',
      );
    },
    onCancel: () {
      AppLogger.log(
        'onCancel: The user has cancel the listenting for the notes stream controller.',
      );
    },
  );

  StreamController<List<Note>> get notesStreamController =>
      _notesStreamController;
  final _localNotesService = LocalNotesService.getInstance();
  final _cloudNotesService = CloudNotesService.getInstance();

  Future<void> startAndFetchAllNotes() async {
    try {
      _notes.clear();
      await initialize();
      await getAll();
    } catch (e, stacktrace) {
      _notesStreamController.addError(e, stacktrace);
    }
  }

  Future<void> initialize() async {
    await _localNotesService.initialize();
  }

  bool get isInitialized => _localNotesService.isInitialized && true; // Cloud

  // @override
  Future<void> close() async {
    await _localNotesService.deInitialize();
  }

  Future<void> createOne(CreateNoteInput createInput) async {
    final syncOptions = createInput.syncOptions;
    String? cloudId;
    if (syncOptions.isSyncWithCloud) {
      final cloudNote = await _cloudNotesService.createOne(createInput);
      cloudId = cloudNote.id;
    }
    final note = Note.fromLocalNote(
      await _localNotesService.createOne(
        createInput.copyWith(
          syncOptions: SyncOptions.getSyncOptions(
            isSyncWithCloud: syncOptions.isSyncWithCloud,
            existingCloudNoteId: cloudId,
          ),
        ),
      ),
    );
    _notes.insert(0, note);
    _notesStreamController.add(_notes);
  }

  Future<void> insertOrReplaceOne(
    QuillDocument document, {
    String? currentId,
    required SyncOptions syncOptions,
    required bool isPrivate,
  }) async {
    AppLogger.log('Sync option = ${syncOptions.toString()}');
    final isEditing = currentId != null;
    final user = AuthService.getInstance().requireCurrentUser(
      'In order to create or update note, the user must be authenticated.',
    );

    final cachedImages =
        await QuillUtilities.getCachedImagePathsFromDocumentAndMakeSureItExists(
            document);
    AppLogger.log(
      'Local images: ${QuillUtilities.getLocalImagesPathsFromDocument(document).toString()}',
    );
    final newImages = await QuillUtilities.saveCachedImagesToDocumentDirectory(
      cachedImages: cachedImages,
    );

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
        UpdateNoteInput(
          text: documentInJson,
          syncOptions: syncOptions,
          isPrivate: isPrivate,
        ),
        currentId,
      );
      return;
    }
    await createOne(
      CreateNoteInput(
        text: documentInJson,
        userId: user.id,
        syncOptions: syncOptions,
        isPrivate: isPrivate,
      ),
    );
  }

  Future<void> deleteAll() async {
    await _localNotesService.deleteAll();
    for (final note in _notes) {
      await QuillUtilities.deleteAllImagesOfNote(note.text);
    }
    _notes.clear();
    _notesStreamController.add(_notes);
    await _cloudNotesService.deleteAll();
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
      final note = _notes[noteIndex];
      await QuillUtilities.deleteAllImagesOfNote(_notes[noteIndex].text);
      _notes.removeAt(noteIndex);
      _notesStreamController.add(_notes);

      final cloudNoteId = note.syncOptions.getCloudNoteId();
      if (cloudNoteId != null) {
        await _cloudNotesService.deleteOneById(cloudNoteId);
      }
      return;
    }
    throw CrudOperationFaieldException(
      "We couldn't find the index for the currentId of the deleting note in NoteDataService, the id is $id",
    );
  }

  Future<void> getAll({int limit = -1, int page = 1}) async {
    final localNotes = (await _localNotesService.getAll(
      limit: limit,
      page: page,
    ))
        .map((e) => Note.fromLocalNote(e))
        .toList();
    _notes.addAll(localNotes);
    _notesStreamController.add(_notes);
  }

  Future<void> updateOne(UpdateNoteInput updateInput, String currentId) async {
    final localNote = await _localNotesService.getOneById(currentId);
    if (localNote == null) {
      throw const CrudCannotFindResourcesexception(
        'The note must exists in order to update it.',
      );
    }
    final isCurrentLocalNoteExistsInTheCloud = localNote.cloudId != null;

    bool shouldUpdateInTheCloud = false;
    var newUpdateInput = updateInput;

    final isSyncWithCloudNewInput = updateInput.syncOptions.isSyncWithCloud;
    final isExistInCloudUpdateInput = updateInput.syncOptions.isExistsInCloud;

    AppLogger.log('Is sync with cloud = $isSyncWithCloudNewInput');
    AppLogger.log('Is existing in cloud = $isCurrentLocalNoteExistsInTheCloud');

    // Create the note if it does not exists and user want to sync
    if (isSyncWithCloudNewInput && !isExistInCloudUpdateInput) {
      AppLogger.log(
        'We will sync this note to the cloud by creating it and update the local note',
      );
      final userId = AuthService.getInstance()
          .requireCurrentUser(
            'In order to sync the note to the cloud by creating it and update it locally\n'
            'user must be authenticated.',
          )
          .id;
      final cloudNote = await _cloudNotesService.createOne(
        CreateNoteInput(
          text: updateInput.text,
          syncOptions: updateInput.syncOptions,
          isPrivate: updateInput.isPrivate,
          userId: userId,
        ),
      );
      shouldUpdateInTheCloud = true;
      newUpdateInput = newUpdateInput.copyWith(
        syncOptions: SyncOptions.syncWithExistingCloudId(cloudNote.id),
      );
    } else if (!isSyncWithCloudNewInput &&
        (isCurrentLocalNoteExistsInTheCloud)) {
      // If the current note is exists and the user want to unsync the note.
      AppLogger.log(
        'Delete the existing note in the cloud since the user no longer want to sync it',
      );
      AuthService.getInstance().requireCurrentUser(
        'In order to sync the note to the cloud by deleting it and update it locally\n'
        'user must be authenticated.',
      );
      final cloudNoteId = localNote.cloudId;
      if (cloudNoteId == null) {
        throw ArgumentError(
          'The isCurrentLocalNoteExistsInTheCloud is true while the cloudNoteId is null which does not make any sense\n'
          'Please check isCurrentLocalNoteExistsInTheCloud in the update function',
        );
      }
      await _cloudNotesService.deleteOneById(cloudNoteId);
      shouldUpdateInTheCloud = true;
    }

    var newNote = Note.fromLocalNote(
      await _localNotesService.updateOne(newUpdateInput, currentId),
    );

    final index =
        _notes.indexWhere((currentNote) => currentNote.id == currentId);
    if (index != -1) {
      final note = _notes[index];
      _notes.removeAt(index);
      _notes.insert(0, newNote);
      _notesStreamController.add(_notes);

      if (shouldUpdateInTheCloud) {
        return;
      }

      final cloudNoteId = note.syncOptions.getCloudNoteId();
      if (cloudNoteId != null) {
        await _cloudNotesService.updateOne(
          updateInput,
          cloudNoteId,
        );
      }
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
}
