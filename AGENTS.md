# SmartWallet Agent Instructions

## Project Snapshot

- Flutter app for tracking daily balance, transaction history, and simple financial status cues.
- Use [README.md](README.md) for user-facing context and [pubspec.yaml](pubspec.yaml) as the source of truth for dependencies and package versions.

## Workflow

- Prefer standard Flutter commands: `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run`.
- Use platform build commands as needed: `flutter build apk`, `flutter build ios`, `flutter build web`, `flutter build windows`, `flutter build macos`, and `flutter build linux`.
- Keep changes lint-clean; the analyzer is configured through [analysis_options.yaml](analysis_options.yaml).
- Avoid editing generated or build output under `build/` and platform ephemeral folders.

## Architecture

- App startup begins in [lib/main.dart](lib/main.dart), which initializes bindings, locks orientation, loads settings, opens Hive, and then runs [lib/pages/my_app.dart](lib/pages/my_app.dart).
- Main navigation and transaction entry live in [lib/pages/homepage.dart](lib/pages/homepage.dart).
- First-run setup is in [lib/pages/first_page.dart](lib/pages/first_page.dart); history and profile flows are in [lib/pages/history.dart](lib/pages/history.dart) and [lib/pages/profile.dart](lib/pages/profile.dart).
- Local persistence and export logic are centralized in [lib/database/database.dart](lib/database/database.dart).
- App settings and balance state are managed by [lib/setting/setting_controller.dart](lib/setting/setting_controller.dart) and [lib/pages/balance_controller.dart](lib/pages/balance_controller.dart).

## Conventions

- Keep state changes routed through the existing singletons unless a refactor is explicitly requested.
- Preserve the Material 3 + green theme direction used by [lib/pages/my_app.dart](lib/pages/my_app.dart).
- Prefer minimal, focused edits that fit the current screen and controller boundaries.
- Update or add tests alongside behavior changes when practical.

## Known Pitfalls

- [test/widget_test.dart](test/widget_test.dart) is still the default Flutter smoke test and is not representative of this app.
- [lib/database/database.dart](lib/database/database.dart) currently opens a fixed Hive box name, so changes to storage should be made carefully.
- Transaction entry in [lib/pages/homepage.dart](lib/pages/homepage.dart) depends on numeric text input and should not be widened without validation.
- Balance logic in [lib/pages/balance_controller.dart](lib/pages/balance_controller.dart) assumes a non-zero daily need.

## Related Documentation

- [README.md](README.md) for product overview and installation notes.
- [LICENSE.md](LICENSE.md) for licensing terms.
