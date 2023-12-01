import 'dart:io' show ProcessException;

import 'package:logging/logging.dart' show Logger;

import 'shared_release.dart';
import 'utils/command.dart';

Future<void> main(List<String> args) async {
  await buildAndroidRelease(args);
}

Future<void> buildAndroidRelease(List<String> args) async {
  final log = Logger('build_android_release.dart/buildAndroidRelease()');
  try {
    await sharedRelease(args);
    log.info('Building the Android app...\n');

    await commandLine(
      executalbe: 'flutter',
      args: [
        'build',
        'appbundle',
        '--obfuscate',
        '--split-debug-info=./build/app/outputs/bundle/release',
      ],
    );
  } on ProcessException catch (e) {
    log.shout('Error code ${e.errorCode}: ${e.message}');
  } catch (e, stacktrace) {
    log.shout('Unknown error; ${e.toString()}, ${stacktrace.toString()}');
  }
}
