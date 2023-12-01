#!/bin/bash

echo "Run flutter pub get.."
flutter pub get
echo ""

echo "Run flutter gen-l10n"
flutter gen-l10n
echo ""

echo ""
echo "Apply dart fixes to the newly generated files"
dart fix --apply ./lib/presentation/l10n/generated