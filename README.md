# CalmTide

CalmTide is a SwiftUI guided breathing app for iOS and macOS.

The app guides users through inhale, hold, exhale, and rest phases with an animated tide visualization, adjustable phase durations, session cycle controls, optional local reminders, and local settings persistence.

## Platforms

- iOS 17.0+
- macOS 14.0+
- Android scaffold: native Kotlin/Jetpack Compose project under `Android/`

The Apple target is a native Xcode app project, not a runnable Swift Package executable.

## Project

- Xcode project: `CalmTide.xcodeproj`
- Bundle identifier: `com.ayodele.CalmTide`
- App target product: `CalmTide.app`
- Shared scheme: `CalmTide`

## Build

Build iOS:

```sh
xcodebuild -project CalmTide.xcodeproj -scheme CalmTide -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO build
```

Build macOS:

```sh
xcodebuild -project CalmTide.xcodeproj -scheme CalmTide -destination generic/platform=macOS CODE_SIGNING_ALLOWED=NO build
```

Or use:

```sh
script/build_and_run.sh
script/build_and_run.sh --mac
```

## App Store Prep

Store submission drafts live in `StoreSubmission/`.

Current blockers before App Store submission:

- Apple Developer Program membership
- Public Privacy Policy URL
- App Store screenshots
- TestFlight upload and review

## Cross-Platform Planning

Planning notes for Google Play and Windows live in `PlatformPlans/`.

## Android / Google Play Prep

The Android version lives in `Android/` and is intended to be opened with Android Studio. Google Play submission drafts live in `GooglePlaySubmission/`.

Current Android blocker: this workspace does not yet have Android Studio, the Android SDK command-line tools, or Gradle installed, so the Android app bundle has not been locally verified here.
