import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../../../../data/notes/universal/models/m_note.dart';
import '../../../../../../data/notes/universal/s_universal_notes.dart';
import '../../../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../../../utils/dialog/w_yes_cancel_dialog.dart';

@immutable
class NoteItemOptions {
  const NoteItemOptions({
    required this.notesDataService,
    required this.note,
    required this.index,
  });

  final UniversalNotesService notesDataService;
  final UniversalNote note;
  final int index;

  Future<void> sharedOnPressed({
    required BuildContext context,
  }) async {
    final shouldConfirmDelete =
        context.read<SettingsCubit>().state.confirmDeleteNote;
    final deletedConfirmed = shouldConfirmDelete
        ? await showYesCancelDialog(
            context: context,
            options: const YesOrCancelDialogOptions(
              title: 'Delete note',
              message: 'Are you sure you want to delete this note',
            ),
          )
        : true;
    if (!deletedConfirmed) {
      return;
    }
    notesDataService.deleteOneById(
      note.id,
    );
  }
}
