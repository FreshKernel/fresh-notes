import 'dart:io' show ProcessException;

import 'package:logging/logging.dart' show Logger;

import 'utils/command.dart';

Future main() async {
  await buildProject();
}

Future<void> buildProject() async {
  final log = Logger('build.dart/buildProject()');
  try {
    await commandLine(executalbe: 'flutter', args: ['--version']);

    log.info('Cleaning flutter project...\n');

    await commandLine(
      executalbe: 'flutter',
      args: ['clean'],
    );

    log.info('Get all the dependencies...\n');

    await commandLine(
      executalbe: 'flutter',
      args: [
        'pub',
        'get',
        '--no-example',
      ],
    );

    log.info(
      'Upgrade all the dependencies even with breaking changes ones...\n',
    );

    final upgradeResult = await commandLine(
      executalbe: 'flutter',
      args: ['pub', 'upgrade', '--major-versions'],
    );
    final nothingsChanged =
        upgradeResult.trim().contains('No dependencies changed.');
    if (!nothingsChanged) {
      log.warning(
        'The dependencies has been upgraded, please test the app functionallities and fix the breaking changes if exists',
      );
      return;
    }

    log.info('Run all the builds to generate the generated code...\n');
    await commandLine(
      executalbe: 'dart',
      args: [
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs',
      ],
    );
  } on ProcessException catch (e) {
    log.shout('Error code ${e.errorCode}: ${e.message}');
  } catch (e, stacktrace) {
    log.shout('Unknown error; ${e.toString()}, ${stacktrace.toString()}');
  }
}
