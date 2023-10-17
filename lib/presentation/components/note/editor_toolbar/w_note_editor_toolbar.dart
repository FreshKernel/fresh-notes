import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'buttons/checklist.dart';
import 'buttons/insert_image.dart';
import 'buttons/text_options/set_text_options.dart';

enum InsertImageSource {
  gallery,
  camera,
  link,
}

class NoteEditorToolbar extends StatelessWidget {
  const NoteEditorToolbar({
    required quill.QuillController controller,
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 40,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(
            width: 10,
          ),
          NoteEditorToolbarImageButton(
            controller: _controller,
          ),
          NoteEditorToolbarChecklistButton(controller: _controller),
          NoteEditorToolbarTextOptionsButton(
            controller: _controller,
          )
        ],
      ),
    );
  }
}
