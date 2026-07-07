# Google Play Requirements In Progress

CalmTide Android is being prepared as a native Android app under `Android/`.

## Current App Details

- App name: CalmTide
- Package name: `com.ayodele.calmtide`
- Category: Health & Fitness or Lifestyle
- Minimum Android SDK: 26
- Target Android SDK: 35
- Release artifact for Play: Android App Bundle (`.aab`)

## Requirements To Complete

- Google Play Developer account.
- Android Studio installed locally.
- Successful `bundleRelease` build.
- Play App Signing enabled.
- Upload key generated and stored securely outside the repo.
- Privacy policy URL published.
- Data safety form completed.
- Store listing copy completed.
- Phone screenshots captured.
- Feature graphic prepared.
- Internal testing release completed before production.

## Current Policy Notes

- Google Play target API requirements currently require new apps and app updates to target Android 15 / API level 35 or higher.
- Google Play requires a Data safety form for published apps, including apps that do not collect user data.
- Android release artifacts must be signed. Google Play recommends publishing with Android App Bundles and Play App Signing.

## Official Sources

- Target API requirements: https://developer.android.com/google/play/requirements/target-sdk
- Data safety form: https://support.google.com/googleplay/android-developer/answer/10787469
- App signing and Play App Signing: https://developer.android.com/studio/publish/app-signing
