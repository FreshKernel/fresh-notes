import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../../data/notes/universal/models/m_note.dart';
import '../../../../../data/notes/universal/s_universal_notes.dart';
import '../../../../../logic/settings/cubit/settings_cubit.dart';
import '../../../../../logic/utils/extensions/string.dart';
import '../../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../../save_note/s_save_note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    required this.notesDataService,
    required this.note,
    required this.index,
    super.key,
  });

  final UniversalNotesService notesDataService;
  final UniversalNote note;
  final int index;

  @override
  Widget build(BuildContext context) {
    final document = quill.Document.fromJson(jsonDecode(note.text));
    final materialTheme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      onTap: () {
        Navigator.of(context).pushNamed(
          SaveNoteScreen.routeName,
          arguments: SaveNoteScreenArgs(
            note: note,
          ),
        );
      },
      title: Text(
        document.toPlainText(),
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        // style: materialTheme.primaryTextTheme.titleMedium,
      ),
      subtitle: Text(
        document.toPlainText().removeWhiteSpaces(),
        softWrap: true,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        // style: materialTheme.primaryTextTheme.bodyMedium,
      ),
      leading: CircleAvatar(
        child: Text(
          note.id.limitToCharacters(2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 450) {
            return TextButton.icon(
              onPressed: () => notesDataService.deleteOneById(note.id),
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: materialTheme.colorScheme.error,
              ),
            );
          }
          return IconButton(
            tooltip: 'Delete',
            onPressed: () async {
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
              notesDataService.deleteOneById(note.id);
            },
            icon: const Icon(Icons.delete),
            color: materialTheme.colorScheme.error,
          );
        },
      ),
    );
  }
}
