import 'package:flutter/material.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';

extension AppThemeModeExtensions on AppThemeMode {
  ThemeMode toMaterialThemeMode() {
    switch (this) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
