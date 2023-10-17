import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'
    as quill_extensions;

import '../../../core/log/logger.dart';
import '../../../data/core/cloud/database/sync_options.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/s_universal_notes.dart';
import '../../../logic/native/image/s_image_picker.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/utils/platform_checker.dart';
import '../../components/note/editor_toolbar/w_note_editor_toolbar.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../utils/extensions/build_context_extensions.dart';
import '../../components/note/editor_toolbar/w_select_image_source.dart';

class SaveNoteScreenArgs {
  const SaveNoteScreenArgs({
    this.isForceReadOnly = false,
    this.note,
  });

  final UniversalNote? note;
  final bool isForceReadOnly;
}

class SaveNoteScreen extends StatefulWidget {
  const SaveNoteScreen({
    super.key,
    this.args = const SaveNoteScreenArgs(),
  });

  static const routeName = '/note';

  final SaveNoteScreenArgs args;

  @override
  State<SaveNoteScreen> createState() => _SaveNoteScreenState();
}

class _SaveNoteScreenState extends State<SaveNoteScreen> {
  late final quill.QuillController _controller;
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  final _isReadOnly = false;
  var _isPrivate = true;
  var _isSyncWithCloud = false;

  UniversalNote? get _note => widget.args.note;

  bool get _isEditing => _note != null;

  var _isLoading = false;

  SyncOptions get _getSyncOptions {
    return SyncOptions.getSyncOptions(
      isSyncWithCloud: _isSyncWithCloud,
      existingCloudNoteId: _note?.syncOptions.getCloudNoteId(),
    );
  }

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    if (_isEditing) {
      final json = jsonDecode(_note!.text);
      _controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
      // _isReadOnly = true; // TODO: Later change this to better way

      // Default option is false
      _isSyncWithCloud = _note?.syncOptions.isSyncWithCloud ?? false;
      return;
    }
    _controller = quill.QuillController.basic();
    _isSyncWithCloud =
        context.read<SettingsCubit>().state.syncWithCloudDefaultValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  Future<void> _onSaveNoteClick() async {
    final navigator = context.navigator;
    final messenger = context.messenger;
    final document = _controller.document;

    final isDocumentContentEmpty = document.toPlainText().trim().isEmpty;
    final notesDataService = UniversalNotesService.getInstance();

    if (isDocumentContentEmpty) {
      // Delete the note if the contnet is empty in edit mode
      if (_isEditing) {
        await notesDataService.deleteOneById(_note!.id);
        messenger.showMessage(
          'Note has been deleted.',
        );
        navigator.pop();
        return;
      }
      // User can't save empty note
      messenger.showMessage(
        'The document is empty.',
      );
      return;
    }
    try {
      await _saveNote();
    } catch (e, stacktrace) {
      messenger.showMessage('Error while save the note: ${e.toString()}');
      AppLogger.error(e.toString(), stackTrace: stacktrace);
    }

    navigator.pop();
  }

  Future<void> _saveNote() async {
    final document = _controller.document;
    final isDocumentContentEmpty = document.toPlainText().trim().isEmpty;
    if (isDocumentContentEmpty) {
      return;
    }
    final notesDataService = UniversalNotesService.getInstance();
    try {
      setState(() => _isLoading = true);
      await notesDataService.insertOrReplaceOne(
        document,
        currentId: _note?.id,
        syncOptions: _getSyncOptions,
        isPrivate: _isPrivate,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit note' : 'Add note',
        ),
        actions: [
          IconButton(
            tooltip: 'Sync with cloud',
            onPressed: () =>
                setState(() => _isSyncWithCloud = !_isSyncWithCloud),
            icon: Icon(_isSyncWithCloud ? Icons.cloud : Icons.folder),
          ),
          IconButton(
            tooltip: 'Private',
            onPressed: () => setState(() => _isPrivate = !_isPrivate),
            icon: Icon(_isPrivate ? Icons.lock : Icons.public),
          ),
          IconButton(
            tooltip: 'Share',
            onPressed: () async {
              final messenger = context.messenger;
              final plainText = _controller.document.toPlainText(_embedBuilder);
              if (plainText.trim().isEmpty) {
                messenger.showMessage(
                  'Please enter a text before sharing it',
                );
                return;
              }
              await AppShareService.getInstance().shareText(plainText);
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            tooltip: 'Save note',
            onPressed: _isLoading ? null : _onSaveNoteClick,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      // floatingActionButton: widget.args.isForceReadOnly
      //     ? const SizedBox.shrink()
      //     : FloatingActionButton(
      //         onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
      //         child: Icon(
      //           _isReadOnly ? Icons.lock_rounded : Icons.edit,
      //         ),
      //       ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isReadOnly)
              quill.QuillToolbar.basic(
                controller: _controller,
                showAlignmentButtons: true,
                iconTheme: const quill.QuillIconTheme(
                  borderRadius: 20,
                ),
                embedButtons: true
                    ? null
                    // ignore: dead_code
                    : quill_extensions.FlutterQuillEmbeds.buttons(
                        mediaPickSettingSelector: (context) async {
                          final mediaPickSetting = await showModalBottomSheet<
                              quill_extensions.MediaPickSetting>(
                            showDragHandle: true,
                            context: context,
                            constraints: const BoxConstraints(maxWidth: 640),
                            builder: (context) =>
                                const SelectImageSourceDialog(),
                          );
                          return mediaPickSetting;
                        },
                        onImagePickCallback: (file) async {
                          AppLogger.log(
                            'The path of the picked image is: ${file.path}',
                          );
                          return file.path;
                        },
                        imageLinkRegExp: RegExp(
                          r'https://.*?\.(?:png|jpe?g|gif|bmp|webp|tiff?)',
                          caseSensitive: false,
                        ),
                        filePickImpl: (context) async {
                          final imagePath =
                              await ImagePickerService.getInstance()
                                  .pickImage(source: ImageSource.gallery);
                          return imagePath?.path;
                        },
                        webImagePickImpl: (onImagePickCallback) async {
                          final imagePath =
                              await ImagePickerService.getInstance()
                                  .pickImage(source: ImageSource.gallery);
                          return imagePath?.path;
                        },
                        showFormulaButton: false,
                      ),
              ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: quill.QuillEditor(
                    controller: _controller,
                    readOnly: _isReadOnly,
                    autoFocus: false,
                    expands: false,
                    scrollable: true,
                    focusNode: _editorFocusNode,
                    scrollController: _editorScrollController,
                    padding: const EdgeInsets.all(16),
                    placeholder: 'Start your notes',
                    minHeight: 1000,
                    embedBuilders: _embedBuilder,
                  ),
                ),
              ),
            ),
            NoteEditorToolbar(controller: _controller),
          ],
        ),
      ),
    );
  }

  Iterable<quill.EmbedBuilder> get _embedBuilder {
    if (PlatformChecker.isWeb()) {
      return quill_extensions.FlutterQuillEmbeds.webBuilders();
    }
    return [
      ...quill_extensions.FlutterQuillEmbeds.builders(
        onImageRemovedCallback: (imageFile) async {
          if (await imageFile.exists()) {
            await imageFile.delete();
            AppLogger.log(
              'Image exists and we have removed it from the local storage and not just from the editor.',
            );
            _saveNote();
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
    ];
  }
}
