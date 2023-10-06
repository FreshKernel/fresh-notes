import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'
    as quill_extensions;

import '../../../core/log/logger.dart';
import '../../../models/note/m_note.dart';
import '../../../services/cloud/shared/sync_options.dart';
import '../../../services/data/notes/s_notes_data.dart';
import '../../../services/native/image/s_image_picker.dart';
import '../../../services/native/share/s_app_share.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import 'w_select_image_source_dialog.dart';

class SaveNoteScreen extends StatefulWidget {
  const SaveNoteScreen({super.key, this.note});

  static const routeName = '/save-note';

  final Note? note;

  @override
  State<SaveNoteScreen> createState() => _SaveNoteScreenState();
}

class _SaveNoteScreenState extends State<SaveNoteScreen> {
  late final quill.QuillController _controller;
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  var _isReadOnly = false;
  var _isPrivate = true;
  var _isSyncWithCloud = false;

  bool get _isEditing => widget.note != null;

  var _isLoading = false;

  SyncOptions get _getSyncOptions {
    return SyncOptions.getSyncOptions(
      isSyncWithCloud: _isSyncWithCloud,
      existingCloudNoteId: widget.note?.syncOptions.getCloudNoteId(),
    );
  }

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    if (_isEditing) {
      final json = jsonDecode(widget.note!.text);
      _controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
      // _isReadOnly = true; // TODO: Later change this to better way
      // Default option is false
      _isSyncWithCloud = widget.note?.syncOptions.isSyncWithCloud ?? false;
      return;
    }
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  Future<void> _onSaveNoteClick() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final document = _controller.document;

    final isDocumentContentEmpty = document.toPlainText().trim().isEmpty;
    final notesDataService = NotesDataService.getInstance();

    if (isDocumentContentEmpty) {
      messenger.clearSnackBars();

      // Delete the note if the contnet is empty in edit mode
      if (_isEditing) {
        await notesDataService.deleteOneById(widget.note!.id);
        messenger.showSnackBar(const SnackBar(
          content: Text('Note has been deleted.'),
        ));
        navigator.pop();
        return;
      }
      // User can't save empty note
      messenger.showSnackBar(const SnackBar(
        content: Text('The document is empty.'),
      ));
      return;
    }
    try {
      await _saveNote();
    } catch (e, stacktrace) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
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
    final notesDataService = NotesDataService.getInstance();
    try {
      setState(() => _isLoading = true);
      await notesDataService.insertOrReplaceOne(
        document,
        currentId: widget.note?.id,
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
              final messenger = ScaffoldMessenger.of(context);
              final plainText = _controller.document.toPlainText(_embedBuilder);
              if (plainText.trim().isEmpty) {
                messenger.showSnackBar(const SnackBar(
                    content: Text(
                  'Please enter a text before sharing it',
                )));
                return;
              }
              await AppShareService.getInstance().shareText(plainText);
            },
            icon: const Icon(Icons.link),
          ),
          IconButton(
            tooltip: 'Save note',
            onPressed: _isLoading ? null : _onSaveNoteClick,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
        child: Icon(
          _isReadOnly ? Icons.lock_rounded : Icons.edit,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isReadOnly)
              quill.QuillToolbar.basic(
                controller: _controller,
                embedButtons: quill_extensions.FlutterQuillEmbeds.buttons(
                  mediaPickSettingSelector: (context) async {
                    final mediaPickSetting = await showModalBottomSheet<
                        quill_extensions.MediaPickSetting>(
                      showDragHandle: true,
                      context: context,
                      constraints: const BoxConstraints(maxWidth: 640),
                      builder: (context) => const SelectImageSourceDialog(),
                    );
                    if (mediaPickSetting == null) {
                      return null;
                    }
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
                    final imagePath = await ImagePickerService.getInstance()
                        .pickImage(source: ImageSource.gallery);
                    return imagePath?.path;
                  },
                  webImagePickImpl: (onImagePickCallback) async {
                    final imagePath = await ImagePickerService.getInstance()
                        .pickImage(source: ImageSource.gallery);
                    return imagePath?.path;
                  },
                ),
              ),
            Expanded(
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
            )
          ],
        ),
      ),
    );
  }

  Iterable<quill.EmbedBuilder> get _embedBuilder {
    if (kIsWeb) return quill_extensions.FlutterQuillEmbeds.webBuilders();
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
