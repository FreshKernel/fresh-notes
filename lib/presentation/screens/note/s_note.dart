import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:screenshot/screenshot.dart'
    show ScreenshotController, Screenshot;

import '../../../data/core/shared/data_utils.dart';
import '../../../data/notes/universal/models/m_note.dart';
import '../../../data/notes/universal/models/m_note_inputs.dart';
import '../../../logic/auth/auth_service.dart';
import '../../../logic/note/cubit/note_cubit.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../components/note/editor/w_editor.dart';
import '../../components/note/toolbar/w_note_toolbar.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/extensions/build_context_ext.dart';
import 'w_note_toolbar_actions.dart';

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
  var _toolbarState = const NoteScreenToolbarState(
    isFavorite: false,
    isSyncWithCloud: false,
    isPrivate: true,
  );
  var _isLoading = false;
  late final TextEditingController _titleController;
  final _screenshotController = ScreenshotController();

  UniversalNote? get _note => widget.args.note;

  bool get _isEditing => _note != null;
  late final NoteCubit _noteBloc;
  late final SettingsCubit _settingsCubit;

  bool get _isNoteOwner =>
      _note?.userId == AuthService.getInstance().currentUser?.id;

  late final FocusNode _editorFocusNode;

  @override
  void initState() {
    super.initState();
    _noteBloc = context.read<NoteCubit>();
    _settingsCubit = context.read<SettingsCubit>();
    _setupNote();
    _editorFocusNode = FocusNode();
    if (!AuthService.getInstance().isAuthenticated) {
      _toolbarState = _toolbarState.copyWith(isSyncWithCloud: false);
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
      _toolbarState = _toolbarState.copyWith(
        isSyncWithCloud: noteToEdit.isSyncWithCloud,
        isPrivate: noteToEdit.isPrivate,
        isFavorite: noteToEdit.isFavorite,
      );
      return;
    }

    // For creating a note
    _toolbarState = _toolbarState.copyWith(
      isSyncWithCloud: _settingsCubit.state.syncWithCloudDefaultValue,
    );
    _titleController = TextEditingController();
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    if (_settingsCubit.state.autoSaveNote) {
      _saveNote().then((value) => _controller.dispose());
    }
    _editorFocusNode.dispose();
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
        _toolbarState.isPrivate == _note?.isPrivate &&
        _toolbarState.isSyncWithCloud == _note?.isSyncWithCloud &&
        _toolbarState.isFavorite == _note?.isFavorite) {
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
            isSyncWithCloud: _toolbarState.isSyncWithCloud,
            isPrivate: _toolbarState.isPrivate,
            isTrash: false,
            isFavorite: _toolbarState.isFavorite,
            userId: userId,
          ),
        );
      } else {
        await _noteBloc.createNote(
          CreateNoteInput(
            noteId: generateRandomItemId(),
            title: _titleController.text,
            text: noteText,
            isSyncWithCloud: _toolbarState.isSyncWithCloud,
            isPrivate: _toolbarState.isPrivate,
            isFavorite: _toolbarState.isFavorite,
            userId: userId,
          ),
        );
      }
    } finally {
      _isLoading = false;
    }
  }

  Widget get floatingActionButton {
    if (widget.args.isDeepLink) {
      if (!_isNoteOwner) {
        return const SizedBox.shrink();
      }
    }
    return Padding(
      padding: !_isReadOnly
          ? const EdgeInsets.only(
              bottom: 40,
            )
          : const EdgeInsets.only(),
      child: FloatingActionButton(
        onPressed: () => setState(() => _isReadOnly = !_isReadOnly),
        child: Icon(
          _isReadOnly ? Icons.lock_rounded : Icons.edit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: noteScreenActions(
          onRequestSaveNote: () async {
            final messenger = context.messenger;
            final localizations = context.loc;
            final isDocumentContentEmpty =
                _controller.document.toPlainText().trim().isEmpty;
            if (isDocumentContentEmpty) {
              await messenger.showMessage(localizations.cannotSaveEmptyNote);
              return;
            }
            try {
              await _saveNote();
              final messages = [
                localizations.noteHasBeenSavedMessage,
                localizations.noteHasBeenSavedMessage2,
                localizations.noteHasBeenSavedMessage3,
              ];
              await messenger.showMessage(
                messages[math.Random().nextInt(messages.length - 1)],
              );
            } catch (e) {
              await messenger.showMessage(localizations.unknownErrorWithMessage(
                e.toString(),
              ));
            }
          },
          toolbarState: _toolbarState,
          onUpdateToolbarState: (noteScreenToolbarState) {
            setState(() {
              _toolbarState = noteScreenToolbarState;
            });
          },
          screenshotController: _screenshotController,
          context: context,
          controller: _controller,
          note: _note,
        ),
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          children: [
            if (kDebugMode)
              QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  showAlignmentButtons: true,
                  embedButtons: [
                    ...FlutterQuillEmbeds.toolbarButtons(
                      imageButtonOptions: QuillToolbarImageButtonOptions(
                        imageButtonConfigurations:
                            const QuillToolbarImageConfigurations(),
                        linkRegExp: RegExp(
                          r'https://.*?\.(?:png|jpe?g|gif|bmp|webp|tiff?)',
                          caseSensitive: false,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: _editorFocusNode.requestFocus,
                        onSubmitted: (value) => _editorFocusNode.requestFocus(),
                        readOnly: _isReadOnly,
                        decoration: InputDecoration(
                          labelText: context.loc.title,
                          hintText: context.loc.enterTitleDesc,
                          border: InputBorder.none,
                        ),
                        controller: _titleController,
                      ),
                    ),
                    Screenshot(
                      controller: _screenshotController,
                      child: NoteEditor(
                        focusNode: _editorFocusNode,
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: !_isReadOnly
          ? SizedBox(
              height: 50,
              child: NoteToolbar(controller: _controller),
            )
          : const SizedBox.shrink(),
    );
  }
}
