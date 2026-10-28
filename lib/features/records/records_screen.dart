import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/money.dart';
import '../../domain/period.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  final bool focusSearch;
  const RecordsScreen({super.key, this.focusSearch = false});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

/// Flattened list entry: a day header or one record inside that day's card.
sealed class _Entry {}

class _Header extends _Entry {
  final String label;
  final int net;
  _Header(this.label, this.net);
}

class _Item extends _Entry {
  final TxRow record;
  final bool first, last;
  _Item(this.record, this.first, this.last);
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  final _search = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(recordsFilterProvider).search;
    if (widget.focusSearch) _requestFocus();
  }

  @override
  void didUpdateWidget(RecordsScreen old) {
    super.didUpdateWidget(old);
    if (widget.focusSearch && !old.focusSearch) _requestFocus();
  }

  void _requestFocus() => WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _pickCustom() async {
    final now = DateTime.now();
    final current = ref.read(recordsRangeProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
      initialDateRange: DateTimeRange(
          start: current.start, end: DateTime(current.end.year, current.end.month, current.end.day - 1)),
      helpText: 'Custom range',
    );
    if (picked != null) {
      ref.read(recordsFilterProvider.notifier).setCustom(customRange(picked.start, picked.end));
    }
  }

  bool _matches(TxRow r, String q, Map<int, CategoryRow> cats, Money money) {
    if (q.isEmpty) return true;
    if ((r.note ?? '').toLowerCase().contains(q)) return true;
    if ((cats[r.categoryId]?.name ?? '').toLowerCase().contains(q)) return true;
    final digits = q.replaceAll(',', '').replaceAll(money.symbol.toLowerCase(), '').trim();
    if (digits.isNotEmpty && RegExp(r'^[\d.]+$').hasMatch(digits)) {
      final plain = centsToInput(r.amountCents);
      final fixed = (r.amountCents / 100).toStringAsFixed(2);
      return plain.contains(digits) || fixed.contains(digits);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final f = ref.watch(recordsFilterProvider);
    final notifier = ref.read(recordsFilterProvider.notifier);
    final range = ref.watch(recordsRangeProvider);
    final async = ref.watch(recordsInRangeProvider(range));
    final cats = ref.watch(categoryMapProvider);
    final money = ref.watch(moneyProvider);
    final now = DateTime.now();

    final q = f.search.trim().toLowerCase();
    final base = (async.value ?? const <TxRow>[])
        .where((r) => f.categoryId == null || r.categoryId == f.categoryId)
        .where((r) => _matches(r, q, cats, money))
        .toList();
    final totals = totalsOf(base);
    final shown = switch (f.type) {
      TypeFilter.all => base,
      TypeFilter.expense => base.where((r) => r.type == typeExpense).toList(),
      TypeFilter.income => base.where((r) => r.type == typeIncome).toList(),
    };

    // Group by day, newest first (records already arrive newest first).
    final entries = <_Entry>[];
    for (var i = 0; i < shown.length;) {
      final day = dateOnly(shown[i].occurredAt);
      var j = i;
      while (j < shown.length && dateOnly(shown[j].occurredAt) == day) {
        j++;
      }
      final dayRecords = shown.sublist(i, j);
      entries.add(_Header(dayGroupLabel(day, now), totalsOf(dayRecords).netCents));
      for (var k = 0; k < dayRecords.length; k++) {
        entries.add(_Item(dayRecords[k], k == 0, k == dayRecords.length - 1));
      }
      i = j;
    }

    final categoryName = f.categoryId == null ? null : (cats[f.categoryId]?.name ?? 'Other categories');

    return SafeArea(
      bottom: false,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(children: [
            Row(children: [
              Expanded(child: Semantics(header: true, child: Text('Records', style: T.title(context)))),
              LabelIconButton(
                  icon: 'calendar',
                  label: 'Custom',
                  semanticLabel: 'Pick a custom date range',
                  onTap: _pickCustom),
            ]),
            const SizedBox(height: 14),
            TextField(
              controller: _search,
              focusNode: _focus,
              onChanged: notifier.setSearch,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.text),
              decoration: InputDecoration(
                hintText: 'Search notes, categories, amounts',
                hintStyle: TextStyle(color: p.muted, fontWeight: FontWeight.w600),
                fillColor: p.surface,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(13),
                  child: AppIcon('search', size: 18, color: p.muted),
                ),
                suffixIcon: f.search.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: AppIcon('close', size: 16, color: p.muted),
                        onPressed: () {
                          _search.clear();
                          notifier.setSearch('');
                        }),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.track)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: p.income)),
              ),
            ),
            const SizedBox(height: 14),
            SegmentedTabs<PeriodKind>(
              values: const [PeriodKind.today, PeriodKind.week, PeriodKind.month, PeriodKind.year],
              selected: f.kind,
              label: (k) => k.label,
              height: 38,
              onChanged: notifier.setKind,
            ),
            const SizedBox(height: 4),
            Row(children: [
              if (f.kind != PeriodKind.custom)
                IconButton(
                    tooltip: 'Previous period',
                    onPressed: () => notifier.step(-1),
                    icon: AppIcon('chevron-left', color: p.text, strokeWidth: 2.2))
              else
                const SizedBox(width: 48),
              Expanded(
                child: Text(
                    f.kind == PeriodKind.custom
                        ? periodLabel(PeriodKind.custom, range)
                        : periodLabel(f.kind, range),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.text)),
              ),
              if (f.kind != PeriodKind.custom)
                IconButton(
                    tooltip: 'Next period',
                    onPressed: () => notifier.step(1),
                    icon: AppIcon('chevron-right', color: p.text, strokeWidth: 2.2))
              else
                IconButton(
                    tooltip: 'Clear custom range',
                    onPressed: () => notifier.setKind(PeriodKind.month),
                    icon: AppIcon('close', size: 18, color: p.text)),
            ]),
            Row(children: [
              for (final t in TypeFilter.values) ...[
                Pill(
                  label: switch (t) {
                    TypeFilter.all => 'All',
                    TypeFilter.expense => 'Expenses',
                    TypeFilter.income => 'Income',
                  },
                  selected: f.type == t,
                  onTap: () => notifier.setType(t),
                ),
                const SizedBox(width: 8),
              ],
              const Spacer(),
            ]),
            if (categoryName != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  label: Text('Category: $categoryName'),
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, color: p.text, fontSize: 13),
                  backgroundColor: p.surface,
                  side: BorderSide(color: p.border),
                  shape: const StadiumBorder(),
                  onDeleted: notifier.clearCategory,
                  deleteButtonTooltipMessage: 'Clear category filter',
                ),
              ),
            ],
          ]),
        ),
        Expanded(
          child: CustomScrollView(slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(children: [
                  Expanded(child: _totalTile(context, 'Income', money.format(totals.incomeCents), p.income)),
                  const SizedBox(width: 10),
                  Expanded(child: _totalTile(context, 'Expenses', money.format(totals.expenseCents), p.expense)),
                ]),
              ),
            ),
            if (async.isLoading && async.value == null)
              const SliverToBoxAdapter(
                  child: Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())))
            else if (shown.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: EmptyCard(q.isNotEmpty || f.categoryId != null || f.type != TypeFilter.all
                      ? 'No records match this filter.'
                      : 'No records in this period.'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverList.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, i) => switch (entries[i]) {
                    _Header h => Padding(
                        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Expanded(
                              child: Semantics(
                                  header: true, child: Text(h.label, style: T.section(context, size: 14)))),
                          Text(money.net(h.net),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.muted)),
                        ]),
                      ),
                    _Item it => Container(
                        padding: EdgeInsets.fromLTRB(14, it.first ? 4 : 0, 14, it.last ? 4 : 0),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(it.first ? 20 : 0),
                            bottom: Radius.circular(it.last ? 20 : 0),
                          ),
                        ),
                        child: RecordTile(
                          record: it.record,
                          iconSize: 42,
                          showDate: false,
                          showDivider: !it.last,
                          onTap: () => context.push('/record/${it.record.id}'),
                        ),
                      ),
                  },
                ),
              ),
          ]),
        ),
      ]),
    );
  }

  Widget _totalTile(BuildContext context, String label, String value, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: context.pal.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.pal.muted)),
          const SizedBox(height: 2),
          FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: T.number(17, color: color))),
        ]),
      );
}
