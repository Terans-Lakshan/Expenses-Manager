# Rules for the build

- Follow `Expense-Manager-PRD.md` for requirements and `expense-manager-prototype.html` for exact layouts, colours, spacing and icons (each screen is in `<template id="tpl-<Screen>">`; icons in `tpl-CatIcon`; tokens in `<script id="app-spec">`).
- Stack is fixed: Flutter, drift, Riverpod, go_router, fl_chart, intl. Do not add a backend.
- Store money as integer cents; format only in the UI (`lib/domain/money.dart`).
- All period logic lives in `lib/domain/period.dart` and is unit-tested before UI work uses it.
- Screens never call the database directly, only through providers (`lib/app/providers.dart`) and repositories (`lib/data/repositories/`).
- No sample transactions in the real app; seed only default categories and wallets.
- After table changes: `dart run build_runner build`.
- Before finishing: `flutter analyze` clean, `flutter test` passing, app runs with `flutter run`.
