import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../note_list/w_notes_list.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

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
            onPressed: state.trashNotes.isEmpty
                ? null
                : () async {
                    final noteBloc = context.read<NoteCubit>();
                    final deletedAllConfirmed = await showOkCancelDialog(
                      context: context,
                      options: OkOrCancelDialogOptions(
                        title: context.loc.clearTheTrash,
                        message: context.loc.clearTheTrashDesc,
                        yesLabel: context.loc.deleteAll,
                      ),
                    );
                    if (!deletedAllConfirmed) {
                      return;
                    }
                    noteBloc.clearTheTrash();
                  },
            icon: const Icon(Icons.delete_forever),
          );
        },
      ),
    ];
  }

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NoteListContent(isTrashList: true);
  }

  @override
  bool get wantKeepAlive => true;
}
