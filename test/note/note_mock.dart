// import 'package:fresh_notes/data/core/shared/data_utils.dart';
// import 'package:fresh_notes/data/notes/cloud/models/m_cloud_note.dart';
// import 'package:fresh_notes/data/notes/local/models/m_local_note.dart';
// import 'package:fresh_notes/data/notes/universal/models/m_note_inputs.dart';

// class LocalNotesMockImpl extends Note {
//   LocalNotesMockImpl({
//     this.notes = const [],
//   });

//   List<LocalNote> notes;
//   @override
//   Future<List<LocalNote>> createMultiples(
//       Iterable<CreateNoteInput> list) async {
//     final id = generateRandomItemId();
//     notes.insertAll(
//       0,
//       list.map(
//         (e) => LocalNote.fromCreateNoteInput(
//           input: e,
//           id: id,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       ),
//     );
//     return notes;
//   }

//   @override
//   Future<LocalNote> createOne(CreateNoteInput createInput) async {
//     return LocalNote.fromCreateNoteInput(
//       input: createInput,
//       id: generateRandomItemId(),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   @override
//   Future<void> deInitialize() async {}

//   @override
//   Future<void> deleteAll() async {
//     notes.clear();
//   }

//   @override
//   Future<void> deleteByIds(Iterable<String> ids) async {
//     for (final note in ids) {
//       await deleteOneById(note);
//     }
//   }

//   @override
//   Future<void> deleteOneById(String id) async {
//     notes.removeWhere((element) => element.noteId == id);
//   }

//   @override
//   Future<List<LocalNote>> getAll(
//           {required int limit, required int page}) async =>
//       notes;

//   @override
//   Future<List<LocalNote>> getAllByIds(Iterable<String> ids) async {
//     final list = <LocalNote>[];
//     for (final element in ids) {
//       list.insert(
//         0,
//         await getOneById(element) ?? (throw ArgumentError.notNull()),
//       );
//     }
//     return list;
//   }

//   @override
//   Future<LocalNote?> getOneById(String id) async {
//     return notes.where((element) => element.noteId == id).first;
//   }

//   @override
//   Future<void> initialize() {
//     throw UnimplementedError();
//   }

//   @override
//   bool get isInitialized => throw UnimplementedError();

//   @override
//   Future<void> updateByIds(Iterable<UpdateNoteInput> entities) async {
//     for (final element in entities) {
//       await updateOne(element);
//     }
//   }

//   @override
//   Future<LocalNote?> updateOne(UpdateNoteInput updateInput) async {
//     final index =
//         notes.indexWhere((element) => element.noteId == updateInput.noteId);
//     if (index == -1) {
//       return null;
//     }
//     final currentNote = notes[index];
//     notes.removeAt(index);
//     notes.insert(
//       index,
//       LocalNote.fromUpdateNoteInput(
//         input: updateInput,
//         id: currentNote.id,
//         createdAt: currentNote.createdAt,
//         updatedAt: DateTime.now(),
//         userId: updateInput.userId,
//       ),
//     );
//     return notes[index];
//   }

//   @override
//   Future<List<LocalNote>> searchAll({required String query}) {
//     throw UnimplementedError();
//   }
// }

// class CloudNotesMockImpl extends CloudNotesRepository {
//   CloudNotesMockImpl({
//     this.notes = const [],
//   });

//   List<CloudNote> notes;
//   @override
//   Future<List<CloudNote>> createMultiples(
//       Iterable<CreateNoteInput> list) async {
//     final id = generateRandomItemId();
//     notes.insertAll(
//       0,
//       list.map(
//         (e) => CloudNote.fromCreateNoteInput(
//           input: e,
//           cloudId: id,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       ),
//     );
//     return notes;
//   }

//   @override
//   Future<CloudNote> createOne(CreateNoteInput createInput) async {
//     return CloudNote.fromCreateNoteInput(
//       input: createInput,
//       cloudId: generateRandomItemId(),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//   }

//   @override
//   Future<void> deleteAll() async {
//     notes.clear();
//   }

//   @override
//   Future<void> deleteByIds(Iterable<String> ids) async {
//     for (final note in ids) {
//       await deleteOneById(note);
//     }
//   }

//   @override
//   Future<void> deleteOneById(String id) async {
//     notes.removeWhere((element) => element.noteId == id);
//   }

//   @override
//   Future<List<CloudNote>> getAll(
//           {required int limit, required int page}) async =>
//       notes;

//   @override
//   Future<List<CloudNote>> getAllByIds(Iterable<String> ids) async {
//     final list = <CloudNote>[];
//     for (final element in ids) {
//       list.insert(
//         0,
//         await getOneById(element) ?? (throw ArgumentError.notNull()),
//       );
//     }
//     return list;
//   }

//   @override
//   Future<CloudNote?> getOneById(String id) async {
//     return notes.where((element) => element.noteId == id).first;
//   }

//   @override
//   Future<void> updateByIds(Iterable<UpdateNoteInput> entities) async {
//     for (final element in entities) {
//       await updateOne(element);
//     }
//   }

//   @override
//   Future<CloudNote?> updateOne(UpdateNoteInput updateInput) async {
//     final index =
//         notes.indexWhere((element) => element.noteId == updateInput.noteId);
//     if (index == -1) {
//       return null;
//     }
//     final currentNote = notes[index];
//     notes.removeAt(index);
//     notes.insert(
//       index,
//       CloudNote.fromUpdateNoteInput(
//         input: updateInput,
//         cloudId: currentNote.id,
//         createdAt: currentNote.createdAt,
//         updatedAt: DateTime.now(),
//         userId: updateInput.userId,
//       ),
//     );
//     return notes[index];
//   }

//   @override
//   Future<List<CloudNote>> searchAll({required String query}) {
//     throw UnimplementedError();
//   }
// }
