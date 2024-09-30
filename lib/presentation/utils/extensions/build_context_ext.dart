import 'package:flutter/cupertino.dart' show CupertinoTheme, CupertinoThemeData;
import 'package:flutter/material.dart'
    show
        Brightness,
        BuildContext,
        ModalRoute,
        Navigator,
        NavigatorState,
        Theme,
        ThemeData;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/settings/cubit/settings_data.dart';
import '../dialog/w_app_dialog.dart';
import '../message_presenter.dart';

extension BuildContextExt on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    final args = modalRoute?.settings.arguments;
    if (args != null && args is T) {
      return args as T;
    }
    return null;
  }

  MessagePresenter get messenger {
    return MessagePresenter(context: this);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  bool get isDark {
    return Theme.of(this).brightness == Brightness.dark;
  }

  AppThemeSystem get themeSystem {
    return read<SettingsCubit>().state.themeSystem;
  }

  bool get isMaterial {
    return themeSystem == AppThemeSystem.material3 ||
        themeSystem == AppThemeSystem.material2;
  }

  bool get isCupertino {
    return themeSystem == AppThemeSystem.cupertino;
  }

  ThemeData get materialTheme {
    return Theme.of(this);
  }

  CupertinoThemeData get cupertinoTheme {
    return CupertinoTheme.of(this);
  }

  AppDialogMessenger get dialogMessenger {
    return AppDialogMessenger(context: this);
  }
}
