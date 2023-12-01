import 'dart:io' show Process, ProcessException;

import 'package:logging/logging.dart';

Future<String> commandLine({
  required String executalbe,
  List<String> args = const [],
  bool printResult = true,
}) async {
  final log = Logger('utills/command.dart/commandLine()');
  final command = await Process.run(executalbe, args);
  if (command.exitCode != 0) {
    log.shout(
      'The exit code is not equal to zero: ${command.stdout}',
    );
    throw ProcessException(executalbe, args);
  }
  if (printResult) {
    log.info(command.stdout.toString());
  }

  return command.stdout;
}
