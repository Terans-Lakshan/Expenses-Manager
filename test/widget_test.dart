import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:expense_manager/app/providers.dart';
import 'package:expense_manager/app/theme.dart';
import 'package:expense_manager/data/database.dart';
import 'package:expense_manager/domain/period.dart';
import 'package:expense_manager/features/add_record/add_record_screen.dart';
import 'package:expense_manager/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  });

  tearDown(() => db.close());

  Widget app(Widget child) => ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(theme: buildTheme(Brightness.light), home: Scaffold(body: child)),
      );

  testWidgets('Home period switch changes the label and is remembered', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    await tester.pumpWidget(app(const HomeScreen()));
    await tester.pump();

    final now = DateTime.now();
    expect(find.text(periodLabel(PeriodKind.month, periodRange(PeriodKind.month, now))), findsOneWidget);

    await tester.tap(find.text('Week'));
    await tester.pump();
    expect(find.text(periodLabel(PeriodKind.week, periodRange(PeriodKind.week, now))), findsOneWidget);
    expect(prefs.getString('last_period_home'), 'week');

    await tester.tap(find.byTooltip('Previous period'));
    await tester.pump();
    final prev = periodRange(PeriodKind.week, DateTime(now.year, now.month, now.day - 7));
    expect(find.text(periodLabel(PeriodKind.week, prev)), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Add record validates amount and category', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1400));
    await tester.pumpWidget(app(const AddRecordScreen()));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Save expense'));
    await tester.pump();
    expect(find.text('Enter an amount'), findsOneWidget);
    expect(find.text('Pick an expense category'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '1.234');
    await tester.tap(find.text('Save expense'));
    await tester.pump();
    expect(find.text('Use at most 2 decimals'), findsOneWidget);

    // Switching to Income changes the save label and category set.
    await tester.tap(find.text('Income'));
    await tester.pump();
    expect(find.text('Save income'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.binding.setSurfaceSize(null);
  });
}
