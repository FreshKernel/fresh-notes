import 'package:flutter/material.dart';

/// When press icon button I mean
class AppPopupMenuByIconButton extends StatefulWidget {
  const AppPopupMenuByIconButton({
    required this.child,
    required this.builder,
    required this.tooltip,
    super.key,
  });

  final Widget child;
  final WidgetBuilder builder;
  final String? tooltip;

  @override
  State<AppPopupMenuByIconButton> createState() =>
      _AppPopupMenuByIconButtonState();
}

class _AppPopupMenuByIconButtonState extends State<AppPopupMenuByIconButton> {
  // final _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo();
    // return CustomPopupMenu(
    //   controller: _controller,
    //   menuBuilder: () {
    //     return widget.builder(context);
    //   },
    //   pressType: PressType.singleClick,
    //   child: widget.child,
    // );
    // return IconButton(
    //   tooltip: widget.tooltip,
    //   onPressed: () {
    //     showPopover(
    //       context: context,
    //       bodyBuilder: widget.builder,
    //       direction: PopoverDirection.bottom,
    //       width: 200,
    //       height: 400,
    //       arrowHeight: 15,
    //       arrowWidth: 30,
    //     );
    //   },
    //   icon: widget.child,
    // );
  }
}
