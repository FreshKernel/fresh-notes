import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/services/cloud/note/models/cloud_note_repository.dart';
import 'package:my_notes/services/cloud/note/models/m_cloud_note.dart';
import 'package:my_notes/services/cloud/note/packages/firebase_cloud_notes.dart';
import 'package:my_notes/services/data/notes/models/m_note_input.dart';

class CloudNotesService extends CloudNotesRepository {
  CloudNotesService._(this._provider);

  factory CloudNotesService.firebaseFirestore() => CloudNotesService._(
        FirebaseCloudNotesImpl(),
      );
  factory CloudNotesService.getInstance() => AppModule.cloudNotesService;

  final CloudNotesRepository _provider;

  @override
  Future<List<CloudNote>> createMultiples(List<CreateNoteInput> list) =>
      _provider.createMultiples(list);

  @override
  Future<CloudNote> createOne(CreateNoteInput createInput) =>
      _provider.createOne(createInput);

  @override
  Future<void> deleteAll() => _provider.deleteAll();

  @override
  Future<void> deleteByIds(List<String> ids) => _provider.deleteByIds(ids);

  @override
  Future<void> deleteOneById(String id) => _provider.deleteOneById(id);

  @override
  Future<List<CloudNote>> getAll({
    required int limit,
    required int page,
  }) =>
      _provider.getAll(
        limit: limit,
        page: page,
      );

  @override
  Future<List<CloudNote>> getAllByIds(List<String> ids) => getAllByIds(ids);

  @override
  Future<CloudNote?> getOneById(String id) => _provider.getOneById(id);

  @override
  Future<CloudNote> updateOne(UpdateNoteInput updateInput, String currentId) =>
      _provider.updateOne(updateInput, currentId);
}
