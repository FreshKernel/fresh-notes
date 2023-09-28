import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/data/notes/s_notes_data.dart';

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
        title: const Text('My title'),
        subtitle: Text(document.toPlainText()),
        leading: const Text('Hi'),
        trailing: IconButton(
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
