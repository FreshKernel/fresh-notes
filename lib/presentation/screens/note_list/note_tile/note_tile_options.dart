import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../../data/notes/universal/models/m_note.dart';
import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
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
    final shouldConfirmMoveToTrash =
        context.read<SettingsCubit>().state.confirmMoveNoteToTrash;
    final confirmed =
        (note.isTrash ? shouldConfirmDelete : shouldConfirmMoveToTrash)
            ? await showYesCancelDialog(
                context: context,
                options: YesOrCancelDialogOptions(
                  title: note.isTrash
                      ? context.loc.confirmMoveNoteToTrash
                      : context.loc.confirmDeleteNote,
                  message: note.isTrash
                      ? context.loc.confirmMoveNoteToTrashDesc
                      : context.loc.confirmDeleteNoteDesc,
                ),
              )
            : true;
    if (!confirmed) {
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
