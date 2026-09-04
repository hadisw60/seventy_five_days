# 75 Days

A personal 75-day challenge app built with Flutter. Fully offline and local —
no account, no login, no backend.

## The challenge

Every day requires these tasks before you can move on:

| Task | How it completes |
| --- | --- |
| Read 10 pages | Tap to check off |
| Program for 2 hours | A real running timer — no manual check-off |
| Prayer | Tap to check off |
| Daily progress photo | Take/pick an actual photo — no fake checkbox |
| Daily check-in | Pick a mood, energy level, and adherence rating |
| Gym (45 min) | Tap to check off — required Sat/Mon/Wed only |
| Walk 45 min | Tap to check off — required on gym days only |

Gym and walking are only mandatory on gym days (Saturday, Monday,
Wednesday, matching the real weekday); on other days they stay on the list
as optional so you can still log them without being blocked by them. The
next day stays locked until every required task for that day is done. Day
75 ends the challenge; there is no day 76.

Nutrition and sleep are guidance, not checkable tasks — no starvation
diets, regular meals with enough protein, and sleep is treated as part of
the challenge rather than something to sacrifice for it.

## Features

- **Progress tracking** — overall stats, completed-day history, motivational lines
- **Calendar** — 75-cell grid; completed days open their photo and notes
- **Journal** — optional mood, free-text note, and voice memo per day
- **Weight check-ins** — logged every 15 days, with trend indicators
- **Before / After** — side-by-side comparison of any two progress photos
- **Transformation** — an in-app slideshow through every photo taken
- **Reminders** — a daily local notification at a time you choose
- **Bilingual** — English and Persian (فارسی), with full RTL support

## Getting the APK

Every push builds a release APK on GitHub Actions. To get it:

1. Open the **Actions** tab
2. Click the most recent **Build Android APK** run
3. Download the **seventy-five-days-apk** artifact
4. Unzip it and install `app-release.apk` on your phone
   (you'll need to allow installing from unknown sources)

The APK is signed with the debug key, which is fine for installing on your own
device but not for Play Store distribution.

## Running locally

```bash
flutter pub get
flutter run
```

Supported: Android, Windows. iOS and macOS are configured but untested.
Web is not supported — photo and voice capture rely on `dart:io`.

## Architecture

```
lib/
├── main.dart              # wiring only, no logic
├── models/                # DailyTask, ChallengeState, DayRecord, Mood,
│                           # EnergyLevel, AdherenceLevel, WeightEntry
├── services/              # storage, photo, voice, notifications, settings, sound
├── controllers/           # ChangeNotifier controllers — all business logic
├── screens/               # one file per screen
├── widgets/               # reusable UI pieces
└── l10n/                  # .arb translation files + generated localizations
```

Business logic lives in the controllers; the UI only reads state and calls
methods. Storage sits behind a `StorageService` interface, so the current
`shared_preferences` implementation can be swapped for SQLite/Isar/Hive without
touching the UI.

## Notes on build configuration

- `path_provider_android` is pinned to `2.2.23` — the last release before it
  moved to JNI bindings, which would force an NDK/CMake native build. This app
  has no native code of its own.
- `android/app/build.gradle.kts` deliberately sets no `ndkVersion`, for the
  same reason.
- Release builds are signed with a real keystore when `android/key.properties`
  exists (see `android/key.properties.example`), falling back to Flutter's
  shared debug key otherwise. Play Protect flags the debug key as untrusted
  and blocks install with a "harmful app" warning — set up the real keystore
  to get past that.
- `flutter_timezone` currently makes the build print a Kotlin Gradle Plugin
  warning ("Future versions of Flutter will fail to build..."). This is an
  upstream issue in that package (already on its latest release) — harmless
  for now, nothing to fix on our side yet.
