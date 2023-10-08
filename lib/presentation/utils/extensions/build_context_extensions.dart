import 'package:flutter/widgets.dart' show BuildContext, ModalRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/errors/exceptions.dart';

extension BuildContextExtensions on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    final args = modalRoute?.settings.arguments;
    if (args != null && args is T) {
      return args as T;
    }
    return null;
  }

  /// Stands for localizations
  AppLocalizations get loc {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw const AppException("Localizations is null and it's required");
    }
    return localizations;
  }
}
