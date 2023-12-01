#!/bin/bash

# Reset CocoaPods
reset_cocoapods() {
  echo "Reset CocoaPods for the $1 project:"
  echo ""
  cd "$1"
  pod deintegrate; rm Podfile.lock; pod install
  cd -
}

# Reset CocoaPods for the iOS project
reset_cocoapods "ios"

# Reset CocoaPods for the macOS project
reset_cocoapods "macos"