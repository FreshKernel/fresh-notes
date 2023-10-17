import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../../utils/dialog/w_app_dialog.dart';
import '../../../../../utils/extensions/build_context_extensions.dart';
import '../../../../others/app_scroll_bar.dart';

class NoteEditorToolbarTextOptionsButton extends StatelessWidget {
  const NoteEditorToolbarTextOptionsButton({
    required quill.QuillController controller,
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Text options',
      onPressed: () {
        showAppDialog(
          context: context,
          builder: (context) {
            return _TextOptionsWidget(
              controller: _controller,
              onButtonPressed: () {
                context.navigator.pop();
              },
            );
          },
        );
      },
      icon: const Icon(Icons.text_fields),
    );
  }
}

class _TextOptionsWidget extends StatelessWidget {
  const _TextOptionsWidget({
    required quill.QuillController controller,
    // ignore: unused_element
    super.key,
    // ignore: unused_element
    this.onButtonPressed,
  }) : _controller = controller;

  final quill.QuillController _controller;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Text options'),
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppScrollBar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TextOptionSection(
                    buttons: [
                      _ToggleStyleButton(
                        iconData: Icons.format_list_bulleted,
                        controller: _controller,
                        attribute: quill.Attribute.ul,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Bullet list',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_list_numbered,
                        controller: _controller,
                        attribute: quill.Attribute.ol,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Numbered list',
                      ),
                    ],
                  ),
                  _TextOptionSection(
                    buttons: [
                      IconButton(
                        tooltip: 'Align left',
                        onPressed: () {
                          _controller.formatSelection(
                            quill.Attribute.leftAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_left),
                      ),
                      IconButton(
                        tooltip: 'Align center',
                        onPressed: () {
                          _controller.formatSelection(
                            quill.Attribute.centerAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_center),
                      ),
                      IconButton(
                        tooltip: 'Align right',
                        onPressed: () {
                          _controller.formatSelection(
                            quill.Attribute.rightAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_right),
                      ),
                      IconButton(
                        tooltip: 'Align justify',
                        onPressed: () {
                          _controller.formatSelection(
                            quill.Attribute.justifyAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_justify),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AppScrollBar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TextOptionSection(
                    buttons: [
                      _ToggleStyleButton(
                        attribute: quill.Attribute.bold,
                        iconData: Icons.format_bold,
                        controller: _controller,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Bold',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_italic,
                        controller: _controller,
                        attribute: quill.Attribute.italic,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Italic',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_underline,
                        controller: _controller,
                        attribute: quill.Attribute.underline,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Underline',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_strikethrough,
                        controller: _controller,
                        attribute: quill.Attribute.strikeThrough,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Strike through',
                      ),
                    ],
                  ),
                  _TextOptionSection(
                    buttons: [
                      _IndentTextButton(
                        controller: _controller,
                        isIncrease: true,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Increase indent',
                      ),
                      _IndentTextButton(
                        controller: _controller,
                        isIncrease: false,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Decrease indent',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextOptionSection extends StatelessWidget {
  const _TextOptionSection({
    required this.buttons,
    // ignore: unused_element
    super.key,
    // ignore: unused_element
    this.boxConstraints = const BoxConstraints(
      minHeight: 70,
    ),
  });

  final List<Widget> buttons;
  final BoxConstraints boxConstraints;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: boxConstraints,
        child: Card(
          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(16),
          //   ),
          // ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buttons,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleStyleButton extends StatelessWidget {
  const _ToggleStyleButton({
    required this.iconData,
    required quill.QuillController controller,
    required this.attribute,
    required this.tooltip,
    required this.onButtonPressed,
    // ignore: unused_element
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;
  final quill.Attribute attribute;
  final IconData iconData;
  final VoidCallback? onButtonPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return quill.ToggleStyleButton(
      attribute: attribute,
      icon: iconData,
      controller: _controller,
      childBuilder: (context, attribute, icon, fillColor, isToggled, onPressed,
          afterPressed,
          [iconSize = -1, iconTheme]) {
        return IconButton(
          tooltip: tooltip,
          onPressed: () {
            onPressed?.call();
            afterPressed?.call();
            onButtonPressed?.call(); // of this widget
          },
          icon: Icon(iconData),
        );
      },
    );
  }
}

class _IndentTextButton extends StatelessWidget {
  const _IndentTextButton({
    required quill.QuillController controller,
    required this.isIncrease,
    required this.onButtonPressed,
    required this.tooltip,
    // ignore: unused_element
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;
  final bool isIncrease;
  final VoidCallback? onButtonPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () {
        _controller.indentSelection(isIncrease);
        onButtonPressed?.call();
      },
      icon: Icon(
        isIncrease
            ? Icons.format_indent_increase
            : Icons.format_indent_decrease,
      ),
    );
  }
}
