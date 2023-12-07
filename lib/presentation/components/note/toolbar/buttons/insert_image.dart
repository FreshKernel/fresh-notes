import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../../logic/native/image/s_image_picker.dart';
import '../../../../utils/extensions/build_context_ext.dart';
import '../../../dialogs/w_pick_url.dart';
import '../w_note_toolbar.dart';
import '../w_select_image_source.dart';

class NoteToolbarImageButton extends StatelessWidget {
  const NoteToolbarImageButton({
    required quill.QuillController controller,
    super.key,
  }) : _controller = controller;

  final quill.QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Insert a image',
      onPressed: () async {
        final dialogMessenger = context.dialogMessenger;
        final imageSource = await showModalBottomSheet<InsertImageSource>(
          showDragHandle: true,
          context: context,
          constraints: const BoxConstraints(maxWidth: 640),
          builder: (context) => const SelectImageSourceDialog(),
        );
        if (imageSource == null) {
          return;
        }
        final imagePickerService = ImagePickerService.getInstance();
        final imagePath = switch (imageSource) {
          InsertImageSource.gallery => (await imagePickerService.pickImage(
              source: ImageSource.gallery,
            ))
                ?.path,
          InsertImageSource.camera => (await imagePickerService.pickImage(
              source: ImageSource.camera,
            ))
                ?.path,
          InsertImageSource.link => await dialogMessenger.showDialog<String?>(
              builder: (context) => const PickUrlDialog(
                type: PickUrlType.image,
              ),
            ),
        };
        if (imagePath == null) {
          return;
        }
        final index = _controller.selection.baseOffset;
        final length = _controller.selection.extentOffset - index;
        _controller.replaceText(
          index,
          length,
          quill.BlockEmbed.image(imagePath),
          null,
        );
      },
      icon: const Icon(Icons.image),
    );
  }
}
