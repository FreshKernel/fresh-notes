import 'package:flutter/material.dart';

import 'w_app_dialog.dart';

@immutable
class OkDialogOptions {
  final String title;
  final String message;
  final String? okLabel;

  const OkDialogOptions({
    required this.title,
    required this.message,
    this.okLabel,
  });
}

class OkDialog extends StatelessWidget {
  const OkDialog({
    super.key,
    required this.options,
  });

  final OkDialogOptions options;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(options.okLabel ?? 'Ok'),
        ),
      ],
      title: Text(options.title),
      content: Text(options.message),
    );
  }
}

Future<void> showOkDialog({
  required BuildContext context,
  required OkDialogOptions options,
  DialogOptions? dialogOptions,
}) async {
  await showAppDialog(
    context: context,
    builder: (context) => OkDialog(options: options),
    options: dialogOptions,
  );
}
