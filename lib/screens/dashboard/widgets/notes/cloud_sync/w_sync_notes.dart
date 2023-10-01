import 'package:flutter/material.dart';
import '../../../../../services/data/notes/s_notes_data.dart';
import '../../../../../utils/ui/dialog/w_app_dialog.dart';

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
      final messenger = ScaffoldMessenger.of(context);

      setState(() => _isLoading = true);
      final listDifferencesResult = await NotesDataService.getInstance()
          .getCloudToLocalNotesDifferences();
      final differences = listDifferencesResult.differences;
      final missings = listDifferencesResult.missingsItems;
      if (differences.isEmpty && missings.isEmpty) {
        messenger.clearSnackBars();
        messenger.showSnackBar(const SnackBar(
          content: Text(
            'Notes are already synced',
          ),
        ));
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
