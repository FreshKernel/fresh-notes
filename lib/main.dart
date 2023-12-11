import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;
import 'package:logging/logging.dart';

import 'core/flavor_config.dart';
import 'core/my_app.dart';
import 'core/start/app_startup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  await AppStartup.getInstance().initialize();
  runApp(const MyApp());
}
