import 'package:expense_manager/data/database.dart';
import 'package:expense_manager/domain/calculations.dart';
import 'package:expense_manager/domain/money.dart';
import 'package:expense_manager/domain/period.dart';
import 'package:flutter_test/flutter_test.dart';

var _id = 0;
TxRow tx(String type, int cents, DateTime at, {int cat = 1}) => TxRow(
      id: ++_id,
      type: type,
      amountCents: cents,
      categoryId: cat,
      walletId: 1,
      occurredAt: at,
      createdAt: at,
      updatedAt: at,
    );

void main() {
  const money = Money('Rs');

  group('Money format', () {
    test('whole and cents', () {
      expect(money.format(1234500), 'Rs 12,345');
      expect(money.format(225050), 'Rs 2,250.50');
      expect(money.format(0), 'Rs 0');
      expect(money.format(-120000), '−Rs 1,200');
    });

    test('signed', () {
      expect(money.signed(150000, income: true), '+Rs 1,500');
      expect(money.signed(150000, income: false), '−Rs 1,500');
    });

    test('short', () {
      expect(money.short(95000), 'Rs 950');
      expect(money.short(11243000), 'Rs 112k');
      expect(money.short(450000), 'Rs 4.5k');
      expect(money.short(191000000), 'Rs 1.91M');
    });

    test('largest amount', () {
      expect(money.format(maxAmountCents), 'Rs 999,999,999');
    });
  });

  group('parseAmount', () {
    test('accepts valid input', () {
      expect(parseAmount('2250').cents, 225000);
      expect(parseAmount('2,250.5').cents, 225050);
      expect(parseAmount('0.01').cents, 1);
      expect(parseAmount('999999999').cents, maxAmountCents);
    });

    test('rejects empty, zero, negative, >2 decimals, too large, junk', () {
      for (final bad in ['', ' ', '0', '0.00', '-5', '1.234', '1000000000', 'abc', '.', '1.2.3']) {
        expect(parseAmount(bad).cents, isNull, reason: bad);
        expect(parseAmount(bad).error, isNotNull, reason: bad);
      }
    });

    test('centsToInput round-trips', () {
      for (final c in [1, 50, 225050, 225000, 99]) {
        expect(parseAmount(centsToInput(c)).cents, c);
      }
    });
  });

  group('totals and saved %', () {
    final now = DateTime(2026, 10, 28, 12);
    final rs = [
      tx(typeIncome, 10000000, now),
      tx(typeExpense, 2500000, now),
      tx(typeExpense, 500000, DateTime(2026, 9, 30, 23, 59)),
    ];

    test('totals in range', () {
      final t = totalsOf(inRange(rs, periodRange(PeriodKind.month, now)));
      expect(t.incomeCents, 10000000);
      expect(t.expenseCents, 2500000);
      expect(t.netCents, 7500000);
      expect(savedPercent(t), 75);
    });

    test('overspent when income is 0 or net < 0', () {
      expect(savedPercent(const Totals(0, 100)), isNull);
      expect(savedPercent(const Totals(100, 200)), isNull);
      expect(savedPercent(const Totals(0, 0)), isNull);
    });
  });

  group('budgets', () {
    test('states', () {
      expect(const BudgetStatus(7900, 10000).state, BudgetState.normal);
      expect(const BudgetStatus(8000, 10000).state, BudgetState.warning);
      expect(const BudgetStatus(10000, 10000).state, BudgetState.full);
      final over = const BudgetStatus(12500, 10000);
      expect(over.state, BudgetState.over);
      expect(over.overByCents, 2500);
      expect(over.barFraction, 1.0);
    });

    test('safe to spend per day includes today', () {
      // 28 Oct: 4 days left (28, 29, 30, 31)
      final now = DateTime(2026, 10, 28);
      expect(daysLeftInMonth(now), 4);
      expect(safePerDayCents(15000000, 11243000, now), (15000000 - 11243000) ~/ 4);
      expect(safePerDayCents(100, 200, now), 0);
    });

    test('home budget scaled per period', () {
      final oct = DateTime(2026, 10, 28);
      expect(scaledBudgetCents(3100000, PeriodKind.today, periodRange(PeriodKind.today, oct)), 100000);
      expect(scaledBudgetCents(3100000, PeriodKind.week, periodRange(PeriodKind.week, oct)), 700000);
      expect(scaledBudgetCents(3100000, PeriodKind.month, periodRange(PeriodKind.month, oct)), 3100000);
      expect(scaledBudgetCents(3100000, PeriodKind.year, periodRange(PeriodKind.year, oct)), 37200000);
    });
  });

  group('charts', () {
    test('nice max', () {
      expect(niceMaxCents(21300000), 22000000);
      expect(niceMaxCents(430000), 500000);
      expect(niceMaxCents(100000), 100000);
      expect(niceMaxCents(0), greaterThan(0));
    });

    test('percentages always add to 100', () {
      expect(percentages([1, 1, 1]).reduce((a, b) => a + b), 100);
      expect(percentages([333, 333, 334]), [33, 33, 34]);
      expect(percentages([0, 0]), [0, 0]);
    });

    test('breakdown: top 5 plus Other, largest first, sums to 100%', () {
      final at = DateTime(2026, 10, 10);
      final rs = [
        for (var c = 1; c <= 7; c++) tx(typeExpense, c * 1000, at, cat: c),
        tx(typeIncome, 999999, at, cat: 99),
      ];
      final b = categoryBreakdown(rs);
      expect(b.length, 6);
      expect(b.first.categoryId, 7);
      expect(b.last.categoryId, isNull);
      expect(b.last.cents, 1000 + 2000);
      expect(b.fold<int>(0, (s, x) => s + x.percent), 100);
    });

    test('bar buckets: week days, last 6 months, 12 months', () {
      final now = DateTime(2026, 10, 28, 10);
      final rs = [tx(typeExpense, 500, DateTime(2026, 10, 27)), tx(typeIncome, 900, DateTime(2026, 6, 1))];
      final week = barBuckets(rs, PeriodKind.week, now, now);
      expect(week.map((b) => b.label), ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
      expect(week[1].expenseCents, 500);
      expect(week[2].isCurrent, isTrue);
      expect(week[3].isFuture, isTrue);
      final month = barBuckets(rs, PeriodKind.month, now, now);
      expect(month.map((b) => b.label), ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct']);
      expect(month[1].incomeCents, 900);
      final year = barBuckets(rs, PeriodKind.year, now, now);
      expect(year.length, 12);
      expect(year[10].isFuture, isTrue);
    });

    test('cumulative daily spend', () {
      final rs = [
        tx(typeExpense, 100, DateTime(2026, 10, 1)),
        tx(typeExpense, 50, DateTime(2026, 10, 3)),
        tx(typeIncome, 999, DateTime(2026, 10, 2)),
      ];
      expect(cumulativeDailySpend(rs, DateTime(2026, 10), upToDay: 4), [100, 100, 150, 150]);
      expect(cumulativeDailySpend(rs, DateTime(2026, 10)).length, 31);
    });
  });
}
