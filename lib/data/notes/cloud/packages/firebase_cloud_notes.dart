import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

import '../../../../logic/auth/auth_service.dart';
import '../../../core/shared/database_operations_exceptions.dart';
import '../../universal/models/m_note_inputs.dart';
import '../models/cloud_note_repository.dart';
import '../models/m_cloud_note.dart';

class FirebaseCloudNotesImpl extends CloudNotesRepository {
  final _notesCollection = FirebaseFirestore.instance.collection(
    CloudNoteProperties.notes,
  );

  @override
  Future<CloudNote> createOne(CreateNoteInput createInput) async {
    final result = await _notesCollection.add(
      CloudNote.toFirebaseMapFromCreateInput(
        input: createInput,
      ),
    );
    final currentDate = DateTime.now();
    return CloudNote.fromCreateNoteInput(
      input: createInput,
      cloudId: result.id,
      createdAt: currentDate,
      updatedAt: currentDate,
    );
  }

  @override
  Future<void> deleteAll() async {
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
  Future<void> deleteByIds(List<String> ids) async {
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
  Future<List<CloudNote>> createMultiples(List<CreateNoteInput> list) async {
    final batch = FirebaseFirestore.instance.batch();
    final notes = list.map((createInput) {
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
    return notes.toList();
  }

  @override
  Future<void> deleteOneById(String id) async {
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
  Future<List<CloudNote>> getAll({
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
      return List.empty();
    }
    final notes = documents.docs.map((e) => CloudNote.fromFirebase(
          e.data(),
          id: e.id,
        ));
    return notes.toList();
  }

  @override
  Future<List<CloudNote>> getAllByIds(List<String> ids) async {
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
            id: ids[document.key],
          ),
        );
    return notes.toList();
  }

  @override
  Future<CloudNote?> getOneById(String id) async {
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
    return CloudNote.fromFirebase(
      data,
      id: result.id,
    );
  }

  @override
  Future<CloudNote> updateOne(
    UpdateNoteInput updateInput,
  ) async {
    final currentNote = await getOneById(updateInput.noteId);
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
    return CloudNote.fromUpdateNoteInput(
      input: updateInput,
      cloudId: currentNote.id,
      createdAt: currentNote.createdAt,
      updatedAt: DateTime.now(),
      userId: currentNote.userId,
    );
  }

  @override
  Future<void> updateByIds(List<UpdateNoteInput> entities) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final noteInput in entities) {
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
}
