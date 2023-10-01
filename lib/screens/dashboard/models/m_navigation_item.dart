import 'package:flutter/widgets.dart' show Widget;

class NavigationItem {

  const NavigationItem({
    required this.label,
    required this.body,
    required this.title,
    required this.icon,
    this.selectedIcon,
    this.tooltip,
  });
  final String title;
  final String label;
  final Widget body;
  final Widget icon;
  final Widget? selectedIcon;
  final String? tooltip;
}
