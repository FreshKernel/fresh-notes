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

typedef NoteToolbarPopupCallback = Function(Widget widget);

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
  Widget? _currentPopup;

  void _onTapOutside() {
    if (_currentPopup == null) {
      return;
    }
    setState(() {
      _currentPopup = null;
    });
  }

  void _onShowPopup(Widget widget) {
    if (_currentPopup != null) {
      setState(() {
        _currentPopup = null;
      });
      return;
    }
    setState(() {
      _currentPopup = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbarProvider(
      toolbarConfigurations: const QuillToolbarConfigurations(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _currentPopup != null,
              maintainState: true,
              maintainAnimation: true,
              child: AnimatedOpacity(
                opacity: _currentPopup != null ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: _currentPopup,
              ),
            ),
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
                    onClose: _onTapOutside,
                    onShowPopup: _onShowPopup,
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