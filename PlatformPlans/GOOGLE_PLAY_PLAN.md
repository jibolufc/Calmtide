# Google Play Plan

## Target

Android guided breathing app based on CalmTide.

## Recommended Stack

- Kotlin
- Jetpack Compose
- Android Studio
- Minimum Android version: SDK 26 / Android 8.0
- Target Android version: SDK 35 / Android 15
- Local notifications with Android notification permission handling
- SharedPreferences for settings persistence in the first Android scaffold

## Features To Match

- Dashboard with breathing controls.
- Inhale, hold, exhale, and rest durations.
- Session cycle count.
- Reminder toggle and interval.
- Animated tide visualization.
- Pause/resume, skip phase, and end session.
- Local-only settings.
- About CalmTide screen.
- Privacy positioning matching iOS.

## Google Play Requirements

- Google Play Developer account.
- App signing setup.
- Package name: `com.ayodele.calmtide`.
- App icon.
- Feature graphic.
- Screenshots.
- Short description.
- Full description.
- Privacy policy URL.
- Data safety form.
- Content rating.
- Internal testing release before production.

## Current Android Scaffold

- Native Android project created in `Android/`.
- Google Play submission prep created in `GooglePlaySubmission/`.
- Build not yet verified locally because Android Studio, Android SDK tools, and Gradle are not installed in this workspace.

## Store Positioning

Use guided breathing, relaxation, and wellness language. Avoid medical claims.

## Open Questions

- Should Android ship as free?
- Should it have the same reminder defaults as iOS?
- Should Google Play launch happen after iOS TestFlight or after iOS App Store approval?
