# Android Release Checklist

## Development

- Install Android Studio.
- Open `/Users/ayodele/Documents/calmtide/Android`.
- Let Gradle sync successfully.
- Run on at least one Android phone.
- Run on at least one emulator with Android 15 / API 35.
- Confirm notification permission flow on Android 13+.
- Confirm reminders can be switched on and off.
- Confirm breathing session countdown, pause, resume, skip, and end controls.
- Confirm settings persist after closing and reopening the app.

## Release

- Create upload keystore outside the repo.
- Add signing config locally or through Android Studio.
- Build release Android App Bundle: `./gradlew bundleRelease`.
- Confirm release output is an `.aab`, not just an `.apk`.
- Upload to Play Console internal testing.
- Test install from Google Play internal testing.

## Store Listing

- App name: CalmTide.
- Short description complete.
- Full description complete.
- App icon ready.
- Feature graphic ready.
- Phone screenshots ready.
- Privacy policy URL live.
- Data safety form completed.
- Content rating questionnaire completed.
- Target audience selected.

## Production

- Run internal testing first.
- Fix any Play Console warnings.
- Promote to closed/open testing if useful.
- Submit production release when testing is clean.
