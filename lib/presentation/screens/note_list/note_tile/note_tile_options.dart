import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../../data/notes/universal/models/m_note.dart';
import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';

@immutable
class NoteTileOptions {
  const NoteTileOptions({
    required this.note,
    required this.index,
  });

  final UniversalNote note;
  final int index;

  Future<void> sharedOnMoveToTrashPressed({
    required BuildContext context,
  }) async {
    final noteBloc = context.read<NoteCubit>();
    final shouldConfirmDelete =
        context.read<SettingsCubit>().state.confirmDeleteNote;
    final deletedConfirmed = shouldConfirmDelete
        ? await showYesCancelDialog(
            context: context,
            options: const YesOrCancelDialogOptions(
              title: 'Delete note',
              message: 'Are you sure you want to move this note to trash?',
            ),
          )
        : true;
    if (!deletedConfirmed) {
      return;
    }
    if (note.isTrash) {
      await noteBloc.deleteNote(
        note.id,
      );
      return;
    }
    await noteBloc.moveNoteToTrash(
      note.id,
    );
  }
}
