import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/extensions/localizations.dart';
import 'w_app_dialog.dart';
import 'w_dialog_action.dart';

class OkOrCancelDialogOptions {
  const OkOrCancelDialogOptions({
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

class OkOrCancelDialog extends StatelessWidget {
  const OkOrCancelDialog({
    required this.options,
    super.key,
  });

  final OkOrCancelDialogOptions options;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    return AlertDialog.adaptive(
      actions: [
        AppDialogAction(
          onPressed: () => context.pop(false),
          child: Text(options.cancelLabel ?? context.loc.cancel),
        ),
        AppDialogAction(
          onPressed: () => context.pop(true),
          options: DialogActionOptions(
            materialDialogActionOptions: MaterialDialogActionOptions(
              textStyle: TextButton.styleFrom(
                foregroundColor: materialTheme.colorScheme.error,
              ),
            ),
            cupertinoDialogActionOptions: const CupertinoDialogActionOptions(
              isDefaultAction: true,
            ),
          ),
          child: Text(options.yesLabel ?? context.loc.ok),
        ),
      ],
      title: Text(options.title),
      content: Text(options.message),
    );
  }
}

Future<bool> showOkCancelDialog({
  required BuildContext context,
  required OkOrCancelDialogOptions options,
  DialogOptions? dialogOptions,
}) async {
  final result = await showAppDialog<bool>(
        context: context,
        builder: (context) => OkOrCancelDialog(options: options),
        options: dialogOptions,
      ) ??
      false;
  return result;
}
