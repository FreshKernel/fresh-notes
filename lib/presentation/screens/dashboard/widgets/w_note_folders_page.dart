import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/note_folder/cubit/note_folder_cubit.dart';
import '../../note_folders/w_note_folders.dart';
import '../../note_folders/w_save_note_folder.dart';

class NoteFoldersPage extends StatelessWidget {
  const NoteFoldersPage({super.key});

  static Widget actionButtonBuilder(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final noteFolderBloc = context.read<NoteFolderCubit>();
        final folderName = await showAdaptiveDialog<String?>(
          context: context,
          builder: (context) => const SaveNoteFolderDialog(),
        );
        if (folderName == null) {
          return;
        }
        await noteFolderBloc.createNote(folderName);
      },
      child: const Icon(Icons.add),
    );
  }

  static List<Widget> actionsBuilder(BuildContext context) {
    return [const Icon(Icons.add)];
  }

  @override
  Widget build(BuildContext context) {
    return const NoteFoldersContent();
  }
}
