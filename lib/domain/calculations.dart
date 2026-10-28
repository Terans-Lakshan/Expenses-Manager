import '../data/database.dart';
import 'period.dart';

const typeExpense = 'expense';
const typeIncome = 'income';

class Totals {
  final int incomeCents, expenseCents;
  const Totals(this.incomeCents, this.expenseCents);
  int get netCents => incomeCents - expenseCents;
  static const zero = Totals(0, 0);
}

/// Income and expense sums over [records] (already filtered to a range).
Totals totalsOf(Iterable<TxRow> records) {
  var inc = 0, exp = 0;
  for (final r in records) {
    if (r.type == typeIncome) {
      inc += r.amountCents;
    } else {
      exp += r.amountCents;
    }
  }
  return Totals(inc, exp);
}

Iterable<TxRow> inRange(Iterable<TxRow> records, DateRange range) =>
    records.where((r) => range.contains(r.occurredAt));

/// Saved % = net ÷ income × 100, rounded. Null when income is 0 or net < 0
/// (UI then shows "Overspent Rs X").
int? savedPercent(Totals t) {
  if (t.incomeCents <= 0 || t.netCents < 0) return null;
  return (t.netCents * 100 / t.incomeCents).round();
}

enum BudgetState { normal, warning, full, over }

class BudgetStatus {
  final int spentCents, limitCents;
  final double alertAt;
  const BudgetStatus(this.spentCents, this.limitCents, {this.alertAt = 0.8});

  /// Exact % used (may exceed 100).
  double get percent => limitCents <= 0 ? 0 : spentCents * 100 / limitCents;

  /// Bar fill 0..1, capped at 100%.
  double get barFraction => (percent / 100).clamp(0.0, 1.0);

  int get remainingCents => limitCents - spentCents;
  int get overByCents => spentCents > limitCents ? spentCents - limitCents : 0;

  BudgetState get state {
    if (spentCents > limitCents) return BudgetState.over;
    if (spentCents == limitCents && limitCents > 0) return BudgetState.full;
    if (percent >= alertAt * 100) return BudgetState.warning;
    return BudgetState.normal;
  }
}

/// Days left in [now]'s month including today.
int daysLeftInMonth(DateTime now) => daysInMonth(now.year, now.month) - now.day + 1;

/// Safe to spend per day = (limit − spent) ÷ days left including today; 0 if over.
int safePerDayCents(int limitCents, int spentCents, DateTime now) {
  final remaining = limitCents - spentCents;
  if (remaining <= 0) return 0;
  return remaining ~/ daysLeftInMonth(now);
}

/// Home budget card limit for the selected period, scaled from the monthly limit.
/// Uses the days in the month containing the period start.
int scaledBudgetCents(int monthlyLimitCents, PeriodKind kind, DateRange r) {
  final dim = daysInMonth(r.start.year, r.start.month);
  return switch (kind) {
    PeriodKind.today => (monthlyLimitCents / dim).round(),
    PeriodKind.week => (monthlyLimitCents / dim * 7).round(),
    PeriodKind.month => monthlyLimitCents,
    PeriodKind.year => monthlyLimitCents * 12,
    PeriodKind.custom => (monthlyLimitCents / dim * r.days).round(),
  };
}

/// Rounds a chart maximum up to a clean value with an even half-step:
/// 213,000 → 220,000; 4,300 → 5,000; 0 → 1,000 (cents in, cents out).
int niceMaxCents(int maxCents) {
  if (maxCents <= 0) return 100000; // Rs 1,000 placeholder scale
  final v = maxCents / 100;
  final exp = (v.toString().split('.').first.length - 1);
  final magnitude = _pow10(exp);
  for (final step in [1.0, 1.2, 1.4, 1.5, 1.6, 2.0, 2.2, 2.4, 2.5, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0]) {
    final candidate = step * magnitude;
    if (candidate >= v) return (candidate * 100).round();
  }
  return (10 * magnitude * 100).round();
}

double _pow10(int e) {
  var r = 1.0;
  for (var i = 0; i < e; i++) {
    r *= 10;
  }
  return r;
}

class CategorySpend {
  /// Null for the merged "Other" slice.
  final int? categoryId;
  final int cents;
  final int percent;
  const CategorySpend(this.categoryId, this.cents, this.percent);
}

/// Expense totals per category, largest first. Top [top] categories, the rest
/// merged into one slice with categoryId null. Percentages use the largest
/// remainder method so they always add up to 100.
List<CategorySpend> categoryBreakdown(Iterable<TxRow> records, {int top = 5}) {
  final sums = <int, int>{};
  for (final r in records) {
    if (r.type != typeExpense) continue;
    sums[r.categoryId] = (sums[r.categoryId] ?? 0) + r.amountCents;
  }
  final sorted = sums.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final entries = <MapEntry<int?, int>>[
    ...sorted.take(top).map((e) => MapEntry<int?, int>(e.key, e.value)),
  ];
  if (sorted.length > top) {
    entries.add(MapEntry(null, sorted.skip(top).fold(0, (s, e) => s + e.value)));
  }
  final pcts = percentages(entries.map((e) => e.value).toList());
  return [
    for (var i = 0; i < entries.length; i++)
      CategorySpend(entries[i].key, entries[i].value, pcts[i]),
  ];
}

/// Integer percentages that sum to exactly 100 (largest remainder method).
List<int> percentages(List<int> values) {
  final total = values.fold<int>(0, (s, v) => s + v);
  if (total <= 0) return List.filled(values.length, 0);
  final raw = values.map((v) => v * 100 / total).toList();
  final floors = raw.map((v) => v.floor()).toList();
  var missing = 100 - floors.fold<int>(0, (s, v) => s + v);
  final order = List.generate(values.length, (i) => i)
    ..sort((a, b) => (raw[b] - floors[b]).compareTo(raw[a] - floors[a]));
  for (final i in order) {
    if (missing <= 0) break;
    floors[i]++;
    missing--;
  }
  return floors;
}

class BarBucket {
  final String label;
  final DateRange range;
  final int incomeCents, expenseCents;
  final bool isCurrent, isFuture;
  const BarBucket(this.label, this.range, this.incomeCents, this.expenseCents,
      {this.isCurrent = false, this.isFuture = false});
}

/// Buckets for the income-vs-expenses chart:
/// week → 7 days of the week; month → last 6 months ending with the anchor month;
/// year → Jan–Dec of the anchor year.
List<BarBucket> barBuckets(Iterable<TxRow> records, PeriodKind kind,
    DateTime anchor, DateTime now,
    {int weekStart = DateTime.monday}) {
  final ranges = <(String, DateRange)>[];
  const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  switch (kind) {
    case PeriodKind.week:
      final w = periodRange(PeriodKind.week, anchor, weekStart: weekStart);
      for (var i = 0; i < 7; i++) {
        final d = DateTime(w.start.year, w.start.month, w.start.day + i);
        ranges.add((dayNames[d.weekday - 1], periodRange(PeriodKind.today, d)));
      }
    case PeriodKind.month:
      for (var i = 5; i >= 0; i--) {
        final m = DateTime(anchor.year, anchor.month - i, 1);
        ranges.add((monthNames[m.month - 1], periodRange(PeriodKind.month, m)));
      }
    case PeriodKind.year:
      for (var m = 1; m <= 12; m++) {
        final d = DateTime(anchor.year, m, 1);
        ranges.add((monthNames[m - 1].substring(0, 1), periodRange(PeriodKind.month, d)));
      }
    default:
      throw ArgumentError('bars support week, month and year');
  }
  final list = records.toList();
  return [
    for (final (label, r) in ranges)
      () {
        final t = totalsOf(inRange(list, r));
        return BarBucket(label, r, t.incomeCents, t.expenseCents,
            isCurrent: r.contains(now), isFuture: r.start.isAfter(now));
      }(),
  ];
}

/// Cumulative expense per day of the month containing [monthStart]:
/// index 0 = end of day 1. Only fills up to [upToDay] (inclusive) when given.
List<int> cumulativeDailySpend(Iterable<TxRow> records, DateTime monthStart,
    {int? upToDay}) {
  final days = daysInMonth(monthStart.year, monthStart.month);
  final perDay = List<int>.filled(days, 0);
  final r = periodRange(PeriodKind.month, monthStart);
  for (final t in records) {
    if (t.type != typeExpense || !r.contains(t.occurredAt)) continue;
    perDay[t.occurredAt.day - 1] += t.amountCents;
  }
  final limit = (upToDay ?? days).clamp(0, days);
  final out = <int>[];
  var run = 0;
  for (var i = 0; i < limit; i++) {
    run += perDay[i];
    out.add(run);
  }
  return out;
}
