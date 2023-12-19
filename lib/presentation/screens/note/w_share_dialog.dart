import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/extensions/localizations.dart';

enum ShareOption { link, text }

class NoteShareDialog extends StatelessWidget {
  const NoteShareDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(context.loc.link),
              subtitle: Text(
                context.loc.shareNoteByLink,
              ),
              leading: const Icon(Icons.link),
              onTap: () => context.pop(ShareOption.link),
            ),
            ListTile(
              title: Text(context.loc.text),
              subtitle: Text(
                context.loc.shareNoteByText,
              ),
              leading: const Icon(Icons.note),
              onTap: () => context.pop(ShareOption.text),
            ),
          ],
        ),
      ),
    );
  }
}
