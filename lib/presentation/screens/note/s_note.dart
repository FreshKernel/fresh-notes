import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_quill_extensions/utils/quill_image_utils.dart';

import '../../../core/log/logger.dart';
import '../../../data/constants/urls_constants.dart';
import '../../../data/core/shared/data_utils.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/models/m_note_inputs.dart';
import '../../../logic/auth/auth_service.dart';
import '../../../logic/native/share/s_app_share.dart';
import '../../../logic/note/cubit/note_cubit.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../components/note/editor/w_editor.dart';
import '../../components/note/toolbar/w_note_toolbar.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import 'w_share_dialog.dart';

class NoteScreenArgs {
  const NoteScreenArgs({
    this.isDeepLink = false,
    this.note,
  });

  final UniversalNote? note;
  final bool isDeepLink;
}

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    this.args = const NoteScreenArgs(),
  });

  static const routeName = '/note';

  final NoteScreenArgs args;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final QuillController _controller;

  var _isReadOnly = false;
  var _isPrivate = true;
  var _isSyncWithCloud = false;
  var _isLoading = false;
  late final TextEditingController _titleController;

  UniversalNote? get _note => widget.args.note;

  bool get _isEditing => _note != null;
  late final NoteCubit _noteBloc;

  bool get isNoteOwner =>
      widget.args.note?.userId == AuthService.getInstance().currentUser?.id;

  @override
  void initState() {
    super.initState();
    _setupNote();
    _noteBloc = context.read<NoteCubit>();
    if (!AuthService.getInstance().isAuthenticated) {
      _isSyncWithCloud = false;
    }
  }

  void _setupNote() {
    if (widget.args.isDeepLink) {
      _isReadOnly = true;
    }
    final noteToEdit = _note;

    // For updating note
    if (noteToEdit != null) {
      _titleController = TextEditingController(
        text: noteToEdit.title,
      );
      _controller = QuillController(
        document: Document.fromJson(jsonDecode(noteToEdit.text)),
        selection: const TextSelection.collapsed(offset: 0),
      );

      // Default option is false
      _isSyncWithCloud = noteToEdit.isSyncWithCloud;
      return;
    }

    // For creating a note
    _isSyncWithCloud =
        context.read<SettingsCubit>().state.syncWithCloudDefaultValue;
    _titleController = TextEditingController();
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    // TODO: feat: Add disable auto save option in the settings.
    _saveNote().then((value) => _controller.dispose());
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (widget.args.isDeepLink || _isLoading) {
      return;
    }
    final document = _controller.document;
    final isDocumentContentEmpty = document.toPlainText().trim().isEmpty;

    // if document empty
    if (isDocumentContentEmpty && _titleController.text.trim().isEmpty) {
      if (_isEditing) {
        await _noteBloc
            .deleteNote(_note?.noteId ?? (throw ArgumentError.notNull()));
      }
      return;
    }

    final newNoteText = jsonEncode(document.toDelta().toJson());

    // If nothings changed then ignore
    if (_isEditing &&
        newNoteText == _note?.text &&
        _titleController.text == _note?.title &&
        _isPrivate == _note?.isPrivate &&
        _isSyncWithCloud == _note?.isSyncWithCloud) {
      return;
    }
    try {
      _isLoading = true;
      final userId = AuthService.getInstance().currentUser?.id;
      final noteText = jsonEncode(document.toDelta().toJson());
      if (_isEditing) {
        await _noteBloc.updateNote(
          UpdateNoteInput(
            noteId: _note?.noteId ??
                (throw ArgumentError(
                    'The id is required for updating the note')),
            title: _titleController.text,
            text: noteText,
            isSyncWithCloud: _isSyncWithCloud,
            isPrivate: _isPrivate,
            isTrash: false,
            userId: userId,
          ),
        );
      } else {
        await _noteBloc.createNote(
          CreateNoteInput(
            noteId: generateRandomItemId(),
            title: _titleController.text,
            text: noteText,
            isSyncWithCloud: _isSyncWithCloud,
            isPrivate: _isPrivate,
            userId: userId,
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: () {
                AppLogger.log(
                  jsonEncode(
                    _controller.document.toDelta().toJson(),
                  ),
                );
                AppLogger.log(
                  QuillImageUtilities(document: _controller.document)
                      .getImagesPathsFromDocument(onlyLocalImages: false),
                );
              },
              icon: const Icon(Icons.print),
            ),
          if (_isEditing)
            IconButton(
              tooltip: context.loc.share,
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
                if (_isPrivate || !_isEditing) {
                  await AppShareService.getInstance().shareText(plainText);
                  return;
                }
                final shareOption = await showModalBottomSheet<ShareOption>(
                  showDragHandle: true,
                  context: context,
                  constraints: const BoxConstraints(maxWidth: 640),
                  builder: (context) => const NoteShareDialog(),
                );
                if (shareOption == null) {
                  return;
                }
                switch (shareOption) {
                  case ShareOption.link:
                    await AppShareService.getInstance().shareText(
                      '${UrlConstants.webUrl}/note/${_note?.noteId}',
                    );
                    break;
                  case ShareOption.text:
                    await AppShareService.getInstance().shareText(plainText);
                    break;
                }
              },
              icon: const Icon(Icons.share),
            ),
          if (AuthService.getInstance().isAuthenticated ||
              (_isEditing && isNoteOwner)) ...[
            IconButton(
              tooltip: context.loc.syncWithCloud,
              onPressed: () =>
                  setState(() => _isSyncWithCloud = !_isSyncWithCloud),
              icon: Icon(_isSyncWithCloud ? Icons.cloud : Icons.folder),
            ),
            if (_isSyncWithCloud)
              IconButton(
                tooltip: context.loc.private,
                onPressed: () => setState(() => _isPrivate = !_isPrivate),
                icon: Icon(_isPrivate ? Icons.lock : Icons.public),
              ),
          ]
        ],
      ),
      floatingActionButton: !isNoteOwner
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        readOnly: _isReadOnly,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter the title for this note',
                          border: InputBorder.none,
                        ),
                        controller: _titleController,
                      ),
                    ),
                    NoteEditor(
                      onRequestingSaveNote: _saveNote,
                      configurations: QuillEditorConfigurations(
                        readOnly: _isReadOnly,
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          extraConfigurations: {
                            QuillSharedExtensionsConfigurations.key:
                                QuillSharedExtensionsConfigurations(
                              assetsPrefix: 'assets', // Defaults to assets
                            ),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!_isReadOnly) NoteToolbar(controller: _controller),
          ],
        ),
      ),
    );
  }
}
