import 'package:expense_manager/domain/period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Wed 28 Oct 2026
  final wed = DateTime(2026, 10, 28, 18, 45);

  group('periodRange', () {
    test('today is [00:00, next 00:00)', () {
      final r = periodRange(PeriodKind.today, wed);
      expect(r.start, DateTime(2026, 10, 28));
      expect(r.end, DateTime(2026, 10, 29));
    });

    test('week starts Monday by default', () {
      final r = periodRange(PeriodKind.week, wed);
      expect(r.start, DateTime(2026, 10, 26));
      expect(r.end, DateTime(2026, 11, 2));
    });

    test('week starting Sunday', () {
      final r = periodRange(PeriodKind.week, wed, weekStart: DateTime.sunday);
      expect(r.start, DateTime(2026, 10, 25));
      expect(r.end, DateTime(2026, 11, 1));
    });

    test('week anchor on the start day itself', () {
      final r = periodRange(PeriodKind.week, DateTime(2026, 10, 26));
      expect(r.start, DateTime(2026, 10, 26));
    });

    test('23:59 Sunday is in that week, 00:00 Monday in the next', () {
      final week = periodRange(PeriodKind.week, DateTime(2026, 11, 1));
      expect(week.contains(DateTime(2026, 11, 1, 23, 59)), isTrue);
      expect(week.contains(DateTime(2026, 11, 2)), isFalse);
      expect(periodRange(PeriodKind.week, DateTime(2026, 11, 2)).contains(DateTime(2026, 11, 2)), isTrue);
    });

    test('month and year', () {
      expect(periodRange(PeriodKind.month, wed), DateRange(DateTime(2026, 10), DateTime(2026, 11)));
      expect(periodRange(PeriodKind.month, DateTime(2026, 12, 5)),
          DateRange(DateTime(2026, 12), DateTime(2027, 1)));
      expect(periodRange(PeriodKind.year, wed), DateRange(DateTime(2026), DateTime(2027)));
    });

    test('week crossing a year boundary', () {
      final r = periodRange(PeriodKind.week, DateTime(2027, 1, 1)); // Friday
      expect(r.start, DateTime(2026, 12, 28));
      expect(r.end, DateTime(2027, 1, 4));
    });

    test('custom requires explicit dates', () {
      expect(() => periodRange(PeriodKind.custom, wed), throwsArgumentError);
      final c = customRange(DateTime(2026, 10, 30), DateTime(2026, 10, 1));
      expect(c, DateRange(DateTime(2026, 10, 1), DateTime(2026, 10, 31)));
      expect(c.days, 30);
    });
  });

  group('shiftAnchor', () {
    test('steps each period kind', () {
      expect(shiftAnchor(PeriodKind.today, wed, -1), DateTime(2026, 10, 27));
      expect(shiftAnchor(PeriodKind.week, wed, 1), DateTime(2026, 11, 4));
      expect(shiftAnchor(PeriodKind.month, DateTime(2026, 1, 31), 1), DateTime(2026, 2, 1));
      expect(shiftAnchor(PeriodKind.year, wed, -1), DateTime(2025, 1, 1));
    });
  });

  group('addMonthsClamped', () {
    test('31st becomes the last day of a shorter month', () {
      expect(addMonthsClamped(DateTime(2026, 10, 31), 1), DateTime(2026, 11, 30));
      expect(addMonthsClamped(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
      expect(addMonthsClamped(DateTime(2028, 1, 31), 1), DateTime(2028, 2, 29));
    });

    test('keeps the preferred day after a short month', () {
      expect(addMonthsClamped(DateTime(2026, 11, 30), 1, dayOfMonth: 31), DateTime(2026, 12, 31));
    });
  });

  group('labels', () {
    test('period labels', () {
      expect(periodLabel(PeriodKind.today, periodRange(PeriodKind.today, wed)), 'Wed, 28 Oct 2026');
      expect(periodLabel(PeriodKind.week, periodRange(PeriodKind.week, wed)), '26 Oct – 1 Nov 2026');
      expect(periodLabel(PeriodKind.month, periodRange(PeriodKind.month, wed)), 'October 2026');
      expect(periodLabel(PeriodKind.year, periodRange(PeriodKind.year, wed)), '2026');
    });

    test('day group labels', () {
      expect(dayGroupLabel(DateTime(2026, 10, 28, 9), wed), 'Today');
      expect(dayGroupLabel(DateTime(2026, 10, 27, 23), wed), 'Yesterday');
      expect(dayGroupLabel(DateTime(2026, 10, 22), wed), 'Thu, 22 Oct');
      expect(dayGroupLabel(DateTime(2025, 10, 22), wed), 'Wed, 22 Oct 2025');
    });
  });
}
