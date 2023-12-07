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

typedef NoteToolbarOnNavigateCallback = Function(Widget widget);

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

  void _onTapOutside() {
    if (_currentWidget == null) {
      return;
    }
    setState(() {
      _currentWidget = null;
    });
  }

  void _onNavigate(Widget widget) {
    if (_currentWidget != null) {
      setState(() {
        _currentWidget = null;
      });
      return;
    }
    setState(() {
      _currentWidget = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: _currentWidget != null,
              maintainState: true,
              maintainAnimation: true,
              child: AnimatedOpacity(
                opacity: _currentWidget != null ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: _currentWidget,
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
                    onNavigate: _onNavigate,
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
