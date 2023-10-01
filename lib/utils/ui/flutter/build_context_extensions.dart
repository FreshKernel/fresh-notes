import 'package:flutter/widgets.dart' show BuildContext, ModalRoute;

extension BuildContextExtensions on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    final args = modalRoute?.settings.arguments;
    if (args != null && args is T) {
      return args as T;
    }
    return null;
  }
}
