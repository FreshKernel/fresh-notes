import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteToolbarChecklistButton extends StatelessWidget {
  const NoteToolbarChecklistButton({
    required QuillController controller,
    super.key,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarToggleCheckListButton(
      controller: _controller,
      options: QuillToolbarToggleCheckListButtonOptions(
        attribute: Attribute.unchecked,
        tooltip: 'Checklist',
        iconData: Icons.check_box,
        childBuilder: (options, extraOptions) {
          void sharedOnPressed() {
            extraOptions.onPressed?.call();
          }

          if (extraOptions.isToggled) {
            return IconButton.filled(
              onPressed: sharedOnPressed,
              icon: const Icon(
                Icons.check_box,
              ),
            );
          }
          return IconButton(
            tooltip: 'Checklist',
            onPressed: sharedOnPressed,
            icon: const Icon(Icons.check_box),
          );
        },
      ),
    );
  }
}
