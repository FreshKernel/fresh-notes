import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'buttons/checklist.dart';
import 'buttons/insert_image.dart';
import 'buttons/text_options/set_text_options.dart';

enum InsertImageSource {
  gallery,
  camera,
  link,
}

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({
    required QuillController controller,
    super.key,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  State<NoteToolbar> createState() => _NoteToolbarState();
}

class _NoteToolbarState extends State<NoteToolbar> {
  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                  NoteToolbarImageButton(
                    controller: widget._controller,
                  ),
                  NoteToolbarChecklistButton(
                    controller: widget._controller,
                  ),
                  NoteToolbarTextOptionsButton(
                    controller: widget._controller,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
