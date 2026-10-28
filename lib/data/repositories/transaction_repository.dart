import 'package:drift/drift.dart';

import '../../domain/period.dart';
import '../database.dart';

class TransactionRepository {
  final AppDatabase db;
  TransactionRepository(this.db);

  /// Records in `[start, end)`, newest first. Emits again whenever data changes.
  Stream<List<TxRow>> watchRange(DateRange r) {
    final q = db.select(db.transactions)
      ..where((t) =>
          t.occurredAt.isBiggerOrEqualValue(r.start) &
          t.occurredAt.isSmallerThanValue(r.end))
      ..orderBy([
        (t) => OrderingTerm.desc(t.occurredAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return q.watch();
  }

  Future<List<TxRow>> range(DateRange r) {
    final q = db.select(db.transactions)
      ..where((t) =>
          t.occurredAt.isBiggerOrEqualValue(r.start) &
          t.occurredAt.isSmallerThanValue(r.end))
      ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]);
    return q.get();
  }

  Future<List<TxRow>> all() => (db.select(db.transactions)
        ..orderBy([(t) => OrderingTerm.asc(t.occurredAt)]))
      .get();

  Future<TxRow?> byId(int id) =>
      (db.select(db.transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<TxRow?> watchById(int id) =>
      (db.select(db.transactions)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<int> add({
    required String type,
    required int amountCents,
    required int categoryId,
    required int walletId,
    required DateTime occurredAt,
    String? note,
    String? receiptPath,
    int? recurringRuleId,
  }) async {
    await _checkCategoryType(categoryId, type);
    return db.into(db.transactions).insert(TransactionsCompanion.insert(
          type: type,
          amountCents: amountCents,
          categoryId: categoryId,
          walletId: walletId,
          occurredAt: occurredAt,
          note: Value(note),
          receiptPath: Value(receiptPath),
          recurringRuleId: Value(recurringRuleId),
        ));
  }

  Future<void> update(TxRow row) async {
    await _checkCategoryType(row.categoryId, row.type);
    await db.update(db.transactions).replace(row.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> delete(int id) =>
      (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();

  /// Puts a deleted record back with its original id (Undo).
  Future<void> restore(TxRow row) =>
      db.into(db.transactions).insert(row, mode: InsertMode.insertOrReplace);

  /// Records per category in `[start, end)`.
  Stream<Map<int, int>> watchCountsByCategory(DateRange r) {
    final count = db.transactions.id.count();
    final q = db.selectOnly(db.transactions)
      ..addColumns([db.transactions.categoryId, count])
      ..where(db.transactions.occurredAt.isBiggerOrEqualValue(r.start) &
          db.transactions.occurredAt.isSmallerThanValue(r.end))
      ..groupBy([db.transactions.categoryId]);
    return q.watch().map((rows) => {
          for (final row in rows)
            row.read(db.transactions.categoryId)!: row.read(count) ?? 0,
        });
  }

  Future<int> countForCategory(int categoryId) async {
    final count = db.transactions.id.count();
    final q = db.selectOnly(db.transactions)
      ..addColumns([count])
      ..where(db.transactions.categoryId.equals(categoryId));
    return (await q.getSingle()).read(count) ?? 0;
  }

  Future<void> _checkCategoryType(int categoryId, String type) async {
    final c = await (db.select(db.categories)..where((t) => t.id.equals(categoryId)))
        .getSingleOrNull();
    if (c == null) throw ArgumentError('Category $categoryId does not exist');
    if (c.type != type) {
      throw ArgumentError('Category type ${c.type} does not match record type $type');
    }
  }
}
