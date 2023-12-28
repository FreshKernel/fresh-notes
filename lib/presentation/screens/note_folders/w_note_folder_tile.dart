import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/note_folder/models/m_note_folder.dart';
import '../../../logic/note_folder/cubit/note_folder_cubit.dart';

class NoteFolderTile extends StatelessWidget {
  const NoteFolderTile({required this.noteFolder, super.key});

  final NoteFolder noteFolder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NoteFolderCubit>().navigateToFolder(noteFolder);
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(noteFolder.folderName),
          ],
        ),
      ),
    );
  }
}
