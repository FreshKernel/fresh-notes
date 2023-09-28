import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:my_notes/models/note/m_note.dart';
import 'package:my_notes/utils/bool.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  bool get isEditing => widget.note != null;

  void _setupController() {
    if (isEditing) {
      final json = jsonDecode(widget.note!.text);
      _controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
      return;
    }
    _controller = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final navigator = Navigator.of(context);
    final document = _controller.document;

    await NotesDataService.getInstance().insertOneOrReplace(
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
        title: const Text('Save note'),
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            quill.QuillToolbar.basic(
              controller: _controller,
              embedButtons: FlutterQuillEmbeds.buttons(
                onImagePickCallback: (file) async {
                  // ImagePicker().pickImage(source: ImageSource.gallery);
                  return file.path;
                },
                showCameraButton: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 1000,
                  child: quill.QuillEditor(
                    controller: _controller,
                    readOnly: false,
                    autoFocus: false,
                    expands: false,
                    scrollable: true,
                    focusNode: _editorFocusNode,
                    scrollController: _editorScrollController,
                    padding: const EdgeInsets.all(16),
                    placeholder: 'Start your notes',
                    // onImagePaste: (imageBytes) async {
                    //   return 'https://www.gstatic.com/devrel-devsite/prod/va881901acfa784a302a2fcaebeaf9ea1e7654afe884686768d3a16b36e928e9f/android/images/rebrand/lockup.svg';
                    // },
                    embedBuilders: [
                      ...FlutterQuillEmbeds.builders(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
