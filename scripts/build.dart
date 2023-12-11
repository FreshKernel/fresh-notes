import 'dart:io' show ProcessException;

import 'package:logging/logging.dart' show Logger;

import 'utils/command.dart';

Future main() async {
  await buildProject();
}

Future<void> buildProject() async {
  final log = Logger('build.dart/buildProject()');
  try {
    await executeCommand('flutter --version');

    log.info('Cleaning flutter project...\n');

    await executeCommand('flutter clean');

    log.info('Get all the dependencies...\n');

    await executeCommand('flutter pub get --no-example');

    log.info(
      'Upgrade all the dependencies even with breaking changes ones...\n',
    );

    final upgradeResult =
        await executeCommand('flutter pub upgrade --major-versions');
    final nothingsChanged =
        upgradeResult.trim().contains('No dependencies changed.');
    if (!nothingsChanged) {
      log.warning(
        'The dependencies has been upgraded, please test the app functionallities and fix the breaking changes if exists',
      );
      return;
    }

    log.info('Run all the builds to generate the generated code...\n');
    await executeCommand(
      'dart run build_runner build --delete-conflicting-outputs',
    );
  } on ProcessException catch (e) {
    log.shout('Error code ${e.errorCode}: ${e.message}');
  } catch (e, stacktrace) {
    log.shout('Unknown error; ${e.toString()}, ${stacktrace.toString()}');
  }
}
