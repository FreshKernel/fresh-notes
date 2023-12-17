import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../note_list/w_notes_list.dart';
import '../../note/s_note.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  static List<Widget> actionsBuilder(BuildContext context) {
    return [
      IconButton(
        tooltip: context.loc.toggleGridItem,
        onPressed: () {
          final settingsBloc = context.read<SettingsCubit>();
          settingsBloc.updateSettings(
            settingsBloc.state.copyWith(
              useNoteGridTile: !settingsBloc.state.useNoteGridTile,
            ),
          );
        },
        icon: const Icon(Icons.list),
      ),
      BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          return IconButton(
            tooltip: context.loc.deleteAll,
            onPressed: state.nonTrashNotes.isEmpty
                ? null
                : () async {
                    final noteBloc = context.read<NoteCubit>();
                    final deletedAllConfirmed = await showYesCancelDialog(
                      context: context,
                      options: YesOrCancelDialogOptions(
                        title: context.loc.moveAllNotesToTrash,
                        message: context.loc.moveAllNotesToTrashDesc,
                        yesLabel: context.loc.deleteAll,
                      ),
                    );
                    if (!deletedAllConfirmed) {
                      return;
                    }
                    noteBloc.moveAllNotesToTrash();
                  },
            icon: const Icon(Icons.delete_forever),
          );
        },
      ),
    ];
  }

  static Widget actionButtonBuilder(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push(
        NoteScreen.routeName,
        extra: const NoteScreenArgs(),
      ),
      child: const Icon(Icons.add),
    );
  }

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NoteListContent(
      isTrashList: false,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
