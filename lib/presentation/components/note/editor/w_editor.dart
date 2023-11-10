import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../../../core/log/logger.dart';
import '../../../../logic/utils/platform_checker.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../others/app_scroll_bar.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({
    required this.isReadOnly,
    required this.onRequestingSaveNote,
    super.key,
  });

  final bool isReadOnly;
  final VoidCallback onRequestingSaveNote;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  Iterable<EmbedBuilder> get _embedBuilder {
    if (PlatformChecker.isWeb()) {
      return FlutterQuillEmbeds.editorsWebBuilders();
    }
    return [
      ...FlutterQuillEmbeds.editorBuilders(
        imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
          forceUseMobileOptionMenuForImageClick: false,
          imageProviderBuilder: (imageUrl) {
            if (isHttpBasedUrl(imageUrl)) {
              return CachedNetworkImageProvider(imageUrl);
            }
            return FileImage(File(imageUrl));
          },
          onImageRemovedCallback: (imageUrl) async {
            if (PlatformChecker.isMobile()) {
              return;
            }
            final imageFile = File(imageUrl);
            if (await imageFile.exists()) {
              await imageFile.delete();
              AppLogger.log(
                'Image exists and we have removed it from the local storage and not just from the editor.',
              );
              widget.onRequestingSaveNote();
              return;
            }
            AppLogger.log('Image does not exists');
          },
          shouldRemoveImageCallback: (imageFile) async {
            final remove = await showYesCancelDialog(
              context: context,
              options: const YesOrCancelDialogOptions(
                title: 'Deleting an image',
                message:
                    'Are you sure you want to delete this image from the editor?',
              ),
            );
            return remove;
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollBar(
      child: SingleChildScrollView(
        child: QuillEditor(
          configurations: QuillEditorConfigurations(
            readOnly: widget.isReadOnly,
            placeholder: 'Start your notes',
            padding: const EdgeInsets.all(16),
            minHeight: 1000,
            embedBuilders: _embedBuilder,
            autoFocus: false,
            expands: false,
            scrollable: true,
            unknownEmbedBuilder: QuillEditorUnknownEmbedBuilder(),
          ),
          focusNode: _editorFocusNode,
          scrollController: _editorScrollController,
        ),
      ),
    );
  }
}
