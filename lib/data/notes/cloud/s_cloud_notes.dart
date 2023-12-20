import '../../../core/app_module.dart';
import '../universal/models/m_note_inputs.dart';
import 'models/cloud_note_repository.dart';
import 'models/m_cloud_note.dart';
import 'packages/firebase_cloud_notes.dart';

class CloudNotesService extends CloudNotesRepository {
  CloudNotesService(this._provider);

  factory CloudNotesService.firebaseFirestore() => CloudNotesService(
        FirebaseCloudNotesImpl(),
      );
  factory CloudNotesService.getInstance() => AppModule.cloudNotesService;

  final CloudNotesRepository _provider;

  @override
  Future<List<CloudNote>> createMultiples(Iterable<CreateNoteInput> list) =>
      _provider.createMultiples(list);

  @override
  Future<CloudNote> createOne(CreateNoteInput createInput) =>
      _provider.createOne(createInput);

  @override
  Future<void> deleteAll() => _provider.deleteAll();

  @override
  Future<void> deleteByIds(Iterable<String> ids) => _provider.deleteByIds(ids);

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
  Future<List<CloudNote>> getAllByIds(Iterable<String> ids) =>
      _provider.getAllByIds(ids);

  @override
  Future<CloudNote?> getOneById(String id) => _provider.getOneById(id);

  @override
  Future<CloudNote?> updateOne(UpdateNoteInput updateInput) =>
      _provider.updateOne(updateInput);

  @override
  Future<void> updateByIds(Iterable<UpdateNoteInput> entities) =>
      _provider.updateByIds(entities);
}
