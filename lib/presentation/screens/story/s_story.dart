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
      document: Document.fromJson(
        [
          {'insert': '\nApp development adventures !'},
          {
            'insert': '\n',
            'attributes': {'header': 1}
          },
          {
            'insert':
                "\nWe are all interested in building mobile apps for iOS and Android, so we had to use macOS to write and build native iOS applications using Xcode, when using any operating system I usually take a lot of notes and I needed a notes app and I prefer it to not be a third party so I used Notes app on macOS but after updating to macOS 14.1 the notes app never working and it doesn't matter what I do I always getting crashes\n"
          },
          {
            'insert': {
              'image': Assets.images.macosNotesCrash.path,
            },
          },
          {
            'insert':
                "it's known to be limited on AppleOS and it's closed so there is not much I can do, so I created this little app usually I prefer my repositories to the public so I decided to also publish it even though that wasn't my plan\n",
          }
        ],
      ),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            readOnly: true,
            embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders(),
          ),
        ),
      ),
    );
  }
}
