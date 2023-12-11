import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fresh_base_package/fresh_base_package.dart'
    show PlatformChecker;

class AppScrollBar extends StatelessWidget {
  const AppScrollBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (PlatformChecker.defaultLogic().isAppleSystem()) {
      return CupertinoScrollbar(child: child);
    }
    return Scrollbar(child: child);
  }
}
