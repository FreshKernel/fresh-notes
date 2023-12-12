// ignore_for_file: avoid_print

import 'dart:io' show ProcessException, Process;

Future<String> executeCommand(
  String value, {
  bool printResult = true,
  String? workingDirectory,
}) async {
  final executalbe = value.split(' ')[0];
  final args = value.split(' ')
    ..removeAt(0)
    ..toList();
  print('$executalbe ${args.join(' ')}');
  final command = await Process.run(
    executalbe,
    args,
    workingDirectory: workingDirectory,
  );
  if (command.exitCode != 0) {
    if (printResult) {
      print(
        'Process exception, ${command.stderr}',
      );
    }
    throw ProcessException(
      executalbe,
      args,
      command.stderr,
      command.exitCode,
    );
  } else {
    print('Result: ${command.stdout}');
  }

  return command.stdout;
}
