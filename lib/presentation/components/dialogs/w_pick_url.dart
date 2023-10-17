import 'package:flutter/material.dart';

import '../../../logic/utils/validators/global.dart';
import '../../utils/dialog/w_dialog_action.dart';
import '../../utils/extensions/build_context_extensions.dart';

enum PickUrlType {
  image,
  video,
}

class PickUrlDialog extends StatefulWidget {
  const PickUrlDialog({
    required this.type,
    super.key,
  });

  final PickUrlType type;

  @override
  State<PickUrlDialog> createState() => _PickUrlDialogState();
}

class _PickUrlDialogState extends State<PickUrlDialog> {
  final _textController = TextEditingController();
  var _isValid = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    Navigator.of(context).pop(_textController.text);
  }

  (String title, String hintText, String labelText) get _data {
    switch (widget.type) {
      case PickUrlType.image:
        return ('Pick image', 'A valid image url', 'Image url');
      case PickUrlType.video:
        throw UnimplementedError('Vide is not supported');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (title, hintText, labelText) = _data;
    return AlertDialog.adaptive(
      title: Text(title),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
        ),
        onChanged: (value) {
          final imageUrl = _textController.text;
          final isValidImageUrl = switch (widget.type) {
            PickUrlType.image => GlobalValidator.isValidImageUrl(imageUrl),
            PickUrlType.video =>
              throw UnimplementedError('Vide is not supported'),
          };
          if (!isValidImageUrl) {
            if (_isValid) {
              setState(() => _isValid = false);
            }
            return;
          }
          setState(() => _isValid = true);
        },
      ),
      actions: [
        AppDialogAction(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(context.loc.cancel),
        ),
        AppDialogAction(
          onPressed: _isValid ? _onSubmit : null,
          child: Text(context.loc.ok),
        ),
      ],
    );
  }
}
