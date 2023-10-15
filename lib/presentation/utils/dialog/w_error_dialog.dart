import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';
import 'w_app_dialog.dart';
import 'w_dialog_action.dart';

@immutable
final class DeveloperErrorDialog {
  const DeveloperErrorDialog({
    required this.exception,
    this.stackTrace,
  });

  final Exception exception;
  final StackTrace? stackTrace;
}

@immutable
class ErrorDialogOptions {
  const ErrorDialogOptions({
    required this.message,
    required this.developerError,
    this.title,
  });
  final String? title;
  final String message;
  final DeveloperErrorDialog? developerError;
}

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({
    required this.options,
    super.key,
  });

  final ErrorDialogOptions options;

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  DeveloperErrorDialog? get _devError => widget.options.developerError;
  bool get _isDevError => _devError != null;

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.options.title ?? context.loc.app_name),
      content: Text(widget.options.message),
      actions: [
        if (_isDevError)
          DialogAction(
            onPressed: _isLoading
                ? null
                : () async {
                    final navigator = context.navigator;
                    final messenger = context.messenger;
                    try {
                      setState(() => _isLoading = true);
                      await FirebaseCrashlytics.instance.recordError(
                        _devError?.exception,
                        _devError?.stackTrace,
                      );
                      navigator.pop();
                      messenger.showMessage(
                        'The report has been sent!',
                      );
                    } catch (e) {
                      setState(() => _isLoading = false);
                      messenger.showMessage(
                        'Failed to sent the report.',
                      );
                    }
                  },
            options: const DialogActionOptions(
              cupertinoDialogActionOptions: CupertinoDialogActionOptions(
                isDefaultAction: true,
              ),
            ),
            child: Text(context.loc.report),
          ),
        DialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.ok),
        ),
      ],
    );
  }
}

Future<void> showErrorDialog({
  required BuildContext context,
  required ErrorDialogOptions options,
  DialogOptions? dialogOptions,
}) async {
  await showAppDialog(
    context: context,
    builder: (context) => ErrorDialog(options: options),
    options: dialogOptions,
  );
}
