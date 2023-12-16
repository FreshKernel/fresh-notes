import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:fresh_base_package/fresh_base_package.dart'
    show PlatformChecker;

import '../../../../core/log/logger.dart';
import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../../logic/utils/extensions/string.dart';
import '../../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../base/w_app_scroll_bar.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({
    required this.isReadOnly,
    required this.onRequestingSaveNote,
    required this.configurations,
    super.key,
  });

  final bool isReadOnly;
  final VoidCallback onRequestingSaveNote;
  final QuillEditorConfigurations configurations;

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
    if (PlatformChecker.defaultLogic().isWeb()) {
      return FlutterQuillEmbeds.editorWebBuilders();
    }
    return [
      ...FlutterQuillEmbeds.editorBuilders(
        imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
          imageProviderBuilder: (context, imageUrl) {
            if (isHttpBasedUrl(imageUrl)) {
              return CachedNetworkImageProvider(imageUrl);
            }
            return FileImage(File(imageUrl));
          },
          onImageRemovedCallback: (imageUrl) async {
            if (imageUrl.isHttpBasedUrl()) {
              await context.read<NoteCubit>().deleteNoteCloudImage(imageUrl);
              return;
            } 

            if (PlatformChecker.defaultLogic().isWeb() ||
                PlatformChecker.nativePlatform().isDesktop()) {
              return;
            }
            // Run this logic only for mobile
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
          configurations: widget.configurations.copyWith(
            readOnly: widget.isReadOnly,
            placeholder: 'Start your notes',
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minHeight: 1000,
            embedBuilders: _embedBuilder,
            autoFocus: false,
            expands: false,
            scrollable: true,
            unknownEmbedBuilder: QuillEditorUnknownEmbedBuilder(),
            keyboardAppearance: Theme.of(context).brightness, // for iOS
          ),
          focusNode: _editorFocusNode,
          scrollController: _editorScrollController,
        ),
      ),
    );
  }
}
