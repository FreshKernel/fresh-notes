import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/models/m_note_inputs.dart';
import '../../../data/notes/universal/s_universal_notes.dart';

part 'note_state.dart';
part 'note_cubit.freezed.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteState.initial());

  final universalNotesService = UniversalNotesService.getInstance();

  void moveNoteToTrash(String id) {}

  Future<void> deleteNote(String id) async {
    await universalNotesService.deleteOneById(id);
  }

  Future<void> addNote(CreateNoteInput createInput) async {
    await universalNotesService.createOne(createInput);
  }

  @override
  Future<void> close() async {
    await universalNotesService.deInitialize();
    return super.close();
  }
}
