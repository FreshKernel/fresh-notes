import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRoute, GoRouter;

import '../../core/log/logger.dart';
import '../../core/my_app.dart';
import '../../data/notes/cloud/s_cloud_notes.dart';
import '../../data/notes/universal/models/m_note.dart';
import 'onboarding/s_onboarding.dart';
import 'save_note/s_save_note.dart';
import 'settings/s_settings.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: MyHomeWidget.routeName,
        builder: (context, state) => const MyHomeWidget(),
      ),
      GoRoute(
        path: OnBoardingScreen.routeName,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: SaveNoteScreen.routeName,
        builder: (context, state) {
          final args = state.extra as SaveNoteScreenArgs;
          return SaveNoteScreen(
            args: args,
          );
        },
      ),
      GoRoute(
        path: '${SaveNoteScreen.routeName}/:noteId',
        builder: (context, state) {
          final noteId = state.pathParameters['noteId'];
          if (noteId == null) {
            throw ArgumentError('The noteId should not be null');
          }
          return FutureBuilder(
            future: CloudNotesService.getInstance().getOneById(noteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Error while loading the note: ${snapshot.error.toString()}',
                    ),
                  ),
                );
              }
              final cloudNote = snapshot.data;
              if (cloudNote == null) {
                return const Scaffold(
                  body: Center(child: Text('Note does not exists.')),
                );
              }
              return SaveNoteScreen(
                args: SaveNoteScreenArgs(
                  isDeepLink: true,
                  note: UniversalNote.fromCloudNote(cloudNote),
                ),
              );
            },
          );
        },
      ),
    ],
  );

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';
    final uri = Uri.parse(name);
    final pathSegments = uri.pathSegments;

    AppLogger.log('onGenerateRoute with name $name');
    AppLogger.log(
      'pathSegments ${pathSegments.toString()}, length ${pathSegments.length}',
    );

    if (pathSegments.isEmpty) {
      return null;
    }

    if (name.startsWith(SaveNoteScreen.routeName)) {
      if (pathSegments.length == 2) {
        return MaterialPageRoute(
          builder: (context) {
            return const Text('das');
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
