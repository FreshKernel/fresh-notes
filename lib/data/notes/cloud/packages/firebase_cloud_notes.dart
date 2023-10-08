import 'package:cloud_firestore/cloud_firestore.dart';

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
    for (final documentId in ids) {
      batch.delete(_notesCollection.doc(documentId));
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
    await _notesCollection.doc(id).delete();
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
          FieldPath.documentId,
          whereIn: ids,
        )
        .get();

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
    final result = await _notesCollection.doc(id).get();
    if (!result.exists) return null;
    final data = result.data();
    if (data == null) return null;
    return CloudNote.fromFirebase(
      data,
      id: result.id,
    );
  }

  @override
  Future<CloudNote> updateOne(
    UpdateNoteInput updateInput,
    String currentId,
  ) async {
    final currentNote = await getOneById(currentId);
    if (currentNote == null) {
      throw const DatabaseOperationCannotFindResourcesException(
        'We could not find this note to update it.',
      );
    }
    await _notesCollection.doc(currentId).update(
          CloudNote.toFirebaseMapFromUpdateInput(
            input: updateInput,
          ),
        );
    return CloudNote.fromUpdateNoteInput(
      input: updateInput,
      cloudId: currentNote.id,
      createdAt: currentNote.createdAt,
      updatedAt: DateTime.now(),
      userId: currentNote.userId,
    );
  }
}
