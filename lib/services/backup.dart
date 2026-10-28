import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';

import '../data/database.dart';
import '../data/repositories/settings_repository.dart';

const backupFormat = 'expense-manager-backup';
const backupVersion = 1;

/// Serialises every table plus settings into one JSON document (FR-47).
Future<Uint8List> createBackup(AppDatabase db, AppSettings settings) async {
  final data = {
    'format': backupFormat,
    'version': backupVersion,
    'schema': db.schemaVersion,
    'created_at': DateTime.now().toIso8601String(),
    'settings': settings.toJson(),
    'categories': [for (final r in await db.select(db.categories).get()) r.toJson()],
    'wallets': [for (final r in await db.select(db.wallets).get()) r.toJson()],
    'recurring_rules': [for (final r in await db.select(db.recurringRules).get()) r.toJson()],
    'transactions': [for (final r in await db.select(db.transactions).get()) r.toJson()],
    'budgets': [for (final r in await db.select(db.budgets).get()) r.toJson()],
  };
  return Uint8List.fromList(utf8.encode(const JsonEncoder.withIndent(' ').convert(data)));
}

class BackupContents {
  final AppSettings settings;
  final int records;
  final Map<String, dynamic> raw;
  BackupContents(this.settings, this.records, this.raw);
}

/// Parses and validates a backup file. Throws [FormatException] if invalid.
BackupContents readBackup(Uint8List bytes) {
  final Object? decoded;
  try {
    decoded = jsonDecode(utf8.decode(bytes));
  } catch (_) {
    throw const FormatException('This file is not an Expense Manager backup.');
  }
  if (decoded is! Map<String, dynamic> || decoded['format'] != backupFormat) {
    throw const FormatException('This file is not an Expense Manager backup.');
  }
  if ((decoded['version'] as num? ?? 0) > backupVersion) {
    throw const FormatException('This backup was made by a newer version of the app.');
  }
  for (final k in ['categories', 'wallets', 'recurring_rules', 'transactions', 'budgets']) {
    if (decoded[k] is! List) throw FormatException('Backup is missing "$k".');
  }
  final settings = AppSettings.fromJson(
      (decoded['settings'] as Map?)?.cast<String, Object?>() ?? const {});
  return BackupContents(settings, (decoded['transactions'] as List).length, decoded);
}

/// Replaces all data with the backup in one transaction; nothing changes on error.
Future<void> restoreBackup(AppDatabase db, BackupContents b) => db.transaction(() async {
      List<Map<String, dynamic>> rows(String k) =>
          (b.raw[k] as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();

      await db.delete(db.transactions).go();
      await db.delete(db.budgets).go();
      await db.delete(db.recurringRules).go();
      await db.delete(db.categories).go();
      await db.delete(db.wallets).go();

      await db.batch((batch) {
        batch.insertAll(db.categories, rows('categories').map(CategoryRow.fromJson));
        batch.insertAll(db.wallets, rows('wallets').map(WalletRow.fromJson));
        batch.insertAll(db.recurringRules, rows('recurring_rules').map(RecurringRuleRow.fromJson));
        batch.insertAll(db.transactions, rows('transactions').map(TxRow.fromJson));
        batch.insertAll(db.budgets, rows('budgets').map(BudgetRow.fromJson));
      });
    });
