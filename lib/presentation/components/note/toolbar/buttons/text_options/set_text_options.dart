import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../../../others/app_scroll_bar.dart';
import '../../w_note_toolbar.dart';

class NoteToolbarTextOptionsButton extends StatelessWidget {
  const NoteToolbarTextOptionsButton({
    required QuillController controller,
    required this.onShowPopup,
    required this.onClose,
    super.key,
  }) : _controller = controller;

  // ignore: unused_field
  final QuillController _controller;
  final NoteToolbarPopupCallback onShowPopup;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //popup a attachments toast
        // final cancel = BotToast.showAttachedWidget(
        //   attachedBuilder: (_) => _TextOptionsWidget(
        //     controller: _controller,
        //   ),
        //   duration: const Duration(seconds: 2),
        //   target: const Offset(520, 520),
        // );
        // cancel(); //close
      },
      tooltip: 'Text options',
      icon: const Icon(Icons.text_fields),
    );
  }
}

// ignore: unused_element
class _TextOptionsWidget extends StatelessWidget {
  const _TextOptionsWidget({
    required QuillController controller,
    // ignore: unused_element
    super.key,
    // ignore: unused_element
    this.onButtonPressed,
  }) : _controller = controller;

  final QuillController _controller;
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
                        toggledIconData: Icons.format_list_bulleted_outlined,
                        controller: _controller,
                        attribute: Attribute.ul,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Bullet list',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_list_numbered,
                        toggledIconData: Icons.format_list_numbered_outlined,
                        controller: _controller,
                        attribute: Attribute.ol,
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
                            Attribute.leftAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_left),
                      ),
                      IconButton(
                        tooltip: 'Align center',
                        onPressed: () {
                          _controller.formatSelection(
                            Attribute.centerAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_center),
                      ),
                      IconButton(
                        tooltip: 'Align right',
                        onPressed: () {
                          _controller.formatSelection(
                            Attribute.rightAlignment,
                          );
                        },
                        icon: const Icon(Icons.format_align_right),
                      ),
                      IconButton(
                        tooltip: 'Align justify',
                        onPressed: () {
                          _controller.formatSelection(
                            Attribute.justifyAlignment,
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
                        attribute: Attribute.bold,
                        iconData: Icons.format_bold,
                        toggledIconData: Icons.format_bold_outlined,
                        controller: _controller,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Bold',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_italic,
                        toggledIconData: Icons.format_italic_outlined,
                        controller: _controller,
                        attribute: Attribute.italic,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Italic',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_underline,
                        toggledIconData: Icons.format_underline_outlined,
                        controller: _controller,
                        attribute: Attribute.underline,
                        onButtonPressed: onButtonPressed,
                        tooltip: 'Underline',
                      ),
                      _ToggleStyleButton(
                        iconData: Icons.format_strikethrough,
                        toggledIconData: Icons.format_strikethrough_outlined,
                        controller: _controller,
                        attribute: Attribute.strikeThrough,
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
    required this.toggledIconData,
    required QuillController controller,
    required this.attribute,
    required this.tooltip,
    required this.onButtonPressed,
    // ignore: unused_element
    super.key,
  }) : _controller = controller;

  final QuillController _controller;
  final Attribute attribute;
  final IconData iconData;
  final IconData toggledIconData;
  final VoidCallback? onButtonPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarToggleStyleButton(
      controller: _controller,
      attribute: attribute,
      options: QuillToolbarToggleStyleButtonOptions(
        iconData: iconData,
        controller: _controller,
        childBuilder: (options, extraOptions) {
          void sharedOnPressed() {
            extraOptions.onPressed?.call();
            onButtonPressed?.call(); // of this widget;
          }

          if (extraOptions.isToggled) {
            return IconButton.filled(
              tooltip: tooltip,
              onPressed: sharedOnPressed,
              icon: Icon(
                iconData,
              ),
            );
          }

          return IconButton(
            tooltip: tooltip,
            onPressed: sharedOnPressed,
            icon: Icon(
              iconData,
            ),
          );
        },
      ),
    );
  }
}

class _IndentTextButton extends StatelessWidget {
  const _IndentTextButton({
    required QuillController controller,
    required this.isIncrease,
    required this.onButtonPressed,
    required this.tooltip,
    // ignore: unused_element
    super.key,
  }) : _controller = controller;

  final QuillController _controller;
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
