# CalmTide App Store Submission Checklist

## Apple Developer Account
- Enroll in the Apple Developer Program.
- Sign in to Xcode with the Apple ID used for the developer account.
- Select your Apple Developer Team in Signing & Capabilities.

## Xcode Project
- Confirm bundle identifier: `com.ayodele.CalmTide`.
- Confirm version: `1.0`.
- Increment build number before each upload.
- Confirm app icon appears correctly.
- Build and run on at least one iPhone simulator.
- Build and run on a real device if available.
- Test notification permission and reminder toggle.
- Test reduced motion setting if possible.

## App Store Connect
- Create a new app record.
- Platform: iOS.
- Name: `CalmTide`.
- Bundle ID: `com.ayodele.CalmTide`.
- SKU: `calmtide-ios-001`.
- Category: Health & Fitness.
- Add pricing and availability.
- Add age rating.
- Add privacy policy URL: `https://jibolufc.github.io/Calmtide/privacy.html`.
- Fill out App Privacy.
- Add screenshots.
- Add app description, subtitle, keywords, and review notes.

## Screenshots
Capture screenshots for required App Store sizes:
- Dashboard
- Breathing session
- About or settings/reminders

Avoid showing medical claims in screenshots.

## Archive And Upload
- In Xcode, choose a generic iOS device or connected iPhone.
- Select `Product > Archive`.
- Validate archive.
- Distribute to App Store Connect.
- Wait for processing.
- Add build to TestFlight.
- Test through TestFlight before review.

## Review Positioning
Use language like:
- Guided breathing
- Relaxation
- Calm pauses
- Breathing practice

Avoid claims like:
- Treats anxiety
- Cures panic attacks
- Fixes insomnia
- Medical breathing therapy
