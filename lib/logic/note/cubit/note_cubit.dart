import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
    if (input.syncOptions.isSyncWithCloud) {
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
        directory: Directory(join(
            (await getApplicationDocumentsDirectory()).path, 'notes-images')),
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

    final note = await universalNotesService.createOne(input);

    emit(NoteState(notes: [note, ...state.notes]));
  }

  Future<void> deleteNote(String noteId) async {
    final note = await universalNotesService.getOneById(noteId);
    if (note == null) {
      return;
    }
    await universalNotesService.deleteOneById(note.noteId);
    await _deleteNoteFiles(note);
    emit(NoteState(
      notes: state.notes.where((element) => element.noteId != noteId).toList(),
    ));
  }

  Future<void> _deleteNoteFiles(UniversalNote note) async {
    final imageUtilities = QuillImageUtilities(
      document: Document.fromJson(
        jsonDecode(note.text),
      ),
    );

    // TODO: test this
    if (note.syncOptions.isExistsInCloud) {
      imageUtilities
          .getImagesPathsFromDocument(onlyLocalImages: true)
          .forEach((image) {
        cloudStorageService.deleteFile('/notes/$image');
      });
    }
    await imageUtilities.deleteAllLocalImages();
  }

  Future<void> deleteAll() async {
    for (final note in await universalNotesService.getAll()) {
      await _deleteNoteFiles(note);
    }
    await universalNotesService.deleteAll();
    emit(const NoteState(notes: []));
  }

  Future<void> updateNote(UpdateNoteInput input) async {
    final currentLocalNote =
        await universalNotesService.localNotesService.getOneById(input.noteId);
    if (currentLocalNote == null) {
      throw const DatabaseOperationCannotFindResourcesException(
        'The note must exists in order to update it.',
      );
    }

    final currentLocalNoteExistsInCloud = currentLocalNote.cloudId != null;

    // Create the note if it doesn't exist and the user wants to sync his offline
    // note so we needs to create it
    if (input.syncOptions.isSyncWithCloud && !currentLocalNoteExistsInCloud) {
      final cloudNote = await universalNotesService.cloudNotesService.createOne(
        CreateNoteInput.fromUpdateInput(
          input,
          userId: AuthService.getInstance().requireCurrentUser().id,
        ),
      );
      input = input.copyWith(
        syncOptions: SyncOptions.syncWithExistingCloudId(cloudNote.id),
      );
    } else if (!input.syncOptions.isSyncWithCloud &&
        currentLocalNoteExistsInCloud) {
      // If the current note exist and the user wants to un-sync the note.
      universalNotesService.cloudNotesService.deleteOneById(
          currentLocalNote.cloudId ??
              (throw ArgumentError('The cloud id is required, the ')));
      input = input.copyWith(
        syncOptions: SyncOptions.noSync(),
      );
      await universalNotesService.cloudNotesService.deleteOneById(input.noteId);
    } else if (input.syncOptions.isExistsInCloud) {
      // Update the note
      await universalNotesService.cloudNotesService.updateOne(input);
    }

    final localNote =
        await universalNotesService.localNotesService.updateOne(input);
    final newNote = UniversalNote.fromLocalNote(
      localNote,
    );

    final noteIndex =
        state.notes.indexWhere((note) => note.noteId == input.noteId);
    if (noteIndex == -1) {
      return;
    }
    final notes = [...state.notes];
    notes.removeAt(noteIndex);
    notes.insert(noteIndex, newNote);

    emit(NoteState(notes: notes));
  }

  Future<void> moveNoteToTrash(
    String noteId,
  ) async {
    final note = await universalNotesService.getOneById(noteId);
    if (note == null) {
      return;
    }
    final newNote = await universalNotesService.updateOne(
      UpdateNoteInput.fromUniversalNote(note).copyWith(isTrash: true),
    );

    final notes = [...state.notes];
    final noteIndex =
        notes.indexWhere((element) => element.noteId == note.noteId);
    if (noteIndex == -1) {
      return;
    }
    notes.removeAt(noteIndex);
    notes.insert(noteIndex, newNote);

    emit(NoteState(notes: notes));
  }

  Future<void> moveAllNotesToTrash() async {
    final allNotes = await universalNotesService.getAll();
    universalNotesService.deleteByIds(allNotes.map((e) => e.noteId).toList());
    final newNotes = [...state.notes]
        .where((element) => !element.isTrash)
        .map(
          (e) => e.copyWith(isTrash: true),
        )
        .toList();
    emit(NoteState(notes: newNotes));
  }

  Future<void> clearTheTrash() async {
    final allNotes =
        (await universalNotesService.getAll()).where((note) => note.isTrash);
    await universalNotesService
        .deleteByIds(allNotes.map((e) => e.noteId).toList());
    final newNotes = [...state.notes]
      ..removeWhere((element) => element.isTrash);
    emit(NoteState(notes: newNotes));
  }

  Future<void> syncLocalNotesFromCloud() async {
    await universalNotesService.syncLocalNotesFromCloud();
    final notes = await universalNotesService.getAll();
    emit(NoteState(notes: notes));
  }

  @override
  Future<void> close() async {
    if (universalNotesService.isInitialized) {
      await universalNotesService.deInitialize();
    }
    return super.close();
  }
}
