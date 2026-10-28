import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/period.dart';
import '../../services/export.dart';
import '../../services/file_output.dart';
import '../../widgets/charts.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  /// One query covers every chart for the period: for Month it spans the last
  /// 6 months (bars) which also includes last month (pace line).
  static DateRange dataRange(PeriodKind kind, DateTime anchor, int weekStart) {
    final r = periodRange(kind, anchor, weekStart: weekStart);
    if (kind == PeriodKind.month) return DateRange(DateTime(r.start.year, r.start.month - 5), r.end);
    return r;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final period = ref.watch(reportsPeriodProvider);
    final weekStart = ref.watch(weekStartProvider);
    final money = ref.watch(moneyProvider);
    final cats = ref.watch(categoryMapProvider);
    final range = periodRange(period.kind, period.anchor, weekStart: weekStart);
    final async = ref.watch(recordsInRangeProvider(dataRange(period.kind, period.anchor, weekStart)));
    final all = async.value ?? const <TxRow>[];
    final now = DateTime.now();

    final inPeriod = inRange(all, range).toList();
    final totals = totalsOf(inPeriod);
    final saved = savedPercent(totals);
    final buckets = barBuckets(all, period.kind, period.anchor, now, weekStart: weekStart);
    final breakdown = categoryBreakdown(inPeriod);
    final slices = [
      for (var i = 0; i < breakdown.length; i++)
        (
          breakdown[i].categoryId == null ? 'Other' : (cats[breakdown[i].categoryId]?.name ?? 'Deleted'),
          breakdown[i].cents,
          breakdown[i].percent,
          p.donut[i % p.donut.length],
        ),
    ];
    final breakdownMax = breakdown.isEmpty ? 1 : breakdown.first.cents;

    Future<void> export() async {
      final bytes = await reportToPdf(
        title: 'Report · ${period.kind.label}',
        rangeLabel: periodLabel(period.kind, range),
        totals: totals,
        buckets: buckets.where((b) => !b.isFuture).toList(),
        breakdown: [for (final s in slices) (s.$1, s.$2, s.$3)],
        money: money,
      );
      if (!context.mounted) return;
      final msg = await deliverFile(context,
          fileName: 'expense-report-${DateFormat('yyyy-MM-dd').format(range.start)}.pdf',
          bytes: bytes,
          mimeType: 'application/pdf',
          subject: 'Expense report');
      if (msg != null && context.mounted) showSnack(context, msg);
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: screenPadding.copyWith(top: 20),
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Semantics(header: true, child: Text('Reports', style: T.title(context))),
                const SizedBox(height: 2),
                Text(periodLabel(period.kind, range), style: T.secondary(context, size: 13)),
              ]),
            ),
            LabelIconButton(icon: 'download', label: 'Export', semanticLabel: 'Export report as PDF', onTap: export),
          ]),
          const SizedBox(height: 16),
          SegmentedTabs<PeriodKind>(
            values: const [PeriodKind.week, PeriodKind.month, PeriodKind.year],
            selected: period.kind,
            label: (k) => k.label,
            height: 38,
            onChanged: ref.read(reportsPeriodProvider.notifier).setKind,
          ),
          const SizedBox(height: 4),
          Row(children: [
            IconButton(
                tooltip: 'Previous period',
                onPressed: () => ref.read(reportsPeriodProvider.notifier).step(-1),
                icon: AppIcon('chevron-left', color: p.text, strokeWidth: 2.2)),
            Expanded(
              child: Text(periodShortLabel(period.kind, range, now),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.text)),
            ),
            IconButton(
                tooltip: 'Next period',
                onPressed: () => ref.read(reportsPeriodProvider.notifier).step(1),
                icon: AppIcon('chevron-right', color: p.text, strokeWidth: 2.2)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: _tile(context, 'Income', money.short(totals.incomeCents), p.income)),
            const SizedBox(width: 8),
            Expanded(child: _tile(context, 'Expenses', money.short(totals.expenseCents), p.expense)),
            const SizedBox(width: 8),
            Expanded(
              child: saved == null
                  ? _tile(context, 'Overspent', money.short(totals.netCents.abs()), p.expense)
                  : _tile(context, 'Saved', '$saved%', p.text),
            ),
          ]),
          const SizedBox(height: 16),
          SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text('Income vs expenses', style: T.section(context, size: 15))),
                _legend(context, AppColors.income, 'Income'),
                const SizedBox(width: 12),
                _legend(context, AppColors.expenseBar, 'Expenses'),
              ]),
              const SizedBox(height: 14),
              IncomeExpenseBarChart(buckets: buckets, money: money),
            ]),
          ),
          const SizedBox(height: 16),
          SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Where the money went', style: T.section(context, size: 15)),
              const SizedBox(height: 14),
              Row(children: [
                SpendingDonut(slices: slices, totalCents: totals.expenseCents, money: money),
                const SizedBox(width: 16),
                Expanded(
                  child: slices.isEmpty
                      ? Text('No expenses in this period.', style: T.secondary(context, size: 13))
                      : Column(children: [
                          for (final s in slices)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(children: [
                                Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(color: s.$4, borderRadius: BorderRadius.circular(3))),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(s.$1,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.text)),
                                ),
                                Text('${s.$3}%',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.muted)),
                              ]),
                            ),
                        ]),
                ),
              ]),
              if (breakdown.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(height: 1, color: p.divider),
                for (var i = 0; i < breakdown.length; i++)
                  InkWell(
                    onTap: () {
                      ref
                          .read(recordsFilterProvider.notifier)
                          .showCategory(breakdown[i].categoryId, period.kind, period.anchor);
                      context.go('/records');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: i < breakdown.length - 1 ? Border(bottom: BorderSide(color: p.divider)) : null),
                      child: Row(children: [
                        Builder(builder: (context) {
                          final c = breakdown[i].categoryId == null ? null : cats[breakdown[i].categoryId];
                          return CatIcon(
                              icon: c?.icon ?? 'more-horizontal',
                              bg: c?.colorBg ?? '#ECEEF1',
                              fg: c?.colorFg ?? '#4A5361',
                              size: 36);
                        }),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(slices[i].$1, style: T.row(context).copyWith(fontSize: 14)),
                            const SizedBox(height: 5),
                            ProgressBar(
                                fraction: breakdown[i].cents / breakdownMax, color: slices[i].$4, height: 6),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Text(money.format(breakdown[i].cents), style: T.number(14, color: p.text)),
                      ]),
                    ),
                  ),
              ],
            ]),
          ),
          if (period.kind == PeriodKind.month) ...[
            const SizedBox(height: 16),
            _PaceCard(all: all, anchor: period.anchor, now: now),
          ],
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String label, String value, Color color) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: context.pal.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.pal.muted)),
          const SizedBox(height: 3),
          FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: T.number(14, color: color))),
        ]),
      );

  Widget _legend(BuildContext context, Color c, String label) => Row(children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.pal.muted)),
      ]);
}

class _PaceCard extends ConsumerWidget {
  final List<TxRow> all;
  final DateTime anchor, now;
  const _PaceCard({required this.all, required this.anchor, required this.now});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final money = ref.watch(moneyProvider);
    final thisStart = DateTime(anchor.year, anchor.month);
    final lastStart = DateTime(anchor.year, anchor.month - 1);
    final isCurrent = thisStart.year == now.year && thisStart.month == now.month;
    final isFuture = thisStart.isAfter(now);
    final dim = daysInMonth(thisStart.year, thisStart.month);
    final upTo = isFuture ? 0 : (isCurrent ? now.day : dim);
    final thisCum = cumulativeDailySpend(all, thisStart, upToDay: upTo);
    final lastCum = cumulativeDailySpend(all, lastStart);
    final thisName = DateFormat('MMMM').format(thisStart);
    final lastName = DateFormat('MMMM').format(lastStart);

    String subtitle;
    if (thisCum.isEmpty) {
      subtitle = 'No spending yet this month';
    } else {
      final day = thisCum.length;
      final lastAt = lastCum.isEmpty ? 0 : lastCum[(day - 1).clamp(0, lastCum.length - 1)];
      final diff = thisCum.last - lastAt;
      final when = isCurrent ? 'this point in $lastName' : 'all of $lastName';
      subtitle = diff == 0
          ? 'Same as $when'
          : '${money.format(diff.abs())} ${diff < 0 ? 'less' : 'more'} than $when';
    }

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Spending pace', style: T.section(context, size: 15)),
        const SizedBox(height: 2),
        Text(subtitle, style: T.secondary(context, size: 13)),
        const SizedBox(height: 10),
        SpendingPaceChart(thisMonth: thisCum, lastMonth: lastCum, daysInThisMonth: dim, money: money),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (final l in ['1 ${DateFormat('MMM').format(thisStart)}', '10', '20', '$dim'])
            Text(l, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.muted)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Container(width: 16, height: 3, decoration: BoxDecoration(color: p.expense, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(thisName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.muted)),
          const SizedBox(width: 14),
          SizedBox(
            width: 16,
            child: Row(children: [
              for (var i = 0; i < 3; i++) ...[
                Container(width: 4, height: 2, color: const Color(0xFF8A94A3)),
                if (i < 2) const SizedBox(width: 2),
              ],
            ]),
          ),
          const SizedBox(width: 6),
          Text(lastName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.muted)),
        ]),
      ]),
    );
  }
}
