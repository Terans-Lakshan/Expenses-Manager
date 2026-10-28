import 'package:intl/intl.dart';

enum PeriodKind { today, week, month, year, custom }

extension PeriodKindX on PeriodKind {
  String get label => switch (this) {
        PeriodKind.today => 'Today',
        PeriodKind.week => 'Week',
        PeriodKind.month => 'Month',
        PeriodKind.year => 'Year',
        PeriodKind.custom => 'Custom',
      };

  static PeriodKind parse(String? s, {PeriodKind fallback = PeriodKind.month}) =>
      PeriodKind.values.firstWhere((k) => k.name == s, orElse: () => fallback);
}

/// Half-open range `[start, end)` in local time.
class DateRange {
  final DateTime start, end;
  const DateRange(this.start, this.end);

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);

  /// Number of calendar days in the range.
  int get days => DateTime.utc(end.year, end.month, end.day)
      .difference(DateTime.utc(start.year, start.month, start.day))
      .inDays;

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start, $end)';
}

DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

/// Range for [kind] containing [anchor]. [weekStart] uses DateTime.monday..sunday.
/// Dates are built from components (not Duration) so DST shifts never move a boundary.
DateRange periodRange(PeriodKind kind, DateTime anchor,
    {int weekStart = DateTime.monday}) {
  final d = dateOnly(anchor);
  switch (kind) {
    case PeriodKind.today:
      return DateRange(d, DateTime(d.year, d.month, d.day + 1));
    case PeriodKind.week:
      final back = (d.weekday - weekStart + 7) % 7;
      final start = DateTime(d.year, d.month, d.day - back);
      return DateRange(start, DateTime(start.year, start.month, start.day + 7));
    case PeriodKind.month:
      return DateRange(DateTime(d.year, d.month), DateTime(d.year, d.month + 1));
    case PeriodKind.year:
      return DateRange(DateTime(d.year), DateTime(d.year + 1));
    case PeriodKind.custom:
      throw ArgumentError('custom needs explicit dates');
  }
}

/// Custom range from the first chosen day to the end of the last chosen day.
DateRange customRange(DateTime firstDay, DateTime lastDay) {
  final a = dateOnly(firstDay), b = dateOnly(lastDay);
  final first = a.isAfter(b) ? b : a, last = a.isAfter(b) ? a : b;
  return DateRange(first, DateTime(last.year, last.month, last.day + 1));
}

/// Moves [anchor] one period forward (`step = 1`) or back (`step = -1`).
DateTime shiftAnchor(PeriodKind kind, DateTime anchor, int step) {
  final d = dateOnly(anchor);
  return switch (kind) {
    PeriodKind.today => DateTime(d.year, d.month, d.day + step),
    PeriodKind.week => DateTime(d.year, d.month, d.day + 7 * step),
    PeriodKind.month => DateTime(d.year, d.month + step, 1),
    PeriodKind.year => DateTime(d.year + step, 1, 1),
    PeriodKind.custom => d,
  };
}

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Same day of month in the month [months] away, clamped to that month's last day
/// (31 Oct + 1 month = 30 Nov).
DateTime addMonthsClamped(DateTime t, int months, {int? dayOfMonth}) {
  final firstOfTarget = DateTime(t.year, t.month + months, 1);
  final day = dayOfMonth ?? t.day;
  final clamped = day.clamp(1, daysInMonth(firstOfTarget.year, firstOfTarget.month));
  return DateTime(firstOfTarget.year, firstOfTarget.month, clamped, t.hour,
      t.minute, t.second);
}

/// Human label for the period, e.g. "Wed, 28 Oct 2026", "26 Oct – 1 Nov 2026",
/// "October 2026", "2026".
String periodLabel(PeriodKind kind, DateRange r) {
  final lastDay = DateTime(r.end.year, r.end.month, r.end.day - 1);
  switch (kind) {
    case PeriodKind.today:
      return DateFormat('EEE, d MMM y').format(r.start);
    case PeriodKind.month:
      return DateFormat('MMMM y').format(r.start);
    case PeriodKind.year:
      return DateFormat('y').format(r.start);
    case PeriodKind.week:
    case PeriodKind.custom:
      if (r.start == lastDay) return DateFormat('EEE, d MMM y').format(r.start);
      final sameYear = r.start.year == lastDay.year;
      final sameMonth = sameYear && r.start.month == lastDay.month;
      final a = sameMonth
          ? DateFormat('d').format(r.start)
          : DateFormat(sameYear ? 'd MMM' : 'd MMM y').format(r.start);
      return '$a – ${DateFormat('d MMM y').format(lastDay)}';
  }
}

/// Short label for the balance card, e.g. "Today", "This week", "October".
String periodShortLabel(PeriodKind kind, DateRange r, DateTime now) {
  final current = kind != PeriodKind.custom && r.contains(now);
  return switch (kind) {
    PeriodKind.today => current ? 'Today' : DateFormat('d MMM').format(r.start),
    PeriodKind.week => current ? 'This week' : 'Week of ${DateFormat('d MMM').format(r.start)}',
    PeriodKind.month => current ? 'This month' : DateFormat('MMMM y').format(r.start),
    PeriodKind.year => current ? 'This year' : DateFormat('y').format(r.start),
    PeriodKind.custom => 'Custom range',
  };
}

/// Day-group label for the Records list: Today, Yesterday, else "Wed, 22 Oct".
String dayGroupLabel(DateTime day, DateTime now) {
  final d = dateOnly(day), today = dateOnly(now);
  if (d == today) return 'Today';
  if (d == DateTime(today.year, today.month, today.day - 1)) return 'Yesterday';
  return DateFormat(d.year == today.year ? 'EEE, d MMM' : 'EEE, d MMM y').format(d);
}
