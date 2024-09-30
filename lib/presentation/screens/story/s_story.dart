import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../../gen/assets.gen.dart';
import '../../l10n/extensions/localizations.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  static const routeName = '/story';

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      configurations: const QuillControllerConfigurations(),
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.document = Document.fromJson(
      [
        {'insert': '\n${context.loc.appDevelopmentAdventuresMessage}'},
        {
          'insert': '\n',
          'attributes': {'header': 1}
        },
        {'insert': '\n${context.loc.appDevelopmentInterestMessage}\n'},
        {
          'insert': {
            'image': Assets.images.macosNotesCrash.path,
          },
        },
        {
          'insert': '${context.loc.appDevelopmentAppleMacOsIssueMessage}\n',
        }
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.storyDesc),
      ),
      body: SafeArea(
        child: QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            padding: const EdgeInsets.all(16),
            controller: _controller,
            embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders(),
          ),
        ),
      ),
    );
  }
}
