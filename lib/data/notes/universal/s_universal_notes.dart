import '../../../core/services/s_app.dart';
import '../../../data/notes/cloud/s_cloud_notes.dart';
import '../../core/shared/database_operations_exceptions.dart';
import '../local/s_local_notes.dart';
import 'models/m_note.dart';
import 'models/m_note_inputs.dart';

class UniversalNotesService extends AppService {
  factory UniversalNotesService.getInstance() => _instance;
  UniversalNotesService._();

  static final _instance = UniversalNotesService._();

  final localNotesService = LocalNotesService.getInstance();
  final cloudNotesService = CloudNotesService.getInstance();

  /// Start and fetch the notes
  ///
  /// could throw [Exception]
  Future<void> startService() async {
    try {
      await initialize();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> initialize() async {
    await localNotesService.initialize();
  }

  @override
  bool get isInitialized => localNotesService.isInitialized;

  @override
  Future<void> deInitialize() async {
    await localNotesService.deInitialize();
  }

  Future<UniversalNote> createOne(CreateNoteInput createInput) async {
    final localNote = await localNotesService.createOne(createInput);
    if (createInput.syncOptions.isSyncWithCloud) {
      await cloudNotesService.createOne(createInput);
    }
    return UniversalNote.fromLocalNote(localNote);
  }

  Future<void> deleteAll() async {
    await localNotesService.deleteAll();
    await cloudNotesService.deleteAll();
  }

  Future<void> deleteByIds(List<String> ids) async {
    final notes = await localNotesService.getAllByIds(ids);
    final cloudNotesIds =
        notes.where((e) => e.isSyncWithCloud).map((e) => e.noteId).toList();
    await localNotesService.deleteByIds(ids);
    await cloudNotesService.deleteByIds(cloudNotesIds);
  }

  Future<void> deleteOneById(String id) async {
    final localNote = await localNotesService.getOneById(id);
    if (localNote == null) {
      return;
    }
    await localNotesService.deleteOneById(id);
    if (localNote.isSyncWithCloud) {
      await cloudNotesService.deleteOneById(id);
    }
  }

  Future<List<UniversalNote>> getAll({int limit = -1, int page = 1}) async {
    final localNotes =
        (await localNotesService.getAll(limit: limit, page: page))
            .map(UniversalNote.fromLocalNote);
    final cloudNotes =
        (await cloudNotesService.getAll(limit: limit, page: page))
            .map(UniversalNote.fromCloudNote);
    final notes = <UniversalNote>{...localNotes, ...cloudNotes};
    return notes.toList();
  }

  Future<UniversalNote> updateOne(
    UpdateNoteInput input,
  ) async {
    final localNote = await localNotesService.getOneById(input.noteId);
    if (localNote == null) {
      throw const DatabaseOperationCannotFindResourcesException(
        'The note must exist in order to update it.',
      );
    }

    final newLocalNote = await localNotesService.updateOne(input);
    if (localNote.isSyncWithCloud) {
      await cloudNotesService.updateOne(input);
    }
    return UniversalNote.fromLocalNote(newLocalNote);
  }

  Future<void> syncLocalNotesFromCloud() async {
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

    if (localNotesIdsWithSync.isEmpty) {
      return;
    }

    await localNotesService.deleteByIds(localNotesIdsWithSync);

    final createInputs = cloudNotes.map(CreateNoteInput.fromCloudNote).toList();

    await localNotesService.createMultiples(createInputs);
  }

  Future<List<UniversalNote>> getAllByIds(List<String> ids) async {
    throw UnimplementedError();
  }

  Future<UniversalNote?> getOneById(String id) async {
    final localNote = await localNotesService.getOneById(id);
    if (localNote != null) {
      return UniversalNote.fromLocalNote(localNote);
    }
    final cloudNote = await cloudNotesService.getOneById(id);
    if (cloudNote != null) {
      return UniversalNote.fromCloudNote(cloudNote);
    }
    return null;
  }
}
