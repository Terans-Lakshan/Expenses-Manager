import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'default_data.dart';

part 'database.g.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'expense' | 'income'
  TextColumn get name => text().withLength(min: 1, max: 30)();
  TextColumn get icon => text()();
  TextColumn get colorBg => text()();
  TextColumn get colorFg => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
}

@DataClassName('WalletRow')
class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  TextColumn get icon => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('RecurringRuleRow')
class RecurringRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  IntColumn get amountCents => integer()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get walletId => integer().references(Wallets, #id)();
  TextColumn get note => text().withLength(max: 200).nullable()();
  TextColumn get frequency => text().withDefault(const Constant('monthly'))();
  IntColumn get dayOfMonth => integer()();
  DateTimeColumn get nextRunAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('TxRow')
@TableIndex(name: 'idx_tx_occurred', columns: {#occurredAt})
@TableIndex(name: 'idx_tx_cat_occurred', columns: {#categoryId, #occurredAt})
@TableIndex(name: 'idx_tx_type_occurred', columns: {#type, #occurredAt})
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'expense' | 'income'
  IntColumn get amountCents => integer()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get walletId => integer().references(Wallets, #id)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get note => text().withLength(max: 200).nullable()();
  TextColumn get receiptPath => text().nullable()();
  IntColumn get recurringRuleId =>
      integer().nullable().references(RecurringRules, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('BudgetRow')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)(); // null = overall
  TextColumn get period => text().withDefault(const Constant('month'))();
  IntColumn get limitCents => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
    tables: [Categories, Wallets, RecurringRules, Transactions, Budgets])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'expense_manager',
              // App-private storage (not the user's Documents folder on desktop).
              native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
            ));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaults();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Seeds the 17 default categories and 4 wallets (FR-37). No sample records.
  Future<void> seedDefaults() async {
    await batch((b) {
      for (final c in defaultCategories) {
        b.insert(
          categories,
          CategoriesCompanion.insert(
            type: c.type,
            name: c.name,
            icon: c.icon,
            colorBg: c.bg,
            colorFg: c.fg,
            sortOrder: Value(c.order),
            isDefault: const Value(true),
            isLocked: Value(c.locked),
          ),
        );
      }
      for (var i = 0; i < defaultWallets.length; i++) {
        b.insert(
          wallets,
          WalletsCompanion.insert(
            name: defaultWallets[i].name,
            icon: defaultWallets[i].icon,
            sortOrder: Value(i),
          ),
        );
      }
    });
  }
}
