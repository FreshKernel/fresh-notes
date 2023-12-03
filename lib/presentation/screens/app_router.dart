import 'package:flutter/material.dart';

import '../../core/log/logger.dart';
import '../../data/notes/cloud/s_cloud_notes.dart';
import '../../data/notes/universal/models/m_note.dart';
import '../../main.dart';
import 'onboarding/s_onboarding.dart';
import 'save_note/s_save_note.dart';
import 'settings/s_settings.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';
    final uri = Uri.parse(name);
    final pathSegments = uri.pathSegments;

    AppLogger.log('onGenerateRoute with name $name');
    AppLogger.log(
      'pathSegments ${pathSegments.toString()}, length ${pathSegments.length}',
    );

    if (name == MyHomeWidget.routeName) {
      return MaterialPageRoute(
        settings: const RouteSettings(name: MyHomeWidget.routeName),
        builder: (context) {
          return const MyHomeWidget();
        },
      );
    }

    if (name == OnBoardingScreen.routeName) {
      return MaterialPageRoute(
        settings: const RouteSettings(name: OnBoardingScreen.routeName),
        builder: (context) {
          return const OnBoardingScreen();
        },
      );
    }

    if (pathSegments.isEmpty) {
      return null;
    }

    if (name.startsWith(SaveNoteScreen.routeName)) {
      if (pathSegments.length == 2) {
        return MaterialPageRoute(
          builder: (context) {
            return FutureBuilder(
              future:
                  CloudNotesService.getInstance().getOneById(pathSegments[1]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Text(
                      'Error while loading the note: ${snapshot.error.toString()}',
                    ),
                  );
                }
                final cloudNote = snapshot.data;
                if (cloudNote == null) {
                  return const Scaffold(
                    body: Text('Note does not exists.'),
                  );
                }
                return SaveNoteScreen(
                  args: SaveNoteScreenArgs(
                    isForceReadOnly: true,
                    note: UniversalNote.fromCloudNote(cloudNote),
                  ),
                );
              },
            );
          },
        );
      }

      return MaterialPageRoute(
        settings: const RouteSettings(name: SaveNoteScreen.routeName),
        builder: (context) {
          final args = settings.arguments as SaveNoteScreenArgs;
          return SaveNoteScreen(
            args: args,
          );
        },
      );
    }

    if (name.startsWith(SettingsScreen.routeName)) {
      return MaterialPageRoute(
        settings: const RouteSettings(name: SettingsScreen.routeName),
        builder: (context) {
          return const SettingsScreen();
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
          body: const Center(child: Text('404')),
        );
      },
    );
  }
}
