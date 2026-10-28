import 'package:drift/drift.dart';

import '../../domain/period.dart';
import '../database.dart';

class RecurringRepository {
  final AppDatabase db;
  RecurringRepository(this.db);

  Stream<List<RecurringRuleRow>> watchAll() => (db.select(db.recurringRules)
        ..orderBy([(r) => OrderingTerm.asc(r.dayOfMonth), (r) => OrderingTerm.asc(r.id)]))
      .watch();

  Future<List<RecurringRuleRow>> all() => db.select(db.recurringRules).get();

  /// Creates a monthly rule from a record that was just saved on [firstAt].
  /// The record itself counts as this month's run, so the rule next runs a month later.
  Future<int> createFromRecord({
    required String type,
    required int amountCents,
    required int categoryId,
    required int walletId,
    required DateTime firstAt,
    String? note,
  }) =>
      db.into(db.recurringRules).insert(RecurringRulesCompanion.insert(
            type: type,
            amountCents: amountCents,
            categoryId: categoryId,
            walletId: walletId,
            note: Value(note),
            dayOfMonth: firstAt.day,
            nextRunAt: addMonthsClamped(firstAt, 1),
          ));

  Future<void> edit(RecurringRuleRow rule) => db.update(db.recurringRules).replace(rule);

  Future<void> setActive(int id, bool active) =>
      (db.update(db.recurringRules)..where((r) => r.id.equals(id)))
          .write(RecurringRulesCompanion(isActive: Value(active)));

  /// Deletes the rule; records it already created stay, unlinked.
  Future<void> delete(int id) => db.transaction(() async {
        await (db.update(db.transactions)..where((t) => t.recurringRuleId.equals(id)))
            .write(const TransactionsCompanion(recurringRuleId: Value(null)));
        await (db.delete(db.recurringRules)..where((r) => r.id.equals(id))).go();
      });

  /// Creates every record that is due (next_run_at ≤ now) and moves each rule
  /// forward one month at a time. Returns the number of records created.
  Future<int> runDue(DateTime now) => db.transaction(() async {
        final due = await (db.select(db.recurringRules)
              ..where((r) => r.isActive.equals(true) & r.nextRunAt.isSmallerOrEqualValue(now)))
            .get();
        var created = 0;
        for (final rule in due) {
          var next = rule.nextRunAt;
          while (!next.isAfter(now)) {
            await db.into(db.transactions).insert(TransactionsCompanion.insert(
                  type: rule.type,
                  amountCents: rule.amountCents,
                  categoryId: rule.categoryId,
                  walletId: rule.walletId,
                  occurredAt: next,
                  note: Value(rule.note),
                  recurringRuleId: Value(rule.id),
                ));
            created++;
            next = addMonthsClamped(next, 1, dayOfMonth: rule.dayOfMonth);
          }
          await (db.update(db.recurringRules)..where((r) => r.id.equals(rule.id)))
              .write(RecurringRulesCompanion(nextRunAt: Value(next)));
        }
        return created;
      });
}
