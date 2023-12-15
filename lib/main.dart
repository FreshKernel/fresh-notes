import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart' show MaterialApp, Scaffold;
import 'package:flutter/widgets.dart'
    show Center, Text, WidgetsFlutterBinding, runApp;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

import 'core/flavor_config.dart';
import 'core/my_app.dart';
import 'core/start/app_startup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (!kReleaseMode) {
      Logger.root.level = Level.ALL; // defaults to Level.INFO
      Logger.root.onRecord.listen((record) {
        if (kDebugMode) {
          print('${record.time}: ${record.message}');
        }
      });
    }

    FlavorConfig.setup(
      appStore: const String.fromEnvironment('APP_STORE', defaultValue: ''),
      isShouldCheckForUpdates:
          const bool.fromEnvironment('UPDATE_CHECK', defaultValue: false),
    );

    await dotenv.load(fileName: '.env');
    await AppStartup.getInstance().initialize();
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(
              'Error while running the app: ${e.toString()}',
            ),
          ),
        ),
      ),
    );
  }
}
