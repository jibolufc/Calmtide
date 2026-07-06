# Windows Plan

## Target

Windows desktop version of CalmTide.

## Recommended Stack Options

### Option 1: WinUI 3

Pros:
- Native Windows feel.
- Good Microsoft Store fit.

Cons:
- Separate implementation from SwiftUI.

### Option 2: .NET MAUI

Pros:
- Could also support Android with shared C# code.
- Good if the project becomes cross-platform-first.

Cons:
- UI polish can take more work.

### Option 3: Flutter

Pros:
- Strong cross-platform story for Windows and Android.
- Fast UI iteration.

Cons:
- Would be a rewrite away from SwiftUI.

## Recommendation

Do not prioritize Windows before iOS and Android unless there is a clear user need.

Suggested path:

1. Ship iOS.
2. Build Android.
3. Reassess whether Windows should be native WinUI or part of a broader cross-platform rewrite.

## Windows Store Requirements To Plan For

- Microsoft Partner Center account.
- App name reservation.
- Package identity.
- Store listing copy.
- Screenshots.
- Privacy policy URL.
- Age rating.
- MSIX packaging.
- Code signing.

## Feature Considerations

- Desktop window layout should not feel like a stretched phone screen.
- Keyboard shortcuts could be useful:
  - Space: pause/resume
  - Right arrow: skip phase
  - Escape: end session
- Reminder behavior needs Windows notification integration.

