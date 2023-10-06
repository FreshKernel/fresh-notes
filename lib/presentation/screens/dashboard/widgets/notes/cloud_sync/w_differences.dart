import 'package:flutter/material.dart';

import '../../../../../../logic/utils/others/differnce_result.dart';
import '../../../../../../models/note/m_note.dart';

class SyncCloudToLocalNotesDifferences extends StatelessWidget {
  const SyncCloudToLocalNotesDifferences(
      {required this.differenceResult, super.key});

  final ListDifferenceResult<Note> differenceResult;

  List<Widget> _buildItem({
    required List<Note> notes,
    required String label,
  }) {
    return [
      if (notes.isNotEmpty) ...[
        Text(label),
        NotesDifferencesResults(notes: notes)
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Note differneces'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Ok'),
        ),
      ],
      content: Container(
        constraints: const BoxConstraints(
          minHeight: 300,
          minWidth: 250,
        ),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildItem(
              notes: differenceResult.missingsItems,
              label: 'Missings',
            ),
          ],
        ),
      ),
    );
  }
}

class NotesDifferencesResults extends StatefulWidget {
  const NotesDifferencesResults({
    required this.notes,
    super.key,
  });

  final List<Note> notes;

  @override
  State<NotesDifferencesResults> createState() =>
      _NotesDifferencesResultsState();
}

class _NotesDifferencesResultsState extends State<NotesDifferencesResults> {
  List<Note> get _notes => widget.notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _notes.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return _NoteDifferenceItem(
          key: ValueKey(note.id),
          note: note,
          onChanged: (value) {},
        );
      },
    );
  }
}

class _NoteDifferenceItem extends StatefulWidget {
  const _NoteDifferenceItem({
    required this.note,
    required this.onChanged,
    super.key,
  });
  final Note note;
  final ValueChanged<bool> onChanged;

  @override
  State<_NoteDifferenceItem> createState() => _NoteDifferenceItemState();
}

class _NoteDifferenceItemState extends State<_NoteDifferenceItem> {
  Note get note => widget.note;
  var _selected = true;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      key: ValueKey(note.id),
      title: Text(note.text),
      value: _selected,
      onChanged: (value) {
        final newValue = value ?? true;
        setState(() => _selected = newValue);
        widget.onChanged(newValue);
      },
    );
  }
}
