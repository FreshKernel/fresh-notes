import 'package:logging/logging.dart' show Logger;

import 'build_android_release.dart';
// import 'dart:developer' as dev show log;

void main(List<String> args) async {
  final log = Logger('run.dart/main');
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name} in ${record.loggerName}: ${record.message}');
  });
  if (args.isEmpty) {
    log.shout('Args is empty');
    return;
  }

  final command = args.first;
  switch (command) {
    case 'releaseAndroid':
      log.shout('Build the Android release version:\n');
      await buildAndroidRelease(args);
      break;
    case '--help':
      log.info(
        'Wait, you really think this will works?\n'
        "I don't want to disspoint you so: releaseAndroid, releaseiOS",
      );
      break;
    default:
      log.shout('Unknown command, run --help');
      break;
  }
}
