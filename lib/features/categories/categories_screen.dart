import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../data/default_data.dart';
import '../../domain/calculations.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

final _monthCountsProvider = StreamProvider.autoDispose<Map<int, int>>((ref) =>
    ref.watch(transactionRepoProvider).watchCountsByCategory(ref.watch(currentMonthRangeProvider)));

class CategoriesScreen extends ConsumerStatefulWidget {
  final String? initialType;
  const CategoriesScreen({super.key, this.initialType});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  late String _type = widget.initialType == typeIncome ? typeIncome : typeExpense;
  List<CategoryRow>? _dragOrder;

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final all = ref.watch(categoriesProvider).value ?? const <CategoryRow>[];
    final counts = ref.watch(_monthCountsProvider).value ?? const <int, int>{};
    final list = _dragOrder ?? all.where((c) => c.type == _type).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(children: [
              const BackHeader(title: 'Categories'),
              const SizedBox(height: 16),
              SegmentedTabs<String>(
                values: const [typeExpense, typeIncome],
                selected: _type,
                label: (t) => t == typeExpense ? 'Expense' : 'Income',
                onChanged: (t) => setState(() {
                  _type = t;
                  _dragOrder = null;
                }),
              ),
              const SizedBox(height: 16),
            ]),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              buildDefaultDragHandles: false,
              itemCount: list.length,
              onReorderItem: (from, to) async {
                final next = [...list];
                next.insert(to, next.removeAt(from));
                setState(() => _dragOrder = next);
                await ref.read(categoryRepoProvider).reorder(next.map((c) => c.id).toList());
                if (mounted) setState(() => _dragOrder = null);
              },
              proxyDecorator: (child, _, _) => Material(color: Colors.transparent, elevation: 6, child: child),
              itemBuilder: (context, i) {
                final c = list[i];
                final n = counts[c.id] ?? 0;
                final first = i == 0, last = i == list.length - 1;
                return Container(
                  key: ValueKey(c.id),
                  padding: EdgeInsets.fromLTRB(16, first ? 4 : 0, 4, last ? 4 : 0),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(first ? 20 : 0), bottom: Radius.circular(last ? 20 : 0)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: p.divider))),
                    child: Row(children: [
                      CatIcon(icon: c.icon, bg: c.colorBg, fg: c.colorFg, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.name, style: T.row(context)),
                          Text(n == 0 ? 'No records this month' : '$n ${n == 1 ? 'record' : 'records'} this month',
                              style: T.secondary(context)),
                        ]),
                      ),
                      IconButton(
                        tooltip: 'Edit ${c.name}',
                        onPressed: () => _edit(c),
                        icon: AppIcon('pencil', size: 18, color: p.muted),
                      ),
                      ReorderableDragStartListener(
                        index: i,
                        child: Tooltip(
                          message: 'Reorder ${c.name}',
                          child: SizedBox(
                              width: 44, height: 44, child: Center(child: AppIcon('grip', size: 18, color: p.muted))),
                        ),
                      ),
                    ]),
                  ),
                );
              },
              footer: Column(key: const ValueKey('footer'), children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _edit(null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: p.text,
                      side: BorderSide(color: p.border, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontFamily: fontBody, fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    icon: AppIcon('plus', size: 18, color: p.text),
                    label: Text('Add ${_type == typeExpense ? 'expense' : 'income'} category'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pick an icon and colour for each category. Drag to change the order they appear in when adding a record.',
                  textAlign: TextAlign.center,
                  style: T.secondary(context, size: 13),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _edit(CategoryRow? c) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CategoryEditor(type: _type, existing: c),
    );
  }
}

class _CategoryEditor extends ConsumerStatefulWidget {
  final String type;
  final CategoryRow? existing;
  const _CategoryEditor({required this.type, this.existing});

  @override
  ConsumerState<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends ConsumerState<_CategoryEditor> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late String _icon = widget.existing?.icon ?? 'tag';
  late (String, String) _colors = widget.existing == null
      ? categoryColorPairs[2]
      : (widget.existing!.colorBg, widget.existing!.colorFg);
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name');
      return;
    }
    final repo = ref.read(categoryRepoProvider);
    try {
      if (widget.existing == null) {
        await repo.add(type: widget.type, name: name, icon: _icon, colorBg: _colors.$1, colorFg: _colors.$2);
      } else {
        await repo.edit(widget.existing!.id, name: name, icon: _icon, colorBg: _colors.$1, colorFg: _colors.$2);
      }
      if (mounted) Navigator.pop(context);
    } on ArgumentError catch (e) {
      setState(() => _error = e.message.toString());
    }
  }

  Future<void> _delete() async {
    final c = widget.existing!;
    final repo = ref.read(categoryRepoProvider);
    final count = await ref.read(transactionRepoProvider).countForCategory(c.id);
    if (!mounted) return;
    int? moveTo;
    if (count > 0) {
      final targets = (ref.read(categoriesProvider).value ?? const <CategoryRow>[])
          .where((x) => x.type == c.type && x.id != c.id)
          .toList();
      moveTo = await showDialog<int>(
        context: context,
        builder: (d) => SimpleDialog(
          title: Text('Move $count ${count == 1 ? 'record' : 'records'} to…', style: T.section(d)),
          children: [
            for (final t in targets)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(d, t.id),
                child: Row(children: [
                  CatIcon(icon: t.icon, bg: t.colorBg, fg: t.colorFg, size: 32),
                  const SizedBox(width: 12),
                  Text(t.name, style: T.row(d)),
                ]),
              ),
          ],
        ),
      );
      if (moveTo == null) return;
    } else {
      final ok = await confirmDialog(context,
          title: 'Delete ${c.name}?', message: 'Any budget for this category is removed too.');
      if (!ok) return;
    }
    await repo.delete(c.id, moveToId: moveTo);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final locked = widget.existing?.isLocked ?? false;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CatIcon(icon: _icon, bg: _colors.$1, fg: _colors.$2, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.existing == null ? 'New category' : 'Edit category', style: T.section(context)),
              ),
            ]),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              maxLength: 30,
              autofocus: widget.existing == null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: 'Name', errorText: _error),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 8),
            Text('Icon', style: T.section(context, size: 14)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final ic in categoryIconChoices)
                Semantics(
                  label: ic,
                  selected: ic == _icon,
                  button: true,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _icon = ic),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: ic == _icon ? p.text : Colors.transparent, width: 2),
                      ),
                      child: CatIcon(icon: ic, bg: _colors.$1, fg: _colors.$2, size: 40),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 16),
            Text('Colour', style: T.section(context, size: 14)),
            const SizedBox(height: 8),
            Wrap(spacing: 10, runSpacing: 10, children: [
              for (final pair in categoryColorPairs)
                Semantics(
                  label: 'Colour ${pair.$2}',
                  selected: pair == _colors,
                  button: true,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _colors = pair),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hexColor(pair.$1),
                        border: Border.all(color: pair == _colors ? p.text : p.border, width: pair == _colors ? 2.5 : 1),
                      ),
                      child: Center(
                        child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: hexColor(pair.$2))),
                      ),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              if (widget.existing != null && !locked)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: p.expense),
                  onPressed: _delete,
                  child: const Text('Delete'),
                ),
              if (locked)
                Expanded(
                    child: Text('This category can\'t be deleted.', style: T.secondary(context, size: 13)))
              else
                const Spacer(),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ]),
          ]),
        ),
      ),
    );
  }
}
