import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/recurring_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/wallet_budget_repositories.dart';
import '../domain/calculations.dart';
import '../domain/money.dart';
import '../domain/period.dart';

// ---------- infrastructure (overridden in main) ----------

final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final sharedPrefsProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

// ---------- repositories ----------

final transactionRepoProvider =
    Provider((ref) => TransactionRepository(ref.watch(databaseProvider)));
final categoryRepoProvider =
    Provider((ref) => CategoryRepository(ref.watch(databaseProvider)));
final walletRepoProvider = Provider((ref) => WalletRepository(ref.watch(databaseProvider)));
final budgetRepoProvider = Provider((ref) => BudgetRepository(ref.watch(databaseProvider)));
final recurringRepoProvider =
    Provider((ref) => RecurringRepository(ref.watch(databaseProvider)));
final settingsRepoProvider =
    Provider((ref) => SettingsRepository(ref.watch(sharedPrefsProvider)));

// ---------- settings ----------

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepoProvider).load();

  Future<void> update(AppSettings Function(AppSettings s) change) async {
    state = change(state);
    await ref.read(settingsRepoProvider).save(state);
  }

  /// Replaces all settings (restore from backup).
  Future<void> replace(AppSettings s) async {
    state = s;
    await ref.read(settingsRepoProvider).save(s);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

final moneyProvider =
    Provider((ref) => Money(ref.watch(settingsProvider.select((s) => s.currencySymbol))));

final weekStartProvider = Provider((ref) => ref.watch(settingsProvider.select((s) => s.weekStart)));

// ---------- reference data ----------

final categoriesProvider =
    StreamProvider<List<CategoryRow>>((ref) => ref.watch(categoryRepoProvider).watchAll());

final categoryMapProvider = Provider<Map<int, CategoryRow>>((ref) => {
      for (final c in ref.watch(categoriesProvider).value ?? const <CategoryRow>[]) c.id: c,
    });

final walletsProvider =
    StreamProvider<List<WalletRow>>((ref) => ref.watch(walletRepoProvider).watchAll());

final walletMapProvider = Provider<Map<int, WalletRow>>((ref) => {
      for (final w in ref.watch(walletsProvider).value ?? const <WalletRow>[]) w.id: w,
    });

final budgetsProvider =
    StreamProvider<List<BudgetRow>>((ref) => ref.watch(budgetRepoProvider).watchAll());

final recurringRulesProvider = StreamProvider<List<RecurringRuleRow>>(
    (ref) => ref.watch(recurringRepoProvider).watchAll());

/// Records in a range, newest first. Every screen reads totals from this one
/// source, so Home, Records, Reports and Budgets always agree.
final recordsInRangeProvider = StreamProvider.autoDispose.family<List<TxRow>, DateRange>(
    (ref, range) => ref.watch(transactionRepoProvider).watchRange(range));

// ---------- current month budgets ----------

class BudgetView {
  final BudgetRow budget;
  final CategoryRow? category; // null = overall
  final BudgetStatus status;
  const BudgetView(this.budget, this.category, this.status);
}

final currentMonthRangeProvider =
    Provider((ref) => periodRange(PeriodKind.month, DateTime.now()));

final budgetViewsProvider = Provider<AsyncValue<List<BudgetView>>>((ref) {
  final budgets = ref.watch(budgetsProvider);
  final records = ref.watch(recordsInRangeProvider(ref.watch(currentMonthRangeProvider)));
  final cats = ref.watch(categoryMapProvider);
  final alertAt = ref.watch(settingsProvider.select((s) => s.budgetAlertAt));
  if (budgets.isLoading || records.isLoading) return const AsyncLoading();
  final list = records.value ?? const <TxRow>[];
  final spentByCat = <int, int>{};
  var spentAll = 0;
  for (final r in list) {
    if (r.type != typeExpense) continue;
    spentAll += r.amountCents;
    spentByCat[r.categoryId] = (spentByCat[r.categoryId] ?? 0) + r.amountCents;
  }
  final views = <BudgetView>[];
  for (final b in budgets.value ?? const <BudgetRow>[]) {
    final cat = b.categoryId == null ? null : cats[b.categoryId];
    if (b.categoryId != null && cat == null) continue;
    final spent = b.categoryId == null ? spentAll : (spentByCat[b.categoryId] ?? 0);
    views.add(BudgetView(b, cat, BudgetStatus(spent, b.limitCents, alertAt: alertAt)));
  }
  return AsyncData(views);
});

// ---------- home period (FR-01, FR-02) ----------

class PeriodSelection {
  final PeriodKind kind;
  final DateTime anchor;
  const PeriodSelection(this.kind, this.anchor);
}

class HomePeriodNotifier extends Notifier<PeriodSelection> {
  @override
  PeriodSelection build() =>
      PeriodSelection(ref.read(settingsProvider).lastPeriodHome, DateTime.now());

  void setKind(PeriodKind kind) {
    state = PeriodSelection(kind, DateTime.now());
    ref.read(settingsProvider.notifier).update((s) => s.copyWith(lastPeriodHome: kind));
  }

  void step(int delta) =>
      state = PeriodSelection(state.kind, shiftAnchor(state.kind, state.anchor, delta));
}

final homePeriodProvider =
    NotifierProvider<HomePeriodNotifier, PeriodSelection>(HomePeriodNotifier.new);

final homeRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(homePeriodProvider);
  return periodRange(p.kind, p.anchor, weekStart: ref.watch(weekStartProvider));
});

// ---------- records filter (FR-16 .. FR-21) ----------

enum TypeFilter { all, expense, income }

class RecordsFilter {
  final PeriodKind kind;
  final DateTime anchor;
  final DateRange? custom;
  final TypeFilter type;
  final String search;
  final int? categoryId;
  const RecordsFilter({
    required this.kind,
    required this.anchor,
    this.custom,
    this.type = TypeFilter.all,
    this.search = '',
    this.categoryId,
  });

  RecordsFilter copyWith({
    PeriodKind? kind,
    DateTime? anchor,
    DateRange? custom,
    TypeFilter? type,
    String? search,
    int? Function()? categoryId,
  }) =>
      RecordsFilter(
        kind: kind ?? this.kind,
        anchor: anchor ?? this.anchor,
        custom: custom ?? this.custom,
        type: type ?? this.type,
        search: search ?? this.search,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
      );
}

class RecordsFilterNotifier extends Notifier<RecordsFilter> {
  @override
  RecordsFilter build() => RecordsFilter(kind: PeriodKind.month, anchor: DateTime.now());

  void setKind(PeriodKind kind) =>
      state = state.copyWith(kind: kind, anchor: DateTime.now(), categoryId: () => null);
  void step(int delta) =>
      state = state.copyWith(anchor: shiftAnchor(state.kind, state.anchor, delta));
  void setCustom(DateRange r) =>
      state = state.copyWith(kind: PeriodKind.custom, custom: r, categoryId: () => null);
  void setType(TypeFilter t) => state = state.copyWith(type: t);
  void setSearch(String s) => state = state.copyWith(search: s);
  void clearCategory() => state = state.copyWith(categoryId: () => null);

  /// From Home "See all": same period, all types, no category filter.
  void showPeriod(PeriodKind kind, DateTime anchor) =>
      state = RecordsFilter(kind: kind, anchor: anchor, search: state.search);

  /// From a Reports breakdown row: one category, expenses, same period (FR-26).
  void showCategory(int? categoryId, PeriodKind kind, DateTime anchor) => state = RecordsFilter(
      kind: kind, anchor: anchor, type: TypeFilter.expense, categoryId: categoryId);
}

final recordsFilterProvider =
    NotifierProvider<RecordsFilterNotifier, RecordsFilter>(RecordsFilterNotifier.new);

final recordsRangeProvider = Provider<DateRange>((ref) {
  final f = ref.watch(recordsFilterProvider);
  if (f.kind == PeriodKind.custom && f.custom != null) return f.custom!;
  final kind = f.kind == PeriodKind.custom ? PeriodKind.month : f.kind;
  return periodRange(kind, f.anchor, weekStart: ref.watch(weekStartProvider));
});

// ---------- reports period (FR-22) ----------

class ReportsPeriodNotifier extends Notifier<PeriodSelection> {
  @override
  PeriodSelection build() => PeriodSelection(PeriodKind.month, DateTime.now());
  void setKind(PeriodKind kind) => state = PeriodSelection(kind, DateTime.now());
  void step(int delta) =>
      state = PeriodSelection(state.kind, shiftAnchor(state.kind, state.anchor, delta));
}

final reportsPeriodProvider =
    NotifierProvider<ReportsPeriodNotifier, PeriodSelection>(ReportsPeriodNotifier.new);
