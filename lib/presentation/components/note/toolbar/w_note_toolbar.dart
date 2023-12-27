import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

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
  Widget? _currentWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: QuillToolbar(
        child: _currentWidget ??
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  NoteToolbarImageButton(
                    controller: widget._controller,
                  ),
                  NoteToolbarChecklistButton(
                    controller: widget._controller,
                  ),
                  NoteToolbarTextOptionsButton(
                    controller: widget._controller,
                    onNavigate: (newWidget) =>
                        setState(() => _currentWidget = newWidget),
                    onNavigateBack: () => setState(() => _currentWidget = null),
                  ),
                  QuillToolbarClearFormatButton(
                    controller: widget._controller,
                  ),
                  QuillToolbarLinkStyleButton(
                    controller: widget._controller,
                  ),
                  QuillToolbarVideoButton(controller: widget._controller),
                  QuillToolbarHistoryButton(
                    controller: widget._controller,
                    isUndo: true,
                  ),
                  QuillToolbarHistoryButton(
                    controller: widget._controller,
                    isUndo: false,
                  ),
                  QuillToolbarSelectHeaderStyleDropdownButton(
                    controller: widget._controller,
                  ),
                  QuillToolbarFontSizeButton(
                    controller: widget._controller,
                  ),
                  QuillToolbarFontFamilyButton(
                    controller: widget._controller,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
      ),
    );
  }
}
