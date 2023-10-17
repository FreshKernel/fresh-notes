import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../logic/utils/platform_checker.dart';

class AppScrollBar extends StatelessWidget {
  const AppScrollBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (PlatformChecker.isAppleSystem()) {
      return CupertinoScrollbar(child: child);
    }
    return Scrollbar(child: child);
  }
}
