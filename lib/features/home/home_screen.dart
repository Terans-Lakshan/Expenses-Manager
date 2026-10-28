import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/period.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final period = ref.watch(homePeriodProvider);
    final range = ref.watch(homeRangeProvider);
    final records = ref.watch(recordsInRangeProvider(range));
    final list = records.value ?? const <TxRow>[];
    final totals = totalsOf(list);
    final now = DateTime.now();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: screenPadding.copyWith(top: 20),
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(DateFormat('EEEE, d MMMM').format(now), style: T.secondary(context, size: 13)),
                const SizedBox(height: 2),
                Semantics(header: true, child: Text('Overview', style: T.title(context))),
              ]),
            ),
            SquareIconButton(
                icon: 'search',
                tooltip: 'Search records',
                onTap: () => context.go('/records?search=1')),
            const SizedBox(width: 8),
            SquareIconButton(icon: 'bell', tooltip: 'Reminders', onTap: () => context.go('/more')),
          ]),
          const SizedBox(height: 18),
          SegmentedTabs<PeriodKind>(
            values: const [PeriodKind.today, PeriodKind.week, PeriodKind.month, PeriodKind.year],
            selected: period.kind,
            label: (k) => k.label,
            onChanged: ref.read(homePeriodProvider.notifier).setKind,
          ),
          const SizedBox(height: 6),
          _PeriodStepper(
            label: periodLabel(period.kind, range),
            onPrev: () => ref.read(homePeriodProvider.notifier).step(-1),
            onNext: () => ref.read(homePeriodProvider.notifier).step(1),
          ),
          const SizedBox(height: 6),
          _BalanceCard(totals: totals, label: periodShortLabel(period.kind, range, now)),
          const SizedBox(height: 18),
          _BudgetCard(kind: period.kind, range: range, spentCents: totals.expenseCents),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: Semantics(header: true, child: Text('Transactions', style: T.section(context)))),
            TextButton(
              onPressed: () {
                ref.read(recordsFilterProvider.notifier).showPeriod(period.kind, period.anchor);
                context.go('/records');
              },
              child: const Text('See all'),
            ),
          ]),
          const SizedBox(height: 4),
          if (records.isLoading && list.isEmpty)
            const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
          else if (list.isEmpty)
            EmptyCard('No records ${_emptySuffix(period.kind, range, now)}.\nTap + to add one.')
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                for (var i = 0; i < list.length && i < 5; i++)
                  RecordTile(
                    record: list[i],
                    showDivider: i < 4 && i < list.length - 1,
                    showDate: period.kind != PeriodKind.today,
                    onTap: () => context.push('/record/${list[i].id}'),
                  ),
              ]),
            ),
        ],
      ),
    );
  }

  String _emptySuffix(PeriodKind kind, DateRange r, DateTime now) {
    if (!r.contains(now)) return 'in this period';
    return switch (kind) {
      PeriodKind.today => 'today',
      PeriodKind.week => 'this week',
      PeriodKind.month => 'this month',
      _ => 'this year',
    };
  }
}

class _PeriodStepper extends StatelessWidget {
  final String label;
  final VoidCallback onPrev, onNext;
  const _PeriodStepper({required this.label, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) => Row(children: [
        IconButton(
          tooltip: 'Previous period',
          onPressed: onPrev,
          icon: AppIcon('chevron-left', color: context.pal.text, strokeWidth: 2.2),
        ),
        Expanded(
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.pal.text)),
        ),
        IconButton(
          tooltip: 'Next period',
          onPressed: onNext,
          icon: AppIcon('chevron-right', color: context.pal.text, strokeWidth: 2.2),
        ),
      ]);
}

class _BalanceCard extends ConsumerWidget {
  final Totals totals;
  final String label;
  const _BalanceCard({required this.totals, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final money = ref.watch(moneyProvider);
    return Semantics(
      container: true,
      label: 'Balance',
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Net balance · $label',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFB7C1D0))),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(money.format(totals.netCents),
                style: T.number(34, weight: FontWeight.w700, color: p.onCard)),
          ),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: _tile(context, 'Income', 'arrow-down', AppColors.incomeOnDark, money.format(totals.incomeCents))),
            const SizedBox(width: 10),
            Expanded(child: _tile(context, 'Expenses', 'arrow-up', AppColors.expenseOnDark, money.format(totals.expenseCents))),
          ]),
        ]),
      ),
    );
  }

  Widget _tile(BuildContext context, String label, String icon, Color color, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: context.pal.cardTile, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AppIcon(icon, size: 14, color: color, strokeWidth: 2.6),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ]),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: T.number(17, color: Colors.white)),
          ),
        ]),
      );
}

class _BudgetCard extends ConsumerWidget {
  final PeriodKind kind;
  final DateRange range;
  final int spentCents;
  const _BudgetCard({required this.kind, required this.range, required this.spentCents});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final money = ref.watch(moneyProvider);
    final budgets = ref.watch(budgetsProvider).value ?? const <BudgetRow>[];
    final overall = budgets.where((b) => b.categoryId == null).firstOrNull;
    if (overall == null) {
      return SurfaceCard(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        onTap: () => context.push('/budgets'),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Set a monthly budget', style: T.row(context).copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text('Get a warning before you run out.', style: T.secondary(context, size: 13)),
            ]),
          ),
          AppIcon('chevron-right', size: 18, color: p.muted),
        ]),
      );
    }
    final alertAt = ref.watch(settingsProvider.select((s) => s.budgetAlertAt));
    final limit = scaledBudgetCents(overall.limitCents, kind, range);
    final status = BudgetStatus(spentCents, limit, alertAt: alertAt);
    final color = switch (status.state) {
      BudgetState.normal => p.income,
      BudgetState.warning => p.warning,
      _ => p.expense,
    };
    final title = switch (kind) {
      PeriodKind.today => 'Daily budget',
      PeriodKind.week => 'Weekly budget',
      PeriodKind.year => 'Yearly budget',
      _ => 'Monthly budget',
    };
    final now = DateTime.now();
    String note;
    if (status.state == BudgetState.over) {
      note = 'Over by ${money.format(status.overByCents)}';
    } else {
      note = '${money.format(status.remainingCents)} left of ${money.format(limit)}';
      if (kind == PeriodKind.month && range.contains(now)) {
        final d = daysLeftInMonth(now);
        note += ' · $d ${d == 1 ? 'day' : 'days'} left';
      }
    }
    return SurfaceCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => context.push('/budgets'),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(title, style: T.row(context).copyWith(fontSize: 14))),
          Text('${status.percent.round()}% used',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.muted)),
        ]),
        const SizedBox(height: 10),
        ProgressBar(fraction: status.barFraction, color: color),
        const SizedBox(height: 10),
        Text(note,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: status.state == BudgetState.over ? p.expense : p.muted)),
      ]),
    );
  }
}
