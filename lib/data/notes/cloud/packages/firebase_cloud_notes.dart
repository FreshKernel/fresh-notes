import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

import '../../../../logic/auth/auth_service.dart';
import '../../../core/shared/database_operations_exceptions.dart';
import '../../note_repository.dart';
import '../../universal/models/m_note.dart';
import '../../universal/models/m_note_inputs.dart';
import '../models/m_cloud_note.dart';

class FirebaseCloudNotesImpl extends NotesRepository {
  final _notesCollection = FirebaseFirestore.instance.collection(
    CloudNoteProperties.notes,
  );

  @override
  Future<UniversalNote> insertNote(CreateNoteInput createInput) async {
    final result = await _notesCollection.add(
      CloudNote.toFirebaseMapFromCreateInput(
        input: createInput,
      ),
    );
    final currentDate = DateTime.now();
    return UniversalNote.fromCloudNote(
      CloudNote.fromCreateNoteInput(
        input: createInput,
        cloudId: result.id,
        createdAt: currentDate,
        updatedAt: currentDate,
      ),
    );
  }

  @override
  Future<void> deleteAllNotes() async {
    final userId = AuthService.getInstance()
        .requireCurrentUser(
          'To delete all notes from the cloud, user must be authenticated.',
        )
        .id;
    final batch = FirebaseFirestore.instance.batch();
    final noteCollection = await _notesCollection
        .where(
          CloudNoteProperties.userId,
          isEqualTo: userId,
        )
        .get();
    for (final noteDocument in noteCollection.docs) {
      batch.delete(noteDocument.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> deleteNotesByIds(Iterable<String> ids) async {
    final batch = FirebaseFirestore.instance.batch();
    final notes = await _notesCollection
        .where(CloudNoteProperties.noteId, whereIn: ids)
        .get();
    for (final query in notes.docs) {
      batch.delete(query.reference);
    }
    await batch.commit();
  }

  @override
  Future<List<UniversalNote>> insertNotes(
      Iterable<CreateNoteInput> inputs) async {
    final batch = FirebaseFirestore.instance.batch();
    final notes = inputs.map((createInput) {
      final documentId = _notesCollection.doc();
      batch.set(
        documentId,
        CloudNote.toFirebaseMapFromCreateInput(
          input: createInput,
        ),
      );
      final currentDate = DateTime.now();
      return CloudNote.fromCreateNoteInput(
        input: createInput,
        cloudId: documentId.id,
        createdAt: currentDate,
        updatedAt: currentDate,
      );
    });
    await batch.commit();
    return notes.map(UniversalNote.fromCloudNote).toList();
  }

  @override
  Future<void> deleteNoteById(String id) async {
    final userId = AuthService.getInstance().requireCurrentUser().id;
    final result = await _notesCollection
        .where(CloudNoteProperties.userId, isEqualTo: userId)
        .where(CloudNoteProperties.noteId, isEqualTo: id)
        .limit(1)
        .get();
    final first = result.docs.firstOrNull;
    if (first != null) {
      await first.reference.delete();
    }
  }

  @override
  Future<List<UniversalNote>> getAllNotes({
    required int limit,
    required int page,
  }) async {
    final userId = AuthService.getInstance()
        .requireCurrentUser(
          'To get all notes from clouds, user must be authenticated',
        )
        .id;
    final documents = await _notesCollection
        .where(
          CloudNoteProperties.userId,
          isEqualTo: userId,
        )
        .orderBy(
          CloudNoteProperties.updatedAt,
          descending: true,
        )
        .get();
    if (documents.docs.isEmpty) {
      return [];
    }
    final notes = documents.docs.map((e) => CloudNote.fromFirebase(
          e.data(),
          id: e.id,
        ));
    return notes.map(UniversalNote.fromCloudNote).toList();
  }

  @override
  Future<List<UniversalNote>> getAllNotesByIds(Iterable<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    final userId = AuthService.getInstance()
        .requireCurrentUser(
          'To get all notes from clouds, user must be authenticated',
        )
        .id;
    final notesDocuments = await _notesCollection
        .where(
          CloudNoteProperties.userId,
          isEqualTo: userId,
        )
        .where(
          CloudNoteProperties.noteId,
          whereIn: ids,
        )
        .get();
    if (notesDocuments.docs.isEmpty) {
      return [];
    }

    final notes = notesDocuments.docs.asMap().entries.map(
          (document) => CloudNote.fromFirebase(
            document.value.data(),
            id: ids.toList()[document.key],
          ),
        );
    return notes.map(UniversalNote.fromCloudNote).toList();
  }

  @override
  Future<UniversalNote?> getNoteById(String id) async {
    final userId = AuthService.getInstance().requireCurrentUser().id;
    final result = (await _notesCollection
            .where(CloudNoteProperties.userId, isEqualTo: userId)
            .where(CloudNoteProperties.noteId, isEqualTo: id)
            .limit(1)
            .get())
        .docs
        .firstOrNull;
    if (result == null) {
      return null;
    }
    if (!result.exists) return null;
    final data = result.data();
    return UniversalNote.fromCloudNote(
      CloudNote.fromFirebase(
        data,
        id: result.id,
      ),
    );
  }

  @override
  Future<UniversalNote> updateNote(
    UpdateNoteInput updateInput,
  ) async {
    final currentNote = await getNoteById(updateInput.noteId);
    if (currentNote == null) {
      throw const DatabaseOperationCannotFindResourcesException(
        'We could not find this note to update it.',
      );
    }
    final userId = AuthService.getInstance().requireCurrentUser().id;
    final note = (await _notesCollection
            .where(CloudNoteProperties.userId, isEqualTo: userId)
            .where(CloudNoteProperties.noteId, isEqualTo: updateInput.noteId)
            .limit(1)
            .get())
        .docs
        .firstOrNull;
    if (note != null) {
      await note.reference.update(
        CloudNote.toFirebaseMapFromUpdateInput(
          input: updateInput,
        ),
      );
    }
    return UniversalNote.fromUpdateInput(
      updateInput,
      createdAt: currentNote.createdAt,
      updatedAt: DateTime.now(),
      userId: userId,
    );
  }

  @override
  Future<void> updateNotesByIds(Iterable<UpdateNoteInput> inputs) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final noteInput in inputs) {
      final noteDoc = (await _notesCollection
              .where(
                CloudNoteProperties.noteId,
                isEqualTo: noteInput.noteId,
              )
              .limit(1)
              .get())
          .docs
          .firstOrNull;

      if (noteDoc == null) {
        continue;
      }
      if (!noteDoc.exists) {
        continue;
      }
      batch.update(
        noteDoc.reference,
        CloudNote.toFirebaseMapFromUpdateInput(input: noteInput),
      );
    }

    await batch.commit();
  }

  @override
  Future<Iterable<UniversalNote>> searchAllNotes({
    required String searchQuery,
  }) async {
    final results = await _notesCollection
        .where(
          CloudNoteProperties.text,
          arrayContains: searchQuery,
        )
        .where(
          CloudNoteProperties.title,
          arrayContains: searchQuery,
        )
        .orderBy(
          CloudNoteProperties.updatedAt,
          descending: true,
        )
        .get();
    if (results.docs.isEmpty) {
      return [];
    }
    return results.docs.map(
      (e) => UniversalNote.fromCloudNote(
        CloudNote.fromFirebase(e.data(), id: e.id),
      ),
    );
  }
}
