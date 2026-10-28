import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/money.dart';
import '../../services/notifications.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final now = DateTime.now();
    final money = ref.watch(moneyProvider);
    final views = ref.watch(budgetViewsProvider).value ?? const <BudgetView>[];
    final settings = ref.watch(settingsProvider);
    final overall = views.where((v) => v.category == null).firstOrNull;
    final byCategory = views.where((v) => v.category != null).toList()
      ..sort((a, b) => b.status.percent.compareTo(a.status.percent));
    final daysLeft = daysLeftInMonth(now);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: screenPadding,
          children: [
            BackHeader(
              title: 'Budgets',
              subtitle: '${DateFormat('MMMM y').format(now)} · $daysLeft ${daysLeft == 1 ? 'day' : 'days'} left',
            ),
            const SizedBox(height: 16),
            if (overall == null)
              SurfaceCard(
                onTap: () => _editBudget(context, ref, null, null),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Set a monthly budget', style: T.row(context)),
                      const SizedBox(height: 2),
                      Text('One limit for all spending this month.', style: T.secondary(context, size: 13)),
                    ]),
                  ),
                  AppIcon('plus', color: p.text),
                ]),
              )
            else
              _OverallCard(view: overall, money: money, onTap: () => _editBudget(context, ref, null, overall.budget)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: Semantics(header: true, child: Text('By category', style: T.section(context)))),
              TextButton.icon(
                onPressed: () => _newCategoryBudget(context, ref, views),
                icon: AppIcon('plus', size: 16, color: p.income),
                label: const Text('New budget'),
              ),
            ]),
            const SizedBox(height: 6),
            if (byCategory.isEmpty)
              const EmptyCard('No category budgets yet.\nAdd one to track a single category.')
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  for (var i = 0; i < byCategory.length; i++)
                    _CategoryBudgetRow(
                      view: byCategory[i],
                      money: money,
                      divider: i < byCategory.length - 1,
                      onTap: () => _editBudget(context, ref, byCategory[i].category, byCategory[i].budget),
                    ),
                ]),
              ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
              child: SettingsRow(
                icon: 'bell',
                label: 'Warn me at ${(settings.budgetAlertAt * 100).round()}%',
                subtitle: 'Notification when a budget is nearly used',
                divider: false,
                trailing: Switch(
                  value: settings.budgetAlertsEnabled,
                  onChanged: (v) async {
                    if (v) await notificationService.requestPermission();
                    ref.read(settingsProvider.notifier).update((s) => s.copyWith(budgetAlertsEnabled: v));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newCategoryBudget(BuildContext context, WidgetRef ref, List<BudgetView> views) async {
    final used = views.map((v) => v.category?.id).whereType<int>().toSet();
    final options = (ref.read(categoriesProvider).value ?? const <CategoryRow>[])
        .where((c) => c.type == typeExpense && !used.contains(c.id))
        .toList();
    if (options.isEmpty) {
      showSnack(context, 'Every expense category already has a budget.');
      return;
    }
    final picked = await showModalBottomSheet<CategoryRow>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (c) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(c).height * 0.7),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text('Budget for which category?', style: T.section(c, size: 15)),
            ),
            for (final cat in options)
              ListTile(
                leading: CatIcon(icon: cat.icon, bg: cat.colorBg, fg: cat.colorFg, size: 36),
                title: Text(cat.name, style: T.row(c)),
                onTap: () => Navigator.pop(c, cat),
              ),
          ]),
        ),
      ),
    );
    if (picked != null && context.mounted) await _editBudget(context, ref, picked, null);
  }

  Future<void> _editBudget(BuildContext context, WidgetRef ref, CategoryRow? cat, BudgetRow? existing) async {
    final result = await showDialog<_BudgetEdit>(
      context: context,
      builder: (c) => _BudgetDialog(
        title: cat == null ? 'Monthly budget' : '${cat.name} budget',
        initialCents: existing?.limitCents,
        canDelete: existing != null,
        symbol: ref.read(moneyProvider).symbol,
      ),
    );
    if (result == null) return;
    final repo = ref.read(budgetRepoProvider);
    if (result.delete && existing != null) {
      await repo.delete(existing.id);
    } else if (result.cents != null) {
      await repo.setLimit(cat?.id, result.cents!);
    }
  }
}

class _OverallCard extends StatelessWidget {
  final BudgetView view;
  final Money money;
  final VoidCallback onTap;
  const _OverallCard({required this.view, required this.money, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = view.status;
    final pct = s.percent.round();
    final ringColor = switch (s.state) {
      BudgetState.normal => const Color(0xFF7FB2F7),
      BudgetState.warning => AppColors.expenseBar,
      _ => AppColors.expenseOnDark,
    };
    return Semantics(
      button: true,
      label: '$pct percent of monthly budget used',
      child: Material(
        color: p.card,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              SizedBox(
                width: 108,
                height: 108,
                child: CustomPaint(
                  painter: _RingPainter(s.barFraction, ringColor),
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('$pct%', style: T.number(22, weight: FontWeight.w700, color: Colors.white)),
                      const Text('used',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB7C1D0))),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Spent of ${money.format(s.limitCents)}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB7C1D0))),
                  const SizedBox(height: 2),
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(money.format(s.spentCents),
                          style: T.number(20, weight: FontWeight.w700, color: Colors.white))),
                  const SizedBox(height: 12),
                  Text(s.state == BudgetState.over ? 'Over budget by' : 'Safe to spend per day',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB7C1D0))),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      s.state == BudgetState.over
                          ? money.format(s.overByCents)
                          : money.format(safePerDayCents(s.limitCents, s.spentCents, DateTime.now())),
                      style: T.number(17,
                          color: s.state == BudgetState.over ? AppColors.expenseOnDark : AppColors.incomeOnDark),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;
  final Color color;
  _RingPainter(this.fraction, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 11.0;
    final rect = Offset.zero & size;
    final r = rect.deflate(stroke / 2);
    canvas.drawArc(r, 0, math.pi * 2, false,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);
    if (fraction > 0) {
      canvas.drawArc(r, -math.pi / 2, math.pi * 2 * fraction, false,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = stroke);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction || old.color != color;
}

class _CategoryBudgetRow extends StatelessWidget {
  final BudgetView view;
  final Money money;
  final bool divider;
  final VoidCallback onTap;
  const _CategoryBudgetRow({required this.view, required this.money, required this.divider, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final s = view.status;
    final c = view.category!;
    final (color, note, noteColor) = switch (s.state) {
      BudgetState.normal => (p.income, '${s.percent.round()}% used', p.muted),
      BudgetState.warning => (p.warning, '${s.percent.round()}% used · nearly there', p.warning),
      BudgetState.full => (p.expense, 'Fully used', p.expense),
      BudgetState.over => (p.expense, 'Over by ${money.format(s.overByCents)}', p.expense),
    };
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: divider ? Border(bottom: BorderSide(color: p.divider)) : null),
        child: Column(children: [
          Row(children: [
            CatIcon(icon: c.icon, bg: c.colorBg, fg: c.colorFg, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.name, style: T.row(context)),
                const SizedBox(height: 2),
                Text(note, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: noteColor)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(money.format(s.spentCents), style: T.number(15, color: p.text)),
              Text('of ${money.format(s.limitCents)}', style: T.secondary(context)),
            ]),
          ]),
          const SizedBox(height: 10),
          ProgressBar(fraction: s.barFraction, color: color, height: 6),
        ]),
      ),
    );
  }
}

class _BudgetEdit {
  final int? cents;
  final bool delete;
  const _BudgetEdit({this.cents, this.delete = false});
}

class _BudgetDialog extends StatefulWidget {
  final String title, symbol;
  final int? initialCents;
  final bool canDelete;
  const _BudgetDialog({required this.title, required this.symbol, this.initialCents, required this.canDelete});

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  late final _c = TextEditingController(text: widget.initialCents == null ? '' : centsToInput(widget.initialCents!));
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final r = parseAmount(_c.text);
    if (r.cents == null) {
      setState(() => _error = r.error);
      return;
    }
    Navigator.pop(context, _BudgetEdit(cents: r.cents));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return AlertDialog(
      title: Text(widget.title, style: T.section(context)),
      content: TextField(
        controller: _c,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Limit per month',
          prefixText: '${widget.symbol} ',
          errorText: _error,
        ),
      ),
      actions: [
        if (widget.canDelete)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: p.expense),
            onPressed: () => Navigator.pop(context, const _BudgetEdit(delete: true)),
            child: const Text('Delete'),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
