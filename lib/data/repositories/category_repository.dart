import 'package:drift/drift.dart';

import '../database.dart';

class CategoryRepository {
  final AppDatabase db;
  CategoryRepository(this.db);

  Stream<List<CategoryRow>> watchAll() => (db.select(db.categories)
        ..orderBy([
          (c) => OrderingTerm.asc(c.type),
          (c) => OrderingTerm.asc(c.sortOrder),
          (c) => OrderingTerm.asc(c.id),
        ]))
      .watch();

  Future<List<CategoryRow>> all() => db.select(db.categories).get();

  Future<bool> nameTaken(String type, String name, {int? exceptId}) async {
    final rows = await (db.select(db.categories)..where((c) => c.type.equals(type))).get();
    final n = name.trim().toLowerCase();
    return rows.any((c) => c.id != exceptId && c.name.trim().toLowerCase() == n);
  }

  Future<int> add({
    required String type,
    required String name,
    required String icon,
    required String colorBg,
    required String colorFg,
  }) async {
    if (await nameTaken(type, name)) {
      throw ArgumentError('A category with this name already exists');
    }
    final maxOrder = db.categories.sortOrder.max();
    final q = db.selectOnly(db.categories)
      ..addColumns([maxOrder])
      ..where(db.categories.type.equals(type));
    final next = ((await q.getSingle()).read(maxOrder) ?? -1) + 1;
    return db.into(db.categories).insert(CategoriesCompanion.insert(
          type: type,
          name: name.trim(),
          icon: icon,
          colorBg: colorBg,
          colorFg: colorFg,
          sortOrder: Value(next),
        ));
  }

  Future<void> edit(int id,
      {required String name,
      required String icon,
      required String colorBg,
      required String colorFg}) async {
    final row = await (db.select(db.categories)..where((c) => c.id.equals(id))).getSingle();
    if (await nameTaken(row.type, name, exceptId: id)) {
      throw ArgumentError('A category with this name already exists');
    }
    await (db.update(db.categories)..where((c) => c.id.equals(id))).write(
        CategoriesCompanion(
            name: Value(name.trim()),
            icon: Value(icon),
            colorBg: Value(colorBg),
            colorFg: Value(colorFg)));
  }

  /// Saves a new order for the given ids (FR-35).
  Future<void> reorder(List<int> ids) => db.transaction(() async {
        for (var i = 0; i < ids.length; i++) {
          await (db.update(db.categories)..where((c) => c.id.equals(ids[i])))
              .write(CategoriesCompanion(sortOrder: Value(i)));
        }
      });

  /// Deletes a category (FR-36). Its records and recurring rules move to
  /// [moveToId]; its budget is removed. Locked "Other" categories cannot be deleted.
  Future<void> delete(int id, {int? moveToId}) => db.transaction(() async {
        final row =
            await (db.select(db.categories)..where((c) => c.id.equals(id))).getSingle();
        if (row.isLocked) throw StateError('This category cannot be deleted');
        if (moveToId != null) {
          final target = await (db.select(db.categories)
                ..where((c) => c.id.equals(moveToId)))
              .getSingle();
          if (target.type != row.type) {
            throw ArgumentError('Records can only move to a ${row.type} category');
          }
          await (db.update(db.transactions)..where((t) => t.categoryId.equals(id)))
              .write(TransactionsCompanion(categoryId: Value(moveToId)));
          await (db.update(db.recurringRules)..where((t) => t.categoryId.equals(id)))
              .write(RecurringRulesCompanion(categoryId: Value(moveToId)));
        } else {
          final count = db.transactions.id.count();
          final q = db.selectOnly(db.transactions)
            ..addColumns([count])
            ..where(db.transactions.categoryId.equals(id));
          if (((await q.getSingle()).read(count) ?? 0) > 0) {
            throw StateError('Choose where to move this category\'s records');
          }
          await (db.delete(db.recurringRules)..where((t) => t.categoryId.equals(id))).go();
        }
        await (db.delete(db.budgets)..where((b) => b.categoryId.equals(id))).go();
        await (db.delete(db.categories)..where((c) => c.id.equals(id))).go();
      });
}
