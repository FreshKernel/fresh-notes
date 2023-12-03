import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../../../logic/utils/extensions/string.dart';
import '../../../../save_note/s_save_note.dart';
import 'note_tile_options.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    required this.options,
    super.key,
  });

  final NoteTileOptions options;

  @override
  Widget build(BuildContext context) {
    final document = quill.Document.fromJson(
      jsonDecode(options.note.text),
    );
    final materialTheme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      onTap: () => Navigator.of(context).pushNamed(
        SaveNoteScreen.routeName,
        arguments: SaveNoteScreenArgs(
          note: options.note,
        ),
      ),
      title: Text(
        options.note.title,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        // style: materialTheme.textTheme.titleMedium,
      ),
      subtitle: Text(
        document.toPlainText().removeWhiteSpaces(),
        softWrap: true,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        // style: materialTheme.textTheme.bodyMedium,
      ),
      leading: CircleAvatar(
        child: Text(
          options.note.id.limitToCharacters(2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 450) {
            return TextButton.icon(
              onPressed: () => options.sharedOnPressed(context: context),
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: materialTheme.colorScheme.error,
              ),
            );
          }
          return IconButton(
            tooltip: 'Delete',
            onPressed: () => options.sharedOnPressed(context: context),
            icon: const Icon(Icons.delete),
            color: materialTheme.colorScheme.error,
          );
        },
      ),
    );
  }
}
