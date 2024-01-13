import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show AppBar, MaterialApp, Scaffold;
import 'package:flutter/widgets.dart'
    show Center, WidgetsFlutterBinding, runApp;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:logging/logging.dart' show Logger;

import 'core/log/logger.dart';
import 'core/my_app.dart';
import 'core/start/app_startup.dart';
import 'presentation/components/others/w_error.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kDebugMode) {
      Logger.root.level = Level.ALL; // defaults to Level.INFO
      Logger.root.onRecord.listen((record) {
        if (kDebugMode) {
          print(record.message);
        }
      });
    }

    await dotenv.load(fileName: '.env');
    await AppStartup.getInstance().initialize();
    runApp(const MyApp());
  } catch (e) {
    AppLogger.error(e);
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(),
          body: Center(
              child: ErrorWithoutTryAgain(
            error: e.toString(),
          )),
        ),
      ),
    );
  }
}
