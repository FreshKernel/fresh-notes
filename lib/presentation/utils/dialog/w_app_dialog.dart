import 'package:flutter/material.dart' show Colors, showAdaptiveDialog;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Color,
        Offset,
        RouteSettings,
        TraversalEdgeBehavior,
        WidgetBuilder,
        immutable;

@immutable
class DialogOptions {
  const DialogOptions({
    this.barrierDismissible,
    this.barrierColor = Colors.black54,
    this.barrierLabel,
    this.useSafeArea = true,
    this.useRootNavigator = true,
    this.routeSettings,
    this.anchorPoint,
    this.traversalEdgeBehavior,
  });
  final bool? barrierDismissible;
  final Color barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  DialogOptions? options,
}) {
  return showAdaptiveDialog<T>(
    context: context,
    builder: builder,
    anchorPoint: options?.anchorPoint,
    barrierColor: options?.barrierColor ?? Colors.black54,
    useRootNavigator: options?.useRootNavigator ?? true,
    useSafeArea: options?.useSafeArea ?? true,
    barrierDismissible: options?.barrierDismissible,
    barrierLabel: options?.barrierLabel,
    routeSettings: options?.routeSettings,
    traversalEdgeBehavior: options?.traversalEdgeBehavior,
  );
}

@immutable
class AppDialogMessenger {
  const AppDialogMessenger({
    required this.context,
  });

  final BuildContext context;

  Future<T?> showDialog<T>({
    required WidgetBuilder builder,
    DialogOptions? options,
  }) =>
      showAppDialog(context: context, builder: builder, options: options);
}
