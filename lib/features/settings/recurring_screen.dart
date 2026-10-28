import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/money.dart';
import '../../domain/period.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

/// Recurring records (FR-45): pause, edit, delete.
class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final rules = ref.watch(recurringRulesProvider).value ?? const <RecurringRuleRow>[];
    final cats = ref.watch(categoryMapProvider);
    final money = ref.watch(moneyProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(padding: screenPadding, children: [
          const BackHeader(title: 'Recurring records'),
          const SizedBox(height: 16),
          if (rules.isEmpty)
            const EmptyCard('No recurring records.\nTurn on "Repeat every month" when adding rent, bills or salary.')
          else
            Container(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                for (var i = 0; i < rules.length; i++)
                  Builder(builder: (context) {
                    final r = rules[i];
                    final c = cats[r.categoryId];
                    final income = r.type == typeIncome;
                    return InkWell(
                      onTap: () => _edit(context, ref, r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: i < rules.length - 1 ? Border(bottom: BorderSide(color: p.divider)) : null),
                        child: Row(children: [
                          Opacity(
                            opacity: r.isActive ? 1 : 0.45,
                            child: CatIcon(
                                icon: c?.icon ?? 'more-horizontal',
                                bg: c?.colorBg ?? '#ECEEF1',
                                fg: c?.colorFg ?? '#4A5361',
                                size: 40),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(r.note?.isNotEmpty == true ? r.note! : (c?.name ?? 'Record'),
                                  maxLines: 1, overflow: TextOverflow.ellipsis, style: T.row(context)),
                              Text(
                                r.isActive
                                    ? '${money.signed(r.amountCents, income: income)} · day ${r.dayOfMonth} · next ${DateFormat('d MMM').format(r.nextRunAt)}'
                                    : 'Paused · ${money.signed(r.amountCents, income: income)}',
                                style: T.secondary(context),
                              ),
                            ]),
                          ),
                          Switch(
                            value: r.isActive,
                            onChanged: (v) => _setActive(ref, r, v),
                          ),
                        ]),
                      ),
                    );
                  }),
              ]),
            ),
          const SizedBox(height: 12),
          Text('Paused rules skip their months; resuming starts from the next due date.',
              textAlign: TextAlign.center, style: T.secondary(context, size: 13)),
        ]),
      ),
    );
  }

  Future<void> _setActive(WidgetRef ref, RecurringRuleRow r, bool active) async {
    final repo = ref.read(recurringRepoProvider);
    if (active) {
      // Don't back-fill the months that were paused.
      var next = r.nextRunAt;
      final now = DateTime.now();
      while (!next.isAfter(now)) {
        next = addMonthsClamped(next, 1, dayOfMonth: r.dayOfMonth);
      }
      await repo.edit(r.copyWith(isActive: true, nextRunAt: next));
    } else {
      await repo.setActive(r.id, false);
    }
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, RecurringRuleRow r) async {
    final amount = TextEditingController(text: centsToInput(r.amountCents));
    final note = TextEditingController(text: r.note ?? '');
    var day = r.dayOfMonth;
    String? error;
    final p = context.pal;
    final symbol = ref.read(moneyProvider).symbol;
    final result = await showDialog<String>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (d, setState) => AlertDialog(
          title: Text('Edit recurring record', style: T.section(d)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: InputDecoration(labelText: 'Amount', prefixText: '$symbol ', errorText: error),
            ),
            const SizedBox(height: 12),
            TextField(controller: note, maxLength: 200, decoration: const InputDecoration(labelText: 'Note')),
            Row(children: [
              Expanded(child: Text('Day of month', style: T.row(d).copyWith(fontSize: 14))),
              DropdownButton<int>(
                value: day,
                items: [for (var i = 1; i <= 31; i++) DropdownMenuItem(value: i, child: Text('$i'))],
                onChanged: (v) => setState(() => day = v ?? day),
              ),
            ]),
          ]),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: p.expense),
              onPressed: () => Navigator.pop(d, 'delete'),
              child: const Text('Delete'),
            ),
            TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final parsed = parseAmount(amount.text);
                if (parsed.cents == null) {
                  setState(() => error = parsed.error);
                  return;
                }
                Navigator.pop(d, 'save');
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    final repo = ref.read(recurringRepoProvider);
    if (result == 'delete') {
      if (!context.mounted) return;
      final ok = await confirmDialog(context,
          title: 'Delete this recurring record?', message: 'Records it already created are kept.');
      if (ok) await repo.delete(r.id);
    } else if (result == 'save') {
      final cents = parseAmount(amount.text).cents!;
      // Move the next run to the new day within the same month.
      final next = DateTime(r.nextRunAt.year, r.nextRunAt.month,
          day.clamp(1, daysInMonth(r.nextRunAt.year, r.nextRunAt.month)), r.nextRunAt.hour, r.nextRunAt.minute);
      await repo.edit(r.copyWith(
        amountCents: cents,
        note: Value(note.text.trim().isEmpty ? null : note.text.trim()),
        dayOfMonth: day,
        nextRunAt: next,
      ));
    }
  }
}
