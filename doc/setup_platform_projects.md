# Setup Platform Projects

This file contains info about how to setup all the 
native projects after create the flutter project using `flutter create`

This page is incomplete.

## Table of Contents
- [Setup Platform Projects](#setup-platform-projects)
  - [Table of Contents](#table-of-contents)
  - [Android Project](#android-project)
    - [Update the Project](#update-the-project)

## Android Project

### Update the Project

The first steps is to update Android Gradle Plugin, Gradle and Kotlin version

1. Open the `android` project with Android Studio
2. Click on Tools/AGP Upgrade Assistant
3. Use the latest version of AGP (for example 8.2.0)
4. Run the selected steps
5. Switch from Android Project View to Project View

You can also go to the `gradle-wraper.properties` and update the `distributionUrl`

6. Now go to `build.gradle` or `build.gradle.kts` at the project level
7. Update the `kotlin_version` to the latest version, you can find the latest version in Kotlin website

8. Follow the steps in this [gist](https://gist.github.com/freshtechtips/93fefb39e48c40592bda3931e05fd35c) to fix AGP 8.0 build issue
9. Let's move to `build.gradle` in the `app` module, update any deprecated properties, for example `compileSdkVersion` to `compikeSdk`