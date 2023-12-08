import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../../core/log/logger.dart';
import '../../../data/core/cloud/database/sync_options.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/s_universal_notes.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../components/note/editor/w_editor.dart';
import '../../components/note/toolbar/w_note_toolbar.dart';
import '../../utils/extensions/build_context_ext.dart';

class SaveNoteScreenArgs {
  const SaveNoteScreenArgs({
    this.isDeepLink = false,
    this.note,
  });

  final UniversalNote? note;
  final bool isDeepLink;
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

  var _isReadOnly = false;
  var _isPrivate = true;
  var _isSyncWithCloud = false;

  UniversalNote? get _note => widget.args.note;

  bool get _isEditing => _note != null;
  var _isLoading = false;
  late final TextEditingController _titleController;

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
    if (widget.args.isDeepLink) {
      _isReadOnly = true;
    }
    final noteToEdit = _note;
    if (noteToEdit != null) {
      final json = jsonDecode(noteToEdit.text);
      _titleController = TextEditingController(
        text: noteToEdit.title,
      );
      _controller = QuillController(
        document: Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );

      // Default option is false
      _isSyncWithCloud = _note?.syncOptions.isSyncWithCloud ?? false;
      return;
    }
    _titleController = TextEditingController();
    _controller = QuillController.basic();
    _isSyncWithCloud =
        context.read<SettingsCubit>().state.syncWithCloudDefaultValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSaveNoteClick() async {
    final navigator = context.navigator;
    final messenger = context.messenger;
    final document = _controller.document;

    final isDocumentContentEmpty = document.toPlainText().trim().isEmpty;
    final notesDataService = UniversalNotesService.getInstance();

    if (isDocumentContentEmpty) {
      // Delete the note if the content is empty in edit mode
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
        title: _titleController.text,
        document: document,
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
        title: TextField(
          readOnly: _isReadOnly,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Enter the title for this note',
            border: InputBorder.none,
          ),
          controller: _titleController,
        ),
        actions: [
          if (kDebugMode)
          IconButton(
            onPressed: () {
              AppLogger.log(
                  jsonEncode(_controller.document.toDelta().toJson()));
            },
            icon: const Icon(Icons.print),
          ),
          if (!widget.args.isDeepLink)
            IconButton(
              tooltip: 'Sync with cloud',
              onPressed: () =>
                  setState(() => _isSyncWithCloud = !_isSyncWithCloud),
              icon: Icon(_isSyncWithCloud ? Icons.cloud : Icons.folder),
            ),
          if (!widget.args.isDeepLink)
            IconButton(
              tooltip: 'Private',
              onPressed: () => setState(() => _isPrivate = !_isPrivate),
              icon: Icon(_isPrivate ? Icons.lock : Icons.public),
            ),
          if (_isEditing)
            IconButton(
              tooltip: 'Share',
              onPressed: () async {
                final messenger = context.messenger;
                final plainText = _controller.document.toPlainText(
                  FlutterQuillEmbeds.defaultEditorBuilders(),
                  QuillEditorUnknownEmbedBuilder(),
                );
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
          if (!widget.args.isDeepLink)
            IconButton(
              tooltip: 'Save note',
              onPressed: _isLoading ? null : _onSaveNoteClick,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      floatingActionButton: widget.args.isDeepLink
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
                child: Column(
                  children: [
                    if (!_isReadOnly)
                      QuillToolbar.simple(
                        configurations: QuillSimpleToolbarConfigurations(
                          controller: _controller,
                          fontFamilyValues: const {
                            'Ubuntu': 'Ubuntu',
                          },
                          showAlignmentButtons: true,
                          embedButtons: [
                            ...FlutterQuillEmbeds.toolbarButtons(
                              imageButtonOptions:
                                  QuillToolbarImageButtonOptions(
                                imageButtonConfigurations:
                                    QuillToolbarImageConfigurations(
                                  onImageInsertedCallback: (image) async {
                                    AppLogger.log(
                                      'The path of the picked image is: $image',
                                    );
                                  },
                                ),
                                linkRegExp: RegExp(
                                  r'https://.*?\.(?:png|jpe?g|gif|bmp|webp|tiff?)',
                                  caseSensitive: false,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    NoteEditor(
                      isReadOnly: _isReadOnly,
                      onRequestingSaveNote: _saveNote,
                      configurations: QuillEditorConfigurations(
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          extraConfigurations: {
                            QuillSharedExtensionsConfigurations.key:
                                QuillSharedExtensionsConfigurations(
                              assetsPrefix: 'wqasd', // Defaults to assets
                            ),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NoteToolbar(controller: _controller),
          ],
        ),
      ),
    );
  }
}
