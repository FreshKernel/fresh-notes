import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fresh_quill_extensions/fresh_quill_extensions.dart';

import '../../../core/log/logger.dart';
import '../../../data/core/cloud/database/sync_options.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/s_universal_notes.dart';
import '../../../logic/native/image/s_image_picker.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/utils/platform_checker.dart';
import '../../components/note/editor_toolbar/w_note_editor_toolbar.dart';
import '../../components/note/editor_toolbar/w_select_image_source.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import '../../utils/extensions/build_context_extensions.dart';

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
  late final QuillController _controller;
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  var _isReadOnly = false;
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
      _controller = QuillController(
        document: Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
      // _isReadOnly = true; // TODO: Later change this to better way

      // Default option is false
      _isSyncWithCloud = _note?.syncOptions.isSyncWithCloud ?? false;
      return;
    }
    _controller = QuillController.basic();
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
      floatingActionButton: widget.args.isForceReadOnly
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
              child: Icon(
                _isReadOnly ? Icons.lock_rounded : Icons.edit,
              ),
            ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: QuillProvider(
                  configurations: QuillConfigurations(
                    controller: _controller,
                    // toolbarConfigurations: const QuillToolbarConfigurations(
                    //   // buttonOptions: QuillToolbarButtonOptions(
                    //   //     // fontFamily: QuillToolbarFontFamilyButtonOptions(),
                    //   //     ),
                    // ),
                  ),
                  child: Column(
                    children: [
                      if (!_isReadOnly)
                        QuillToolbar(
                          configurations: QuillToolbarConfigurations(
                            showAlignmentButtons: true,
                            embedButtons: [
                              ...FlutterQuillEmbeds.toolbarButtons(
                                imageButtonOptions:
                                    QuillToolbarImageButtonOptions(
                                  mediaPickSettingSelector: (context) async {
                                    final mediaPickSetting =
                                        await showModalBottomSheet<
                                            MediaPickSetting>(
                                      showDragHandle: true,
                                      context: context,
                                      constraints:
                                          const BoxConstraints(maxWidth: 640),
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
                                  linkRegExp: RegExp(
                                    r'https://.*?\.(?:png|jpe?g|gif|bmp|webp|tiff?)',
                                    caseSensitive: false,
                                  ),
                                  filePickImpl: (context) async {
                                    final imagePath =
                                        await ImagePickerService.getInstance()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                    return imagePath?.path;
                                  },
                                  webImagePickImpl:
                                      (onImagePickCallback) async {
                                    final imagePath =
                                        await ImagePickerService.getInstance()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                    return imagePath?.path;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      Scrollbar(
                        child: SingleChildScrollView(
                          child: QuillEditor(
                            configurations: QuillEditorConfigurations(
                              readOnly: _isReadOnly,
                              placeholder: 'Start your notes',
                              padding: const EdgeInsets.all(16),
                              minHeight: 1000,
                              embedBuilders: _embedBuilder,
                              autoFocus: false,
                              expands: false,
                              scrollable: true,
                              unknownEmbedBuilder:
                                  QuillEditorUnknownEmbedBuilder(),
                            ),
                            focusNode: _editorFocusNode,
                            scrollController: _editorScrollController,
                          ),
                        ),
                      ),
                    ],
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

  Iterable<EmbedBuilder> get _embedBuilder {
    if (PlatformChecker.isWeb()) {
      return FlutterQuillEmbeds.editorsWebBuilders();
    }
    return [
      ...FlutterQuillEmbeds.editorBuilders(
        imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
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
      ),
    ];
  }
}
