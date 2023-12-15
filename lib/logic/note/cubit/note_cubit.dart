import 'dart:convert' show jsonDecode;
import 'dart:io' show Directory, File;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:flutter_quill_extensions/utils/quill_image_utils.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/core/cloud/storage/s_cloud_storage.dart';
import '../../../data/core/local/storage/s_local_storage.dart';
import '../../../data/core/shared/database_operations_exceptions.dart';
import '../../../data/notes/cloud/s_cloud_notes.dart';
import '../../../data/notes/local/s_local_notes.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/models/m_note_inputs.dart';
import '../../auth/auth_service.dart';
import '../../utils/extensions/string.dart';
import '../../utils/io/file_utilities.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit({
    required this.cloudNotesService,
    required this.localNotesService,
    required this.localStorageService,
    required this.cloudStorageService,
  }) : super(NoteState.initial());

  final LocalNotesService localNotesService;
  final CloudNotesService cloudNotesService;
  final CloudStorageService cloudStorageService;
  final LocalStorageService localStorageService;
  var _notesFutureLoadded = false;

  Future<List<UniversalNote>> getAllNotes() async {
    final localNotes = (await localNotesService.getAll(limit: -1, page: 1))
        .map(UniversalNote.fromLocalNote);
    final cloudNotes = (await cloudNotesService.getAll(limit: -1, page: 1))
        .map(UniversalNote.fromCloudNote);
    final allNotes = <UniversalNote>{...localNotes, ...cloudNotes};
    return allNotes.toList();
  }

  Future<void> loadAllNotes() async {
    try {
      if (_notesFutureLoadded) {
        return;
      }
      await localNotesService.initialize();
      final allNotes = await getAllNotes();
      emit(NoteState(notes: allNotes.toList()));
      _notesFutureLoadded = true;
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  /// Returns the note text document as json
  Future<String> _saveNoteFiles({
    required String noteText,
    required String noteId,
    required bool isSyncWithCloud,
  }) async {
    final imageUtilities = _getImageUtilitiesByNoteText(noteText);
    final cachedImages =
        imageUtilities.getCachedImagePathsFromDocument().toList();

    final newFileNames = FileUtilities.generateNewFileNames(
      paths: cachedImages,
      newFileStartsWith: 'note-image-',
    ).toList();

    final savedImages = <String>[];
    if (isSyncWithCloud) {
      // TODO: Upload with metadata in firebase storage
      final cloudPaths = await cloudStorageService.uploadMultipleFiles(
        newFileNames.asMap().entries.map((e) {
          final file = File(e.value);
          return ('/notes/${e.value}', file);
        }),
      );
      savedImages.addAll(cloudPaths);
    } else {
      final files = await localStorageService.copyMultipleFile(
        directory: Directory(
          join(
            (await getApplicationDocumentsDirectory()).path,
            'notes-images',
            noteId,
          ),
        ),
        files: cachedImages.map(File.new).toList(),
        names: newFileNames,
      );

      savedImages.addAll(files.map((e) => e.path));
    }

    cachedImages.asMap().forEach((index, cachedImage) {
      final savedImage = savedImages[index];

      noteText = noteText.replaceFirst(cachedImage, savedImage);
    });
    return noteText;
  }

  Future<void> createNote(CreateNoteInput input) async {
    final currentNotes = [...state.notes];
    try {
      final newNoteText = await _saveNoteFiles(
        noteId: input.noteId,
        noteText: input.text,
        isSyncWithCloud: input.isSyncWithCloud,
      );
      input = input.copyWith(
        text: newNoteText,
      );

      // Save the note files first, then emit the new value to the UI
      final note = UniversalNote.fromCreateInput(
        input,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isExistsInTheCloud: input.isSyncWithCloud,
      );
      emit(NoteState(notes: [note, ...state.notes]));

      await localNotesService.createOne(input);
      if (input.isSyncWithCloud) {
        await cloudNotesService.createOne(input);
      }
    } on Exception catch (e) {
      // Revert the creating back
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> deleteNote(String noteId) async {
    final noteToDeleteIndex =
        state.notes.indexWhere((element) => element.noteId == noteId);
    if (noteToDeleteIndex == -1) {
      return;
    }
    final noteToDelete = state.notes[noteToDeleteIndex];
    emit(
      NoteState(
        notes: [...state.notes]..removeAt(noteToDeleteIndex),
      ),
    );
    try {
      final localNote = await localNotesService.getOneById(noteId);
      if (localNote != null) {
        await localNotesService.deleteOneById(noteId);
        _deleteNoteLocalFiles(
          _getImageUtilitiesByNoteText(localNote.text),
        );
      }
      final cloudNote = await cloudNotesService.getOneById(noteId);
      if (cloudNote != null) {
        await cloudNotesService.deleteOneById(noteId);
        await _deleteNoteCloudFiles(
          _getImageUtilitiesByNoteText(cloudNote.text),
        );
      }
    } on Exception catch (e) {
      emit(
        NoteState(
          notes: [
            ...state.notes..insert(noteToDeleteIndex, noteToDelete),
          ],
          exception: e,
        ),
      );
    }
  }

  Future<void> _deleteNoteCloudFiles(QuillImageUtilities imageUtilities) async {
    final images =
        imageUtilities.getImagesPathsFromDocument(onlyLocalImages: false).map(
              (e) => e.isHttpBasedUrl(),
            );
    for (final imageUrl in images) {
      await cloudStorageService.deleteFile('/notes/$imageUrl');
    }
  }

  Future<void> _deleteNoteLocalFiles(QuillImageUtilities imageUtilities) async {
    await imageUtilities.deleteAllLocalImages();
  }

  QuillImageUtilities _getImageUtilitiesByNoteText(String noteText) {
    return QuillImageUtilities(
        document: Document.fromJson(jsonDecode(noteText)));
  }

  Future<void> deleteAll() async {
    final notes = [...state.notes];
    emit(const NoteState(notes: []));
    try {
      for (final cloudNote
          in await cloudNotesService.getAll(limit: -1, page: 1)) {
        await _deleteNoteCloudFiles(
          _getImageUtilitiesByNoteText(cloudNote.text),
        );
      }
      for (final localNote
          in await localNotesService.getAll(limit: -1, page: 1)) {
        await _deleteNoteLocalFiles(
          _getImageUtilitiesByNoteText(localNote.text),
        );
      }
      await localNotesService.deleteAll();
      await localNotesService.deleteAll();
    } on Exception catch (e) {
      emit(
        NoteState(notes: notes, exception: e),
      );
    }
  }

  Future<void> updateNote(UpdateNoteInput input) async {
    final noteIndex =
        state.notes.indexWhere((note) => note.noteId == input.noteId);
    if (noteIndex == -1) {
      return;
    }
    final currentNotes = [...state.notes];

    try {
      Future<void> updateInTheCloud() async {
        final currentLocalNote =
            await localNotesService.getOneById(input.noteId);
        if (currentLocalNote == null) {
          throw const DatabaseOperationCannotFindResourcesException(
            'The note must exists in order to update it.',
          );
        }

        final currentLocalNoteExistsInTheCloud =
            await cloudNotesService.getOneById(currentLocalNote.noteId) != null;

        // Create the note if it doesn't exist and the user wants to sync his offline
        // note so we needs to create it
        if (input.isSyncWithCloud && !currentLocalNoteExistsInTheCloud) {
          await cloudNotesService.createOne(
            CreateNoteInput.fromUpdateInput(
              input,
              userId: AuthService.getInstance().requireCurrentUser().id,
            ),
          );
          // input = input.copyWith(isExistsInTheCloud: true);
        } else if (!input.isSyncWithCloud && currentLocalNoteExistsInTheCloud) {
          // If the current note exist and the user wants to un-sync the note.
          await cloudNotesService.deleteOneById(currentLocalNote.noteId);
          await _deleteNoteCloudFiles(
              _getImageUtilitiesByNoteText(currentLocalNote.text));
          input = input.copyWith(
            isSyncWithCloud: false,
          );
        } else if (currentLocalNoteExistsInTheCloud) {
          // Update the note
          await cloudNotesService.updateOne(input);
        }
      }

      final newNoteText = await _saveNoteFiles(
        noteText: input.text,
        noteId: input.noteId,
        isSyncWithCloud: input.isSyncWithCloud,
      );

      input = input.copyWith(
        text: newNoteText,
      );

      await updateInTheCloud();

      await localNotesService.updateOne(input);

      final newNote = UniversalNote.fromUpdateInput(
        input,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: AuthService.getInstance().requireCurrentUser().id,
      );

      final notes = [...currentNotes];
      notes.removeAt(noteIndex);
      notes.insert(noteIndex, newNote);

      emit(
        NoteState(
          notes: notes,
          message: DateTime.now()
              .toIso8601String(), // Workaround, because of SyncOptions
        ),
      );
    } on Exception catch (e) {
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> moveNoteToTrash(
    String noteId,
  ) async {
    final noteIndex =
        state.notes.indexWhere((element) => element.noteId == noteId);
    if (noteIndex == -1) {
      return;
    }
    final currentNote = state.notes[noteIndex];

    final currentNotes = [...state.notes];

    final notes = [...currentNotes];
    notes.removeAt(noteIndex);
    notes.insert(
      noteIndex,
      currentNote.copyWith(
        isTrash: true,
      ),
    );
    emit(NoteState(notes: notes));
    try {
      final localNote = await localNotesService.getOneById(noteId);
      if (localNote != null) {
        await localNotesService.updateOne(
          UpdateNoteInput.fromLocalNote(localNote).copyWith(isTrash: true),
        );
      }
      final cloudNote = await cloudNotesService.getOneById(noteId);
      if (cloudNote != null) {
        await cloudNotesService.updateOne(
          UpdateNoteInput.fromCloudNote(cloudNote).copyWith(isTrash: true),
        );
      }
    } on Exception catch (e) {
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> moveAllNotesToTrash() async {
    final currentNotes = [...state.notes];
    if (currentNotes.isEmpty) {
      return;
    }
    final newNotes = [...state.notes]
        .map(
          (e) => e.copyWith(isTrash: true),
        )
        .toList();
    emit(NoteState(notes: newNotes));
    try {
      final allNotes = await getAllNotes();
      final updateInputs = allNotes
          .map(UpdateNoteInput.fromUniversalNote)
          .map((e) => e.copyWith(isTrash: true))
          .toList();
      await localNotesService.updateByIds(updateInputs);
      await cloudNotesService.updateByIds(updateInputs);
    } on Exception catch (e) {
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> clearTheTrash() async {
    final currentNotes = [...state.notes];
    if (currentNotes.isEmpty) {
      return;
    }
    final newNotes = [...state.notes]
      ..removeWhere((element) => element.isTrash);
    emit(NoteState(notes: newNotes));
    try {
      final allTrashNotes = (await getAllNotes()).where((note) => note.isTrash);
      for (final trashNote in allTrashNotes) {
        if (trashNote.isSyncWithCloud) {
          await _deleteNoteCloudFiles(
            _getImageUtilitiesByNoteText(trashNote.text),
          );
        } else {
          await _deleteNoteLocalFiles(
            _getImageUtilitiesByNoteText(trashNote.text),
          );
        }
      }
      final allNotesIds = allTrashNotes.map((e) => e.noteId).toList();
      await localNotesService.deleteByIds(allNotesIds);
      await cloudNotesService.deleteByIds(allNotesIds);
    } on Exception catch (e) {
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> syncLocalNotesFromCloud() async {
    try {
      final cloudNotes = await cloudNotesService.getAll(limit: -1, page: 1);
      if (cloudNotes.isEmpty) {
        return;
      }

      final localNotes = await localNotesService.getAll(limit: -1, page: 1);
      final localNotesIdsWithSync = localNotes
          .where((element) => element.isSyncWithCloud)
          .map((e) => e.noteId)
          .where((element) => element.trim().isNotEmpty)
          .toList();

      if (localNotesIdsWithSync.isNotEmpty) {
        await localNotesService.deleteByIds(localNotesIdsWithSync);
      }

      final createInputs =
          cloudNotes.map(CreateNoteInput.fromCloudNote).toList();

      await localNotesService.createMultiples(createInputs);

      final notes = await getAllNotes();
      emit(NoteState(notes: notes));
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  @override
  Future<void> close() async {
    if (localNotesService.isInitialized) {
      await localNotesService.deInitialize();
    }
    return super.close();
  }
}
