import 'dart:io';

import 'package:yaml/yaml.dart';

void main(List<String> args) async {
  final pubspecYamlFile = File('./pubspec.yaml');
  final pubspecYamlContent = await pubspecYamlFile.readAsString();
  final yamlDocument = loadYaml(pubspecYamlContent);
  final version = yamlDocument['version'].toString();
  final appVersion = version.split('+')[0];
  final appBuildNumber = version.split('+')[1];

  final repository = yamlDocument['repository'].toString();

  final generatedDartFile = '''
const appVersion = '$appVersion';
const appBuildNumber = $appBuildNumber;
const repository = '$repository';
''';
  final file = File('./lib/gen/pubspec.dart');
  if (!(await file.exists())) {
    await file.create(recursive: true);
  }
  await file.writeAsString(generatedDartFile);
}
