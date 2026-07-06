# CalmTide Cross-Platform Plan

CalmTide is currently a native SwiftUI app for iOS and macOS.

The next platform choices are Google Play and Windows. There are two realistic routes:

## Route A: Keep SwiftUI For Apple, Build Separate Apps Elsewhere

Use:

- SwiftUI for iOS/macOS
- Kotlin + Jetpack Compose for Android
- WinUI or .NET MAUI for Windows

Pros:
- Best native feel on every platform.
- Easier to meet platform conventions.
- Strong App Store and Play Store fit.

Cons:
- More code to maintain.
- Features must be reimplemented per platform.

## Route B: Rebuild Shared UI In A Cross-Platform Framework

Use:

- Flutter
- React Native
- .NET MAUI

Pros:
- Shared app logic and UI.
- Faster Google Play and Windows expansion.

Cons:
- Existing SwiftUI work would need partial or full rewrite.
- App may feel less native unless carefully tuned.

## Recommendation

For CalmTide, Route A is safest for a polished wellness app:

1. Ship iOS first.
2. Keep macOS support.
3. Build Android in Kotlin + Jetpack Compose using the current SwiftUI app as the product reference.
4. Decide Windows later after Android demand is clear.

The app logic is small enough that separate native implementations are manageable.

