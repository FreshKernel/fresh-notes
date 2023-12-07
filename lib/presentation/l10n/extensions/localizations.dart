import 'package:flutter/widgets.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as generated;

import '../../../core/errors/exceptions.dart';

typedef AppLocalizations = generated.AppLocalizations;

extension LocalizationsExt on BuildContext {
  /// Stands for localizations
  AppLocalizations get loc {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      throw const AppException("Localizations is null and it's required");
    }
    return localizations;
  }
}
