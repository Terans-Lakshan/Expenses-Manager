import 'package:drift/drift.dart';

import '../database.dart';

class WalletRepository {
  final AppDatabase db;
  WalletRepository(this.db);

  Stream<List<WalletRow>> watchAll() => (db.select(db.wallets)
        ..orderBy([(w) => OrderingTerm.asc(w.sortOrder), (w) => OrderingTerm.asc(w.id)]))
      .watch();

  Future<List<WalletRow>> all() => db.select(db.wallets).get();

  Future<int> add(String name, String icon) async {
    final maxOrder = db.wallets.sortOrder.max();
    final q = db.selectOnly(db.wallets)..addColumns([maxOrder]);
    final next = ((await q.getSingle()).read(maxOrder) ?? -1) + 1;
    return db.into(db.wallets).insert(
        WalletsCompanion.insert(name: name.trim(), icon: icon, sortOrder: Value(next)));
  }

  Future<void> edit(int id, {required String name, required String icon}) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id)))
          .write(WalletsCompanion(name: Value(name.trim()), icon: Value(icon)));

  Future<void> setArchived(int id, bool archived) =>
      (db.update(db.wallets)..where((w) => w.id.equals(id)))
          .write(WalletsCompanion(isArchived: Value(archived)));

  /// Deletes an unused wallet; wallets with records can only be archived.
  Future<bool> deleteIfUnused(int id) => db.transaction(() async {
        final used = await (db.select(db.transactions)
              ..where((t) => t.walletId.equals(id))
              ..limit(1))
            .get();
        final usedByRule = await (db.select(db.recurringRules)
              ..where((t) => t.walletId.equals(id))
              ..limit(1))
            .get();
        if (used.isNotEmpty || usedByRule.isNotEmpty) return false;
        await (db.delete(db.wallets)..where((w) => w.id.equals(id))).go();
        return true;
      });
}

class BudgetRepository {
  final AppDatabase db;
  BudgetRepository(this.db);

  Stream<List<BudgetRow>> watchAll() =>
      (db.select(db.budgets)..orderBy([(b) => OrderingTerm.asc(b.createdAt)])).watch();

  Future<List<BudgetRow>> all() => db.select(db.budgets).get();

  /// Creates or replaces the budget for [categoryId] (null = overall monthly budget).
  Future<void> setLimit(int? categoryId, int limitCents) => db.transaction(() async {
        final existing = await (db.select(db.budgets)
              ..where((b) => categoryId == null
                  ? b.categoryId.isNull()
                  : b.categoryId.equals(categoryId)))
            .get();
        if (existing.isEmpty) {
          await db.into(db.budgets).insert(BudgetsCompanion.insert(
              categoryId: Value(categoryId), limitCents: limitCents));
        } else {
          await (db.update(db.budgets)..where((b) => b.id.equals(existing.first.id)))
              .write(BudgetsCompanion(limitCents: Value(limitCents)));
          for (final extra in existing.skip(1)) {
            await (db.delete(db.budgets)..where((b) => b.id.equals(extra.id))).go();
          }
        }
      });

  Future<void> delete(int id) => (db.delete(db.budgets)..where((b) => b.id.equals(id))).go();
}
