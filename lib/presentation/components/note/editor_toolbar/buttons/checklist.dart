import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteEditorToolbarChecklistButton extends StatelessWidget {
  const NoteEditorToolbarChecklistButton({
    required quill.QuillController controller,
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return quill.ToggleCheckListButton(
      attribute: quill.Attribute.unchecked,
      tooltip: 'Checklist',
      controller: _controller,
      icon: Icons.check_box,
      childBuilder: (context, attribute, icon, fillColor, isToggled, onPressed,
          afterPressed,
          [iconSize = -1, iconTheme]) {
        return IconButton(
          tooltip: 'Checklist',
          onPressed: () {
            onPressed?.call();
            afterPressed?.call();
          },
          icon: const Icon(Icons.check_box),
        );
      },
    );
  }
}
