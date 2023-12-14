import 'dart:convert' show jsonDecode;
import 'dart:io' show Directory, File;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:flutter_quill_extensions/utils/quill_image_utils.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/core/cloud/database/sync_options.dart';
import '../../../data/core/cloud/storage/s_cloud_storage.dart';
import '../../../data/core/local/storage/s_local_storage.dart';
import '../../../data/core/shared/database_operations_exceptions.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/models/m_note_inputs.dart';
import '../../../data/notes/universal/s_universal_notes.dart';
import '../../auth/auth_service.dart';
import '../../utils/extensions/string.dart';
import '../../utils/io/file_utilities.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteState.initial());

  final universalNotesService = UniversalNotesService.getInstance();
  var _notesFutureLoadded = false;

  Future<void> loadAllNotes() async {
    try {
      if (_notesFutureLoadded) {
        return;
      }
      await universalNotesService.initialize();
      final notes = await universalNotesService.getAll();
      emit(NoteState(notes: notes));
      _notesFutureLoadded = true;
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  final cloudStorageService = CloudStorageService.getInstance();
  final localStorageService = LocalStorageService.getInstance();

  Future<void> createNote(CreateNoteInput input) async {
    final note = UniversalNote.fromCreateInput(
      input,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    emit(NoteState(notes: [note, ...state.notes]));
    try {
      final imageUtilities = QuillImageUtilities(
        document: Document.fromJson(
          jsonDecode(input.text),
        ),
      );
      final cachedImages =
          imageUtilities.getCachedImagePathsFromDocument().toList();

      final newFileNames = FileUtilities.generateNewFileNames(
        paths: cachedImages,
        newFileStartsWith: 'note-image-',
      ).toList();

      final savedImages = <String>[];
      if (input.isSyncWithCloud) {
        // TODO: Upload with metadata in firebase storage
        final cloudPaths = await cloudStorageService.uploadMultipleFiles(
          newFileNames.asMap().entries.map((e) {
            final file = File(e.value);
            return ('/notes/${e.value}', file);
          }),
        );
        savedImages.addAll(cloudPaths);
      } else {
        // TODO: Don't hardcode things here in this file
        final files = await localStorageService.copyMultipleFile(
          directory: Directory(
            join(
              (await getApplicationDocumentsDirectory()).path,
              'notes-images',
            ),
          ),
          files: cachedImages.map(File.new).toList(),
          names: newFileNames,
        );

        savedImages.addAll(files.map((e) => e.path));
      }

      cachedImages.asMap().forEach((index, cachedImage) {
        final savedImage = savedImages[index];

        input = input.copyWith(
          text: input.text.replaceFirst(cachedImage, savedImage),
        );
      });

      await universalNotesService.createOne(input);
    } on Exception catch (e) {
      // Revert the creating back
      emit(NoteState(notes: [...state.notes]..remove(note), exception: e));
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
      final note = await universalNotesService.getOneById(noteId);
      if (note == null) {
        return;
      }
      await _deleteNoteFiles(note);
      await universalNotesService.deleteOneById(note.noteId);
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

  Future<void> _deleteNoteCloudFiles(String noteText) async {
    final imageUtilities = QuillImageUtilities(
      document: Document.fromJson(
        jsonDecode(noteText),
      ),
    );
    final images =
        imageUtilities.getImagesPathsFromDocument(onlyLocalImages: false).map(
              (e) => e.isHttpBasedUrl(),
            );
    for (final imageUrl in images) {
      await cloudStorageService.deleteFile('/notes/$imageUrl');
    }
  }

  Future<void> _deleteNoteFiles(UniversalNote note) async {
    final imageUtilities = QuillImageUtilities(
      document: Document.fromJson(
        jsonDecode(note.text),
      ),
    );

    // TODO: test this
    if (note.syncOptions.isExistsInCloud) {
      await _deleteNoteCloudFiles(note.text);
    }
    await imageUtilities.deleteAllLocalImages();
  }

  Future<void> deleteAll() async {
    final notes = [...state.notes];
    emit(const NoteState(notes: []));
    try {
      for (final note in await universalNotesService.getAll()) {
        await _deleteNoteFiles(note);
      }
      await universalNotesService.deleteAll();
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
    final notes = [...currentNotes];

    final newNote = UniversalNote.fromUpdateInput(
      input,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: AuthService.getInstance().requireCurrentUser().id,
    );
    notes.removeAt(noteIndex);
    notes.insert(noteIndex, newNote);

    emit(
      NoteState(
        notes: notes,
        message: DateTime.now()
            .toIso8601String(), // Workaround, because of SyncOptions
      ),
    );

    try {
      Future<void> updateInTheCloud() async {
        final currentLocalNote = await universalNotesService.localNotesService
            .getOneById(input.noteId);
        if (currentLocalNote == null) {
          throw const DatabaseOperationCannotFindResourcesException(
            'The note must exists in order to update it.',
          );
        }

        final currentLocalNoteExistsInCloud = currentLocalNote.cloudId != null;

        // Create the note if it doesn't exist and the user wants to sync his offline
        // note so we needs to create it
        if (input.isSyncWithCloud && !currentLocalNoteExistsInCloud) {
          final cloudNote =
              await universalNotesService.cloudNotesService.createOne(
            CreateNoteInput.fromUpdateInput(
              input,
              userId: AuthService.getInstance().requireCurrentUser().id,
            ),
          );
          input = input.copyWith(
            syncOptions: SyncOptions.syncWithExistingCloudId(cloudNote.id),
          );
        } else if (!input.isSyncWithCloud && currentLocalNoteExistsInCloud) {
          // If the current note exist and the user wants to un-sync the note.
          await universalNotesService.cloudNotesService
              .deleteOneById(currentLocalNote.noteId);
          await _deleteNoteCloudFiles(currentLocalNote.text);
          input = input.copyWith(
            isSyncWithCloud: false,
          );
        } else if (input.isExistsInCloud) {
          // Update the note
          await universalNotesService.cloudNotesService.updateOne(input);
        }
      }

      await updateInTheCloud();

      await universalNotesService.localNotesService.updateOne(input);
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
      final note = await universalNotesService.getOneById(noteId);
      if (note == null) {
        return;
      }
      await universalNotesService.updateOne(
        UpdateNoteInput.fromUniversalNote(note).copyWith(isTrash: true),
      );
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
      final allNotes = await universalNotesService.getAll();
      final updateInputs = allNotes
          .map(UpdateNoteInput.fromUniversalNote)
          .map((e) => e.copyWith(isTrash: true))
          .toList();
      await universalNotesService.updateByIds(updateInputs);
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
      final allNoteIds = (await universalNotesService.getAll())
          .where((note) => note.isTrash)
          .map((e) => e.noteId)
          .toList();
      await universalNotesService.deleteByIds(
        allNoteIds,
      );
    } on Exception catch (e) {
      emit(NoteState(notes: currentNotes, exception: e));
    }
  }

  Future<void> syncLocalNotesFromCloud() async {
    try {
      await universalNotesService.syncLocalNotesFromCloud();
      final notes = await universalNotesService.getAll();
      emit(NoteState(notes: notes));
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  @override
  Future<void> close() async {
    if (universalNotesService.isInitialized) {
      await universalNotesService.deInitialize();
    }
    return super.close();
  }
}
