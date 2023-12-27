import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;

class NoteToolbarFullScreenButton extends StatefulWidget {
  const NoteToolbarFullScreenButton({super.key});

  @override
  State<NoteToolbarFullScreenButton> createState() =>
      _NoteToolbarFullScreenButtonState();
}

class _NoteToolbarFullScreenButtonState
    extends State<NoteToolbarFullScreenButton> {
  var _isFullScreen = false;

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return IconButton.filled(
        onPressed: () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

          setState(() {
            _isFullScreen = false;
          });
        },
        icon: const Icon(Icons.fullscreen),
      );
    }
    return IconButton(
      onPressed: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

        setState(() {
          _isFullScreen = true;
        });
      },
      icon: const Icon(Icons.fullscreen_exit),
    );
  }
}
