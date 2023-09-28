import 'package:my_notes/core/errors/exceptions.dart';

abstract class AppPageRoute {
  final String routeName = '';
}

String getPageRouteNameByWidget(AppPageRoute widget) {
  return widget.routeName;
}
