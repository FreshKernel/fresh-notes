import 'package:flutter/material.dart';

import '../../main.dart';
import 'save_note/s_save_note.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name;

    if (name == HomeWidget.routeName) {
      return MaterialPageRoute(
        settings: const RouteSettings(name: HomeWidget.routeName),
        builder: (context) {
          return const HomeWidget();
        },
      );
    }

    if (name == SaveNoteScreen.routeName) {
      final args = settings.arguments as SaveNoteScreenArgs;
      return MaterialPageRoute(
        settings: const RouteSettings(name: SaveNoteScreen.routeName),
        builder: (context) {
          return SaveNoteScreen(
            args: args,
          );
        },
      );
    }

    return null;
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/404'),
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Not found'),
          ),
          body: const Text('404'),
        );
      },
    );
  }
}
