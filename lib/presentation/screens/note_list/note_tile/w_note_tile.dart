import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../logic/utils/extensions/string.dart';
import '../../../l10n/extensions/localizations.dart';
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

    return Dismissible(
      confirmDismiss: (direction) async {
        final result = await NoteTileOptions.sharedOnMoveToDeletePressed(
          context: context,
          note: options.note,
        );
        return result;
      },
      key: ValueKey(options.index),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          onTap: () => options.sharedOnPressed(context: context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          isThreeLine: true,
          contentPadding: const EdgeInsets.all(12),
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
              (options.index + 1).toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 450) {
                return TextButton.icon(
                  onPressed: () => NoteTileOptions.sharedOnMoveToDeletePressed(
                    context: context,
                    note: options.note,
                  ),
                  icon: const Icon(Icons.delete),
                  label: Text(context.loc.delete),
                  style: TextButton.styleFrom(
                    foregroundColor: materialTheme.colorScheme.error,
                  ),
                );
              }
              return IconButton(
                tooltip: context.loc.delete,
                onPressed: () => NoteTileOptions.sharedOnMoveToDeletePressed(
                  context: context,
                  note: options.note,
                ),
                icon: const Icon(Icons.delete),
                color: materialTheme.colorScheme.error,
              );
            },
          ),
        ),
      ),
    );
  }
}
