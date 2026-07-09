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

For Google Play, build a signed Android App Bundle. The release build reads local
signing details from `Android/keystore.properties`, which must never be committed.

```sh
./gradlew :app:bundleRelease
```

The signed bundle is produced at:

```text
Android/app/build/outputs/bundle/release/app-release.aab
```

Google Play should use Play App Signing. Keep upload keys private and do not commit keystores or passwords to Git.

## Local Verification Status

Verified locally on July 7, 2026:

```sh
./gradlew :app:assembleDebug :app:bundleRelease
```

Outputs:

```text
Android/app/build/outputs/apk/debug/app-debug.apk
Android/app/build/outputs/bundle/release/app-release.aab
```

ADB is available from the installed Android SDK, but no Android device or emulator was attached during this verification.
