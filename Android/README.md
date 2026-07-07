# CalmTide Android

This folder contains a native Android version of CalmTide built with Kotlin and Jetpack Compose.

## Project

- App name: CalmTide
- Package/application ID: `com.ayodele.calmtide`
- Minimum Android SDK: 26
- Target Android SDK: 35
- UI: Jetpack Compose
- Reminder permissions: Android notification permission on Android 13+

## Open In Android Studio

1. Open Android Studio.
2. Choose **Open**.
3. Select `/Users/ayodele/Documents/calmtide/Android`.
4. Let Android Studio sync Gradle.
5. Choose the `app` configuration.
6. Run on an Android phone or emulator.

## Release Build

For Google Play, build an Android App Bundle:

```sh
./gradlew bundleRelease
```

The unsigned or locally signed bundle is produced under:

```text
Android/app/build/outputs/bundle/release/
```

Google Play should use Play App Signing. Keep upload keys private and do not commit keystores or passwords to Git.

## Local Verification Status

This project was scaffolded from the iOS CalmTide app. It has not been built in this workspace yet because Android Studio, the Android SDK command-line tools, and Gradle are not installed here.
