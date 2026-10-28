# Expense Manager

Offline-first Flutter app for logging expenses and income by category and reviewing them by Today, Week, Month or Year, with budgets and charts. All data stays on the device. No account or internet connection is needed.

Requirements: [Expense-Manager-PRD.md](Expense-Manager-PRD.md). Screen designs: [expense-manager-prototype.html](expense-manager-prototype.html) (open it in a browser).

## Run

```bash
flutter pub get
dart run build_runner build      # regenerates lib/data/database.g.dart after table changes
flutter run                      # Android emulator / phone
flutter run -d windows           # quick desktop testing
flutter test
flutter build apk --release
```

## Stack

Flutter · drift (SQLite) · Riverpod · go_router · fl_chart · intl · shared_preferences · flutter_local_notifications · local_auth · image_picker · pdf · share_plus · file_picker. Sora and Manrope are bundled in `assets/fonts/`, so they work offline.

## Structure

```
lib/
  main.dart            start-up: open DB (seeds defaults), run due recurring records, notifications
  app/                 theme (design tokens, light + dark), router, bottom-bar shell, providers, app lock gate
  data/                drift tables, default categories/wallets, repositories
  domain/              period ranges, money formatting/parsing, all calculations (pure Dart, unit-tested)
  features/            home, records, add_record, reports, budgets, categories, settings (+ wallets, recurring)
  services/            notifications, app lock, export (CSV/PDF), backup/restore, budget alerts, recurring runner
  widgets/             icons (category SVG icons), shared widgets, charts
test/                  period, money + calculations, repositories (in-memory drift), widget tests
```

## Notes

- Money is stored as integer cents and only formatted in the UI.
- Screens read and write data only through Riverpod providers and repositories.
- The database lives in app-private storage (`getApplicationSupportDirectory`).
- Backups are a single JSON file with every table and the settings. Receipt photos are not included.
