import 'package:flutter/widgets.dart' show Widget, immutable, BuildContext;

@immutable
class NavigationItem {
  const NavigationItem({
    required this.label,
    required this.body,
    required this.title,
    required this.icon,
    this.selectedIcon,
    this.tooltip,
    this.actionsBuilder,
    this.actionButtonBuilder,
  });
  final String title;
  final String label;
  final Widget body;
  final Widget icon;
  final Widget? selectedIcon;
  final String? tooltip;
  final NavigationItemActionsBuilder? actionsBuilder;
  final NavigationItemActionButtonBuilder? actionButtonBuilder;
}

typedef NavigationItemActionsBuilder = List<Widget> Function(
    BuildContext context);

typedef NavigationItemActionButtonBuilder = Widget Function(
    BuildContext context);
