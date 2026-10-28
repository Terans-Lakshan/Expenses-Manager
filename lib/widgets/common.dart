import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app/providers.dart';
import '../app/theme.dart';
import '../data/database.dart';
import '../domain/calculations.dart';
import 'icons.dart';

const screenPadding = EdgeInsets.fromLTRB(20, 16, 20, 24);

/// Segmented switch on the grey track (period / type tabs).
class SegmentedTabs<V> extends StatelessWidget {
  final List<V> values;
  final V selected;
  final String Function(V) label;
  final ValueChanged<V> onChanged;
  final double height;
  final Color? Function(V)? selectedBg;
  final Color? Function(V)? selectedFg;
  final double radius;

  const SegmentedTabs({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
    this.height = 40,
    this.selectedBg,
    this.selectedFg,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: p.track, borderRadius: BorderRadius.circular(radius)),
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(child: _tab(context, values[i])),
          ],
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, V v) {
    final p = context.pal;
    final on = v == selected;
    final bg = on ? (selectedBg?.call(v) ?? p.segmentSelected) : Colors.transparent;
    final fg = on ? (selectedFg?.call(v) ?? p.text) : p.muted;
    return Semantics(
      selected: on,
      button: true,
      child: Material(
        color: bg,
        elevation: 0,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(radius - 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius - 4),
          onTap: () => onChanged(v),
          child: Container(
            height: height,
            alignment: Alignment.center,
            decoration: on && selectedBg == null
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(radius - 4),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1F0F1B2D), blurRadius: 3, offset: Offset(0, 1)),
                    ],
                    color: bg,
                  )
                : null,
            child: Text(label(v),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: fg)),
          ),
        ),
      ),
    );
  }
}

/// Rounded outline chip (type filter, wallet picker).
class Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  const Pill(
      {super.key, required this.label, required this.selected, required this.onTap, this.selectedColor});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final sel = selectedColor ?? p.primary;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? sel : p.surface,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: selected ? sel : p.border),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? (selectedColor == null ? p.onPrimary : Colors.white)
                        : p.text)),
          ),
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  const SurfaceCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.radius = 20,
      this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: context.pal.surface,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      );
}

/// 44×44 white square icon button with border (search, bell, back, close).
class SquareIconButton extends StatelessWidget {
  final String icon;
  final String tooltip;
  final VoidCallback onTap;
  const SquareIconButton({super.key, required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        label: tooltip,
        button: true,
        child: Material(
          color: p.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14), side: BorderSide(color: p.track)),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onTap: onTap,
            child: SizedBox(
                width: 44, height: 44, child: Center(child: AppIcon(icon, color: p.text))),
          ),
        ),
      ),
    );
  }
}

/// White button with icon + label (Custom, Export).
class LabelIconButton extends StatelessWidget {
  final String icon, label;
  final VoidCallback onTap;
  final String? semanticLabel;
  const LabelIconButton(
      {super.key, required this.icon, required this.label, required this.onTap, this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), side: BorderSide(color: p.track)),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              AppIcon(icon, size: 18, color: p.text),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.text)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Header with back button and title, for pushed screens.
class BackHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const BackHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) => Row(children: [
        SquareIconButton(
            icon: 'chevron-left', tooltip: 'Back', onTap: () => Navigator.of(context).maybePop()),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: T.title(context).copyWith(fontSize: 22)),
            if (subtitle != null) Text(subtitle!, style: T.secondary(context, size: 13)),
          ]),
        ),
        ?trailing,
      ]);
}

class ProgressBar extends StatelessWidget {
  final double fraction;
  final Color color;
  final double height;
  const ProgressBar({super.key, required this.fraction, required this.color, this.height = 8});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: SizedBox(
          height: height,
          child: Stack(children: [
            Container(color: context.pal.track),
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99))),
            ),
          ]),
        ),
      );
}

class EmptyCard extends StatelessWidget {
  final String text;
  const EmptyCard(this.text, {super.key});
  @override
  Widget build(BuildContext context) => SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Center(
            child: Text(text,
                textAlign: TextAlign.center, style: T.secondary(context, size: 14))),
      );
}

/// One record row: category tile, title, subtitle, signed amount.
class RecordTile extends ConsumerWidget {
  final TxRow record;
  final bool showDivider;
  final double iconSize;
  final bool showDate;
  final VoidCallback onTap;
  const RecordTile({
    super.key,
    required this.record,
    required this.onTap,
    this.showDivider = true,
    this.iconSize = 44,
    this.showDate = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final cat = ref.watch(categoryMapProvider)[record.categoryId];
    final wallet = ref.watch(walletMapProvider)[record.walletId];
    final money = ref.watch(moneyProvider);
    final income = record.type == typeIncome;
    final note = record.note?.trim() ?? '';
    final title = note.isNotEmpty ? note : (cat?.name ?? 'Record');
    final time = DateFormat(showDate ? 'd MMM · h:mm a' : 'h:mm a').format(record.occurredAt);
    final sub = [
      if (note.isNotEmpty && cat != null) cat.name,
      time,
      ?wallet?.name,
    ].join(' · ');
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: showDivider ? Border(bottom: BorderSide(color: p.divider)) : null),
        child: Row(children: [
          CatIcon(
              icon: cat?.icon ?? 'more-horizontal',
              bg: cat?.colorBg ?? '#ECEEF1',
              fg: cat?.colorFg ?? '#4A5361',
              size: iconSize),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.row(context)),
              const SizedBox(height: 2),
              Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.secondary(context)),
            ]),
          ),
          const SizedBox(width: 8),
          Text(money.signed(record.amountCents, income: income),
              style: T.number(15, color: income ? p.income : p.expense)),
        ]),
      ),
    );
  }
}

/// Settings-style row with label, optional detail and chevron or trailing widget.
class SettingsRow extends StatelessWidget {
  final String label;
  final String? detail;
  final String? subtitle;
  final String? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool divider;
  const SettingsRow({
    super.key,
    required this.label,
    this.detail,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            border: divider ? Border(bottom: BorderSide(color: p.divider)) : null),
        child: Row(children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: p.background, borderRadius: BorderRadius.circular(11)),
              alignment: Alignment.center,
              child: AppIcon(icon!, size: 18, color: p.text),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: p.text)),
              if (subtitle != null) ...[
                const SizedBox(height: 1),
                Text(subtitle!, style: T.secondary(context)),
              ],
            ]),
          ),
          if (detail != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(detail!, style: T.secondary(context, size: 13)),
            ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: AppIcon('chevron-right', size: 18, color: p.muted),
            ),
        ]),
      ),
    );
  }
}

void showSnack(BuildContext context, String text, {String? action, VoidCallback? onAction}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 4),
    action: action == null ? null : SnackBarAction(label: action, onPressed: onAction ?? () {}),
  ));
}

Future<bool> confirmDialog(BuildContext context,
    {required String title, required String message, String confirm = 'Delete', bool danger = true}) async {
  final p = context.pal;
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title, style: T.section(c)),
      content: Text(message, style: T.secondary(c, size: 14)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        TextButton(
          style: danger ? TextButton.styleFrom(foregroundColor: p.expense) : null,
          onPressed: () => Navigator.pop(c, true),
          child: Text(confirm),
        ),
      ],
    ),
  );
  return r ?? false;
}
