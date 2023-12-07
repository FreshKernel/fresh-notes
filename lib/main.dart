import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;

import 'core/flavor_config.dart';
import 'core/my_app.dart';
import 'core/start/app_startup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.setup(
    name: const String.fromEnvironment('FLAVOR', defaultValue: ''),
    appStore: const String.fromEnvironment('APP_STORE', defaultValue: ''),
    isShouldCheckForUpdates:
        const bool.fromEnvironment('UPDATE_CHECK', defaultValue: false),
  );
  await AppStartup.getInstance().initialize();
  runApp(const MyApp());
}
