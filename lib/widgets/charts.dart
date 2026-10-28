import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../domain/calculations.dart';
import '../domain/money.dart';

/// Shown in place of an empty chart so the frame keeps its size.
class _NoRecords extends StatelessWidget {
  final double height;
  const _NoRecords(this.height);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: Center(child: Text('No records yet', style: T.secondary(context, size: 13))),
      );
}

/// Grouped bars: income (blue) vs expenses (orange) per bucket.
class IncomeExpenseBarChart extends StatelessWidget {
  final List<BarBucket> buckets;
  final Money money;
  const IncomeExpenseBarChart({super.key, required this.buckets, required this.money});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final maxV = buckets.fold<int>(0, (m, b) => [m, b.incomeCents, b.expenseCents].reduce((a, c) => a > c ? a : c));
    final empty = maxV == 0;
    final top = niceMaxCents(maxV);
    final barW = buckets.length > 7 ? 7.0 : (buckets.length > 6 ? 10.0 : 12.0);
    const chartH = 140.0;

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 34,
        height: chartH,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final v in [top, top ~/ 2, 0])
              Text(Money.axis(v), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.muted)),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(children: [
          SizedBox(
            height: chartH,
            child: empty
                ? DecoratedBox(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.border))),
                    child: const _NoRecords(chartH))
                : BarChart(
                    BarChartData(
                      maxY: top.toDouble(),
                      minY: 0,
                      alignment: BarChartAlignment.spaceAround,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: top / 2,
                        getDrawingHorizontalLine: (_) => FlLine(color: p.divider, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: p.border))),
                      titlesData: const FlTitlesData(show: false),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => p.primary,
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                            '${ri == 0 ? 'Income' : 'Expenses'}\n${money.format(rod.toY.round())}',
                            TextStyle(
                                color: p.onPrimary, fontWeight: FontWeight.w700, fontSize: 12, fontFamily: fontBody),
                          ),
                        ),
                      ),
                      barGroups: [
                        for (var i = 0; i < buckets.length; i++)
                          BarChartGroupData(
                            x: i,
                            barsSpace: 2,
                            barRods: buckets[i].isFuture
                                ? []
                                : [
                                    _rod(buckets[i].incomeCents, AppColors.income, barW),
                                    _rod(buckets[i].expenseCents, AppColors.expenseBar, barW),
                                  ],
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            for (final b in buckets)
              Expanded(
                child: Text(b.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: b.isCurrent ? FontWeight.w800 : FontWeight.w700,
                      color: b.isFuture ? p.muted.withValues(alpha: 0.5) : (b.isCurrent ? p.text : p.muted),
                    )),
              ),
          ]),
        ]),
      ),
    ]);
  }

  BarChartRodData _rod(int v, Color c, double w) => BarChartRodData(
        toY: v.toDouble(),
        color: c,
        width: w,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      );
}

/// Donut of spending by category; tap a slice to see its amount in the centre.
class SpendingDonut extends StatefulWidget {
  final List<(String name, int cents, int percent, Color color)> slices;
  final int totalCents;
  final Money money;
  const SpendingDonut({super.key, required this.slices, required this.totalCents, required this.money});

  @override
  State<SpendingDonut> createState() => _SpendingDonutState();
}

class _SpendingDonutState extends State<SpendingDonut> {
  int? _touched;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    const size = 140.0;
    if (widget.slices.isEmpty) return const SizedBox(width: size, height: size, child: _NoRecords(size));
    final t = _touched != null && _touched! < widget.slices.length ? widget.slices[_touched!] : null;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        PieChart(PieChartData(
          startDegreeOffset: -90,
          sectionsSpace: 2,
          centerSpaceRadius: 44,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              if (!event.isInterestedForInteractions) return;
              final i = response?.touchedSection?.touchedSectionIndex;
              setState(() => _touched = (i == null || i < 0) ? null : i);
            },
          ),
          sections: [
            for (var i = 0; i < widget.slices.length; i++)
              PieChartSectionData(
                value: widget.slices[i].$2.toDouble(),
                color: widget.slices[i].$4,
                radius: _touched == i ? 26 : 22,
                showTitle: false,
              ),
          ],
        )),
        IgnorePointer(
          child: SizedBox(
            width: 84,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(t?.$1 ?? 'Spent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.muted)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                    t == null ? widget.money.short(widget.totalCents) : widget.money.format(t.$2),
                    style: T.number(14, weight: FontWeight.w700, color: p.text)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// Cumulative spending this month (solid) vs last month (dashed).
class SpendingPaceChart extends StatelessWidget {
  final List<int> thisMonth; // cumulative, up to today
  final List<int> lastMonth; // cumulative, full month
  final int daysInThisMonth;
  final Money money;
  const SpendingPaceChart(
      {super.key, required this.thisMonth, required this.lastMonth, required this.daysInThisMonth, required this.money});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final maxV = [...thisMonth, ...lastMonth, 0].reduce((a, b) => a > b ? a : b);
    if (maxV == 0) return const _NoRecords(130);
    final top = niceMaxCents(maxV).toDouble();
    final maxX = (daysInThisMonth > lastMonth.length ? daysInThisMonth : lastMonth.length).toDouble();
    return SizedBox(
      height: 130,
      child: LineChart(LineChartData(
        minX: 1,
        maxX: maxX,
        minY: 0,
        maxY: top,
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: top / 2,
          getDrawingHorizontalLine: (_) => FlLine(color: p.divider, strokeWidth: 1),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => p.primary,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem(
                  '${s.barIndex == 0 ? 'Last month' : 'This month'} · day ${s.x.round()}\n${money.format(s.y.round())}',
                  TextStyle(color: p.onPrimary, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: fontBody),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [for (var i = 0; i < lastMonth.length; i++) FlSpot(i + 1.0, lastMonth[i].toDouble())],
            color: const Color(0xFF8A94A3),
            barWidth: 2,
            dashArray: const [5, 4],
            isCurved: false,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: [for (var i = 0; i < thisMonth.length; i++) FlSpot(i + 1.0, thisMonth[i].toDouble())],
            color: p.expense,
            barWidth: 2.6,
            isCurved: false,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, bar) => spot.x == thisMonth.length.toDouble(),
              getDotPainter: (spot, pct, bar, i) => FlDotCirclePainter(
                  radius: 4.5, color: p.expense, strokeWidth: 2, strokeColor: p.surface),
            ),
          ),
        ],
      )),
    );
  }
}
