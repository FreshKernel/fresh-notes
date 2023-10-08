import 'package:flutter/material.dart';
import 'w_app_dialog.dart';

@immutable
class OkDialogOptions {
  const OkDialogOptions({
    required this.title,
    required this.message,
    this.okLabel,
  });
  final String title;
  final String message;
  final String? okLabel;
}

class OkDialog extends StatelessWidget {
  const OkDialog({
    required this.options,
    super.key,
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
