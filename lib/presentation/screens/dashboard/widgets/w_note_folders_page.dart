import 'package:flutter/material.dart';

import '../../note_folders/w_note_folders.dart';
import '../../note_folders/w_save_folder.dart';

class NoteFoldersPage extends StatelessWidget {
  const NoteFoldersPage({super.key});

  static Widget actionButtonBuilder(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final folderName = await showAdaptiveDialog<String?>(
          context: context,
          builder: (context) => const SaveNoteFolderDialog(),
        );
        if (folderName == null) {
          return;
        }
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
