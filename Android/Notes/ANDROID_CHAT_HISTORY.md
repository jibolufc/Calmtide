# CalmTide Android Chat History

This file keeps the Android and Google Play work separate from the main CalmTide chat history so it is easier to scan.

## Android And Google Play Prep

- Added a native Android project scaffold under `Android/`.
- Chosen Android stack:
  - Kotlin
  - Jetpack Compose
  - Gradle Android application project
  - Package name `com.ayodele.calmtide`
  - Minimum SDK 26
  - Target SDK 35
- Mirrored CalmTide core features:
  - Dashboard controls
  - Breathing phase durations
  - Reminder toggle and interval
  - Session screen with animated tide visual
  - Pause, resume, skip, and end session controls
  - Local settings persistence
  - Local notification reminders
- Added `GooglePlaySubmission/` with:
  - Google Play requirements tracker
  - Store listing copy
  - Data safety draft
  - Android release checklist
  - Screenshot plan
  - Android privacy policy draft

## Android Studio Setup

- Installed Android Studio for Mac with Apple chip.
- Confirmed the Mac architecture is `arm64`.
- Android SDK installed under `/Users/ayodele/Library/Android/sdk`.
- Android SDK Platform 35 was installed and used for CalmTide builds.
- Generated Gradle wrapper files so future builds can use `./gradlew`.

## Build Verification

Verified locally:

```sh
cd /Users/ayodele/Documents/calmtide/Android
JAVA_HOME=/Applications/Android\ Studio.app/Contents/jbr/Contents/Home ANDROID_HOME=/Users/ayodele/Library/Android/sdk ./gradlew :app:assembleDebug :app:bundleRelease
```

Outputs:

```text
/Users/ayodele/Documents/calmtide/Android/app/build/outputs/apk/debug/app-debug.apk
/Users/ayodele/Documents/calmtide/Android/app/build/outputs/bundle/release/app-release.aab
```

Build result:

- Debug APK built successfully.
- Release Android App Bundle built successfully.
- Release AAB is the Google Play-style artifact.

## Device Setup And Install

- Test device: Samsung Galaxy A03.
- Model shown by ADB: `SM_A035F`.
- Device serial shown by ADB: `R9YT90WX64R`.
- Helped locate Samsung build number under:
  - `Settings > About phone > Software information > Build number`
- Enabled Developer options.
- Enabled USB debugging.
- ADB eventually detected the phone as:

```text
R9YT90WX64R device usb:2-1.4 product:a03nnxx model:SM_A035F device:a03
```

Installed the debug APK with:

```sh
/Users/ayodele/Library/Android/sdk/platform-tools/adb install -r /Users/ayodele/Documents/calmtide/Android/app/build/outputs/apk/debug/app-debug.apk
```

Install result:

```text
Performing Streamed Install
Success
```

Launched the app with:

```sh
/Users/ayodele/Library/Android/sdk/platform-tools/adb shell monkey -p com.ayodele.calmtide -c android.intent.category.LAUNCHER 1
```

Confirmed installed package metadata:

```text
pkg=com.ayodele.calmtide
versionCode=1
versionName=1.0
minSdk=26
targetSdk=35
```

## Current Android Status

- CalmTide builds for Android.
- CalmTide installs on the Samsung Galaxy A03.
- CalmTide launches on the Samsung Galaxy A03.
- User is testing app behavior on the physical Android device.

## Next Android Tasks

- Confirm dashboard layout on the Galaxy A03 screen.
- Confirm start session, countdown, pause/resume, skip, and end session.
- Confirm notification permission flow.
- Confirm local reminders.
- Capture Google Play screenshots.
- Prepare signed release/upload key before Play Console upload.
