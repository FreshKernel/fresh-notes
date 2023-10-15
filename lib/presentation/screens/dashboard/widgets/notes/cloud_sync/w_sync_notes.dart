import 'package:flutter/material.dart';

import '../../../../../../data/notes/universal/s_universal_notes.dart';
import '../../../../../utils/dialog/w_app_dialog.dart';
import '../../../../../utils/extensions/build_context_extensions.dart';
import 'w_differences.dart';

class SyncNotesIconButton extends StatefulWidget {
  const SyncNotesIconButton({super.key});

  @override
  State<SyncNotesIconButton> createState() => _SyncNotesIconButtonState();
}

class _SyncNotesIconButtonState extends State<SyncNotesIconButton> {
  var _isLoading = false;

  Future<void> _getCloudToLocalNotesDifferences() async {
    try {
      final messenger = context.messenger;

      setState(() => _isLoading = true);
      final listDifferencesResult = await UniversalNotesService.getInstance()
          .getCloudToLocalNotesDifferences();
      final differences = listDifferencesResult.differences;
      final missings = listDifferencesResult.missingsItems;
      if (differences.isEmpty && missings.isEmpty) {
        messenger.showMessage('Notes are already synced');
        return;
      }
      Future.microtask(
        () => showAppDialog(
          context: context,
          builder: (context) {
            return SyncCloudToLocalNotesDifferences(
              differenceResult: listDifferencesResult,
            );
          },
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Sync with cloud',
      onPressed: _isLoading ? null : _getCloudToLocalNotesDifferences,
      icon: const Icon(Icons.sync),
    );
  }
}
