import 'package:flutter/material.dart';
import 'w_app_dialog.dart';

class YesOrCancelDialogOptions {

  const YesOrCancelDialogOptions({
    required this.title,
    required this.message,
    this.yesLabel,
    this.cancelLabel,
  });
  final String title;
  final String message;
  final String? yesLabel;
  final String? cancelLabel;
}

class YesOrCancelDialog extends StatelessWidget {
  const YesOrCancelDialog({
    required this.options, super.key,
  });

  final YesOrCancelDialogOptions options;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    return AlertDialog.adaptive(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(options.cancelLabel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: materialTheme.colorScheme.error,
          ),
          child: Text(options.yesLabel ?? 'Yes'),
        ),
      ],
      title: Text(options.title),
      content: Text(options.message),
    );
  }
}

Future<bool> showYesCancelDialog({
  required BuildContext context,
  required YesOrCancelDialogOptions options,
  DialogOptions? dialogOptions,
}) async {
  final result = await showAppDialog<bool>(
        context: context,
        builder: (context) => YesOrCancelDialog(options: options),
        options: dialogOptions,
      ) ??
      false;
  return result;
}
