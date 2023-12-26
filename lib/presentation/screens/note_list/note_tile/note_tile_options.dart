import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../../data/notes/universal/models/m_note.dart';
import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../note/s_note.dart';

@immutable
class NoteTileOptions {
  const NoteTileOptions({
    required this.note,
    required this.index,
  });

  final UniversalNote note;
  final int index;

  void sharedOnPressed({required BuildContext context}) {
    context.push(
      NoteScreen.routeName,
      extra: NoteScreenArgs(
        note: note,
      ),
    );
  }

  static Future<bool> sharedOnMoveToDeletePressed({
    required BuildContext context,
    required UniversalNote note,
  }) async {
    final noteBloc = context.read<NoteCubit>();
    final shouldConfirmDelete =
        context.read<SettingsCubit>().state.confirmDeleteNote;
    final shouldConfirmMoveToTrash =
        context.read<SettingsCubit>().state.confirmMoveNoteToTrash;
    final confirmed =
        (note.isTrash ? shouldConfirmDelete : shouldConfirmMoveToTrash)
            ? await showOkCancelDialog(
                context: context,
                options: OkOrCancelDialogOptions(
                  title: !note.isTrash
                      ? context.loc.confirmMoveNoteToTrash
                      : context.loc.confirmDeleteNote,
                  message: !note.isTrash
                      ? context.loc.confirmMoveNoteToTrashDesc
                      : context.loc.confirmDeleteNoteDesc,
                ),
              )
            : true;
    if (!confirmed) {
      return false;
    }
    if (note.isTrash) {
      await noteBloc.deleteNote(
        note.noteId,
      );
      return true;
    }
    await noteBloc.moveNoteToTrash(
      note.noteId,
    );
    return true;
  }
}
