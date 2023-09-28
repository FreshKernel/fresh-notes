import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/data/notes/s_notes_data.dart';
import 'package:my_notes/utils/extensions/string.dart';

import '../../../save_note/s_save_note.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.notesDataService,
    required this.note,
    required this.index,
  });

  final NotesDataService notesDataService;
  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    final document = quill.Document.fromJson(jsonDecode(note.text));
    final materialTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        final navigator = Navigator.of(context);
        navigator.push(MaterialPageRoute(
          settings: const RouteSettings(
            name: SaveNoteScreen.routeName,
          ),
          builder: (context) {
            return SaveNoteScreen(
              note: note,
            );
          },
        ));
      },
      child: ListTile(
        title: Text(
          document.toPlainText().limitToCharacters(30).removeWhiteSpaces(),
        ),
        subtitle: Text(
          document.toPlainText().limitToCharacters(200).removeWhiteSpaces(),
        ),
        leading: CircleAvatar(
          child: Text(note.id.toString()),
        ),
        trailing: IconButton(
          tooltip: 'Delete',
          onPressed: () async {
            await notesDataService.deleteOneById(note.id);
          },
          icon: const Icon(Icons.delete),
          color: materialTheme.colorScheme.error,
        ),
      ),
    );
  }
}
