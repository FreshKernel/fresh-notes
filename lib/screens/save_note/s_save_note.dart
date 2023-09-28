import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:my_notes/core/log/logger.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/services/native/image/s_image_picker.dart';

import '../../services/data/notes/s_notes_data.dart';

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

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  bool get _isEditing => widget.note != null;

  void _setupController() {
    if (_isEditing) {
      final json = jsonDecode(widget.note!.text);
      _controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
      _isReadOnly = true;
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

  Future<void> _saveNote() async {
    final navigator = Navigator.of(context);
    final document = _controller.document;

    await NotesDataService.getInstance().insertOrReplaceOne(
      document,
      currentId: widget.note?.id,
      isSyncedWithCloud: true,
    );

    navigator.pop();
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
            tooltip: 'Save note',
            onPressed: _saveNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _isReadOnly = !_isReadOnly);
        },
        child: Icon(
          _isReadOnly ? Icons.lock_rounded : Icons.edit,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            quill.QuillToolbar.basic(
              controller: _controller,
              embedButtons: FlutterQuillEmbeds.buttons(
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
                  embedBuilders: [
                    ...FlutterQuillEmbeds.builders(),
                    if (kIsWeb) ...FlutterQuillEmbeds.webBuilders(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
