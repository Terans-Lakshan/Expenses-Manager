import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:expense_manager/data/database.dart';
import 'package:expense_manager/data/repositories/category_repository.dart';
import 'package:expense_manager/data/repositories/recurring_repository.dart';
import 'package:expense_manager/data/repositories/settings_repository.dart';
import 'package:expense_manager/data/repositories/transaction_repository.dart';
import 'package:expense_manager/data/repositories/wallet_budget_repositories.dart';
import 'package:expense_manager/domain/calculations.dart';
import 'package:expense_manager/domain/period.dart';
import 'package:expense_manager/services/backup.dart';
import 'package:expense_manager/services/export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepository txs;
  late CategoryRepository cats;
  late RecurringRepository rules;

  // The backup test opens a second in-memory database on purpose.
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() {
    db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    txs = TransactionRepository(db);
    cats = CategoryRepository(db);
    rules = RecurringRepository(db);
  });
  tearDown(() => db.close());

  Future<CategoryRow> cat(String name) async => (await cats.all()).firstWhere((c) => c.name == name);
  Future<int> wallet() async => (await db.select(db.wallets).get()).first.id;

  test('seeds 17 categories (10 expense, 7 income) and 4 wallets', () async {
    final all = await cats.all();
    expect(all.where((c) => c.type == typeExpense).length, 10);
    expect(all.where((c) => c.type == typeIncome).length, 7);
    expect(all.where((c) => c.isLocked).map((c) => c.name).toSet(), {'Other', 'Other income'});
    expect((await db.select(db.wallets).get()).map((w) => w.name), ['Cash', 'Bank', 'Card', 'e-Wallet']);
    expect(await db.select(db.transactions).get(), isEmpty);
  });

  test('category type must match record type', () async {
    final salary = await cat('Salary');
    expect(
      () async => txs.add(
          type: typeExpense, amountCents: 100, categoryId: salary.id, walletId: await wallet(), occurredAt: DateTime.now()),
      throwsArgumentError,
    );
  });

  test('range query is half-open and newest first', () async {
    final g = await cat('Groceries');
    final w = await wallet();
    await txs.add(type: typeExpense, amountCents: 1, categoryId: g.id, walletId: w, occurredAt: DateTime(2026, 11, 1, 23, 59));
    await txs.add(type: typeExpense, amountCents: 2, categoryId: g.id, walletId: w, occurredAt: DateTime(2026, 11, 2));
    await txs.add(type: typeExpense, amountCents: 3, categoryId: g.id, walletId: w, occurredAt: DateTime(2026, 10, 26));
    final week = await txs.watchRange(periodRange(PeriodKind.week, DateTime(2026, 10, 28))).first;
    expect(week.map((r) => r.amountCents), [1, 3]);
  });

  test('deleting a category moves its records; no orphans', () async {
    final g = await cat('Groceries');
    final f = await cat('Food & dining');
    final w = await wallet();
    await txs.add(type: typeExpense, amountCents: 225000, categoryId: g.id, walletId: w, occurredAt: DateTime.now());
    expect(() => cats.delete(g.id), throwsStateError);
    await cats.delete(g.id, moveToId: f.id);
    final rows = await txs.all();
    expect(rows.single.categoryId, f.id);
    expect(() async => cats.delete((await cat('Other')).id, moveToId: f.id), throwsStateError);
  });

  test('monthly rule on the 31st creates a record on 30 November', () async {
    final rent = await cat('Rent & housing');
    await rules.createFromRecord(
        type: typeExpense, amountCents: 5000000, categoryId: rent.id, walletId: await wallet(), firstAt: DateTime(2026, 10, 31, 9));
    expect(await rules.runDue(DateTime(2026, 11, 29)), 0);
    expect(await rules.runDue(DateTime(2026, 11, 30, 10)), 1);
    expect((await txs.all()).single.occurredAt, DateTime(2026, 11, 30, 9));
    expect(await rules.runDue(DateTime(2027, 1, 31, 10)), 2); // 31 Dec and 31 Jan
    expect((await txs.all()).map((r) => r.occurredAt.day), [30, 31, 31]);
  });

  test('budget setLimit keeps one overall budget', () async {
    final budgets = BudgetRepository(db);
    await budgets.setLimit(null, 100);
    await budgets.setLimit(null, 200);
    final all = await budgets.all();
    expect(all.single.limitCents, 200);
  });

  test('backup then restore gives identical data', () async {
    final g = await cat('Groceries');
    await txs.add(
        type: typeExpense,
        amountCents: 225050,
        categoryId: g.id,
        walletId: await wallet(),
        occurredAt: DateTime(2026, 10, 28, 13, 15),
        note: 'Supermarket, "weekly"');
    await BudgetRepository(db).setLimit(g.id, 3000000);
    final before = await txs.all();
    final bytes = await createBackup(db, const AppSettings(profileName: 'Test'));

    final fresh = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
    final contents = readBackup(bytes);
    expect(contents.settings.profileName, 'Test');
    await restoreBackup(fresh, contents);
    final after = await TransactionRepository(fresh).all();
    expect(after.map((r) => r.toJson()), before.map((r) => r.toJson()));
    expect((await BudgetRepository(fresh).all()).single.limitCents, 3000000);
    await fresh.close();
  });

  test('CSV export format', () async {
    final g = await cat('Groceries');
    await txs.add(
        type: typeExpense,
        amountCents: 225000,
        categoryId: g.id,
        walletId: await wallet(),
        occurredAt: DateTime(2026, 10, 28, 13, 15),
        note: 'Supermarket run');
    final csv = recordsToCsv(
      await txs.all(),
      {for (final c in await cats.all()) c.id: c},
      {for (final w in await db.select(db.wallets).get()) w.id: w},
    );
    expect(csv.split('\r\n')[0], 'date,time,type,category,amount,wallet,note');
    expect(csv.split('\r\n')[1], '2026-10-28,13:15,expense,Groceries,2250.00,Cash,Supermarket run');
  });
}
