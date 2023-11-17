import 'package:flutter/cupertino.dart' show CupertinoDialogAction;
import 'package:flutter/material.dart' show TextButton, ButtonStyle;
import 'package:flutter/widgets.dart';
import 'package:fresh_base_package/fresh_base_package.dart'
    show PlatformChecker;

@immutable
final class CupertinoDialogActionOptions {
  const CupertinoDialogActionOptions({
    this.isDefaultAction = false,
  });

  final bool isDefaultAction;
}

@immutable
final class MaterialDialogActionOptions {
  const MaterialDialogActionOptions({
    this.textStyle,
  });

  final ButtonStyle? textStyle;
}

@immutable
class DialogActionOptions {
  const DialogActionOptions({
    this.cupertinoDialogActionOptions,
    this.materialDialogActionOptions,
  });

  final CupertinoDialogActionOptions? cupertinoDialogActionOptions;
  final MaterialDialogActionOptions? materialDialogActionOptions;
}

class AppDialogAction extends StatelessWidget {
  const AppDialogAction({
    required this.child,
    required this.onPressed,
    super.key,
    this.options,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final DialogActionOptions? options;

  @override
  Widget build(BuildContext context) {
    if (PlatformChecker.defaultLogic().isAppleSystem()) {
      return CupertinoDialogAction(
        onPressed: onPressed,
        isDefaultAction:
            options?.cupertinoDialogActionOptions?.isDefaultAction ?? false,
        child: child,
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: options?.materialDialogActionOptions?.textStyle,
      child: child,
    );
  }
}
