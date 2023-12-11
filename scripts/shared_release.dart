import 'dart:io' show ProcessException;

import 'package:logging/logging.dart' show Logger;

import 'build.dart';
import 'utils/command.dart';

Future<void> sharedRelease(List<String> args) async {
  final log = Logger('shared_release.dart/sharedRelease()');
  try {
    await buildProject();

    log.info('Analyze the code using flutter analyze...\n');
    final flutterAnalyzeResult = await executeCommand(
      'flutter analyze',
    );
    final issuesFound = flutterAnalyzeResult.trim().contains('issues found.');

    final option = args.length >= 2 ? args[1] : '';
    final force = option == '--force';
    if (issuesFound && !force) {
      log.warning(
        'Please solve the issues before releae the app '
        'if you want to continue anyway pass "--force"',
      );
      return;
    }

    log.info('Run the tests...\n');

    final flutterTestResult = await executeCommand(
      'flutter test',
    );

    final testPassed = flutterTestResult.trim().contains('All tests passed!');
    if (!testPassed && !force) {
      log.shout('Please fix the bugs or the tests.');
      return;
    }
  } on ProcessException catch (e) {
    log.shout('Error code ${e.errorCode}: ${e.message}');
  } catch (e, stacktrace) {
    log.shout('Unknown error; ${e.toString()}, ${stacktrace.toString()}');
  }
}
