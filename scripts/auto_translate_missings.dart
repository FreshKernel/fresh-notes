// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';

// const translationsDirectory = 'lib/presentation/l10n';
// final langs = ['ar'];
// final defaultLang = File('$translationsDirectory/app_en.arb');
// final untranslatedFile = File('$translationsDirectory/untranslated.json');

// void main(List<String> args) async {
//   final unTrasnaltedJson =
//       jsonDecode(await untranslatedFile.readAsString()) as Map<String, Object?>;
//   final defaultLangJson =
//       jsonDecode(await defaultLang.readAsString()) as Map<String, Object?>;
//   for (final lang in langs) {
//     final missings = unTrasnaltedJson[lang] as List<dynamic>;
//     for (final missingKey in missings) {
//       final missingValue = defaultLangJson[missingKey];
//       print(
//           'Enter a translation for the key: $missingKey, with value: `$missingValue` for languague $lang');
//       final translation = stdin.readLineSync();
//       final langFile = File('$translationsDirectory/app_$lang.arb');
//       final langFileJson =
//           jsonDecode(await langFile.readAsString()) as Map<String, Object?>;
//     }
//   }
// }
