# CalmTide Chat History

This file captures the working decisions made while building CalmTide.

## Initial App Build

- Created a fresh native Xcode app project named `CalmTide`.
- Added `CalmTide.xcodeproj` with a native app target that builds `CalmTide.app`.
- Added shared Xcode scheme `CalmTide`.
- Set bundle identifier to `com.ayodele.CalmTide`.
- Set minimum iOS to 17.0.
- Added macOS 14.0 support after discovering the iOS `.app` bundle could not be opened directly on a Mac.
- Confirmed iPhone 11 and newer devices can run the app as long as they are on iOS 17 or later.

## Architecture Decisions

- Used SwiftUI app lifecycle.
- Used Swift Observation:
  - `@Observable AppState`
  - `@State private var appState = AppState()` at the app root
  - `.environment(appState)` injection
  - `@Environment(AppState.self)` reads
- Added `@available(iOS 17.0, macOS 14.0, *)` to app and main SwiftUI views.
- Gated macOS-only APIs with `#if os(macOS)`.
- Avoided creating a runnable SwiftPM executable.

## App Features

- Dashboard with session cycle controls.
- Phase duration controls for inhale, hold, exhale, and rest.
- Reminder toggle and interval slider.
- Status copy and start button.
- Breathing session screen with animated tide visualization.
- Phase name, phase cue, countdown, pause/resume, skip phase, and end session controls.
- Canvas and TimelineView animation.
- Reduced-motion support.
- UserDefaults persistence.
- Local notification permission request.
- Local reminder notifications.
- Timer-based reminders and session countdown.

## Product Polish

- Added AppIcon asset catalog with iOS, iPadOS, macOS, and marketing icon sizes.
- Added deterministic icon generator: `script/generate_app_icons.swift`.
- Icon direction: moonlit tide, calm water, and soft breath circle.
- Added About CalmTide sheet with:
  - What the app does
  - How to use it
  - Reminders
  - Privacy
  - Gentle wellness disclaimer
  - Version footer

## Store Prep

- Created `StoreSubmission/` with:
  - App Store copy
  - Privacy policy draft
  - App privacy answers
  - Submission checklist
  - Screenshot plan
  - Release notes
- Positioning decision: describe CalmTide as guided breathing and relaxation, not medical treatment.
- Current App Store blockers:
  - Apple Developer Program membership
  - Public privacy policy URL
  - Screenshots
  - TestFlight build upload

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
- Current Android blocker:
  - A device/emulator run has not been verified yet.
  - ADB works, but no Android device or emulator was attached during the first local Android build verification.
- Android build verification after Android Studio install:
  - Installed/used Android SDK Platform 35.
  - Generated Gradle wrapper files.
  - Built debug APK successfully.
  - Built release Android App Bundle successfully.

## Build Verification

Verified these builds successfully after product polish:

```sh
xcodebuild -project CalmTide.xcodeproj -scheme CalmTide -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO build
xcodebuild -project CalmTide.xcodeproj -scheme CalmTide -destination generic/platform=macOS CODE_SIGNING_ALLOWED=NO build
```
