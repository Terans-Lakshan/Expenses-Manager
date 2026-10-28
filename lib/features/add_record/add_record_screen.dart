import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/money.dart';
import '../../domain/period.dart';
import '../../services/budget_alerts.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

const _lastWalletKey = 'last_wallet_id';
String _lastCategoryKey(String type) => 'last_category_$type';

class AddRecordScreen extends ConsumerStatefulWidget {
  final int? recordId;
  final String? initialType;
  const AddRecordScreen({super.key, this.recordId, this.initialType});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String _type = typeExpense;
  int? _categoryId;
  int? _walletId;
  DateTime _when = DateTime.now();
  String? _receiptPath;
  bool _repeat = false;
  String? _amountError;
  String? _categoryError;
  bool _saving = false;
  TxRow? _original;
  bool _loading = false;

  bool get _editing => widget.recordId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) {
      _loading = true;
      _load();
    } else {
      if (widget.initialType == typeIncome) _type = typeIncome;
      final s = ref.read(settingsRepoProvider);
      _walletId = s.getInt(_lastWalletKey);
      _categoryId = s.getInt(_lastCategoryKey(_type));
    }
  }

  Future<void> _load() async {
    final r = await ref.read(transactionRepoProvider).byId(widget.recordId!);
    if (!mounted) return;
    if (r == null) {
      context.pop();
      return;
    }
    setState(() {
      _original = r;
      _type = r.type;
      _amount.text = centsToInput(r.amountCents);
      _categoryId = r.categoryId;
      _walletId = r.walletId;
      _when = r.occurredAt;
      _note.text = r.note ?? '';
      _receiptPath = r.receiptPath;
      _repeat = r.recurringRuleId != null;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _setType(String t) {
    if (t == _type) return;
    final cats = ref.read(categoryMapProvider);
    setState(() {
      _type = t;
      _categoryError = null;
      if (_categoryId == null || cats[_categoryId]?.type != t) {
        final last = ref.read(settingsRepoProvider).getInt(_lastCategoryKey(t));
        _categoryId = cats[last]?.type == t ? last : null;
      }
    });
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_when));
    if (!mounted) return;
    final time = t ?? TimeOfDay.fromDateTime(_when);
    setState(() => _when = DateTime(d.year, d.month, d.day, time.hour, time.minute));
  }

  Future<void> _receipt() async {
    final picker = ImagePicker();
    final canCamera = picker.supportsImageSource(ImageSource.camera);
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (_receiptPath != null && File(_receiptPath!).existsSync())
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(_receiptPath!), height: 220, fit: BoxFit.cover),
              ),
            ),
          if (canCamera)
            SettingsRow(label: 'Take photo', icon: 'camera', onTap: () => Navigator.pop(c, 'camera')),
          SettingsRow(label: 'Choose from gallery', icon: 'image', onTap: () => Navigator.pop(c, 'gallery')),
          if (_receiptPath != null)
            SettingsRow(
                label: 'Remove receipt', icon: 'trash', divider: false, onTap: () => Navigator.pop(c, 'remove')),
          const SizedBox(height: 8),
        ]),
      ),
    );
    if (choice == null) return;
    if (choice == 'remove') {
      setState(() => _receiptPath = null);
      return;
    }
    try {
      final x = await picker.pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 2000,
        imageQuality: 80,
      );
      if (x == null) return;
      // Keep receipts in app-private storage.
      final dir = Directory(p.join((await getApplicationSupportDirectory()).path, 'receipts'));
      await dir.create(recursive: true);
      final dest = p.join(dir.path, 'receipt_${DateTime.now().millisecondsSinceEpoch}${p.extension(x.path)}');
      await File(x.path).copy(dest);
      if (mounted) setState(() => _receiptPath = dest);
    } catch (e) {
      if (mounted) showSnack(context, 'Could not attach the photo.');
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    final parsed = parseAmount(_amount.text);
    final cats = ref.read(categoryMapProvider);
    final catOk = _categoryId != null && cats[_categoryId]?.type == _type;
    setState(() {
      _amountError = parsed.error;
      _categoryError = catOk ? null : 'Pick an ${_type == typeIncome ? 'income' : 'expense'} category';
    });
    if (parsed.cents == null || !catOk) return;

    final wallets = ref.read(walletsProvider).value ?? const <WalletRow>[];
    final walletId = _walletId != null && wallets.any((w) => w.id == _walletId)
        ? _walletId!
        : wallets.firstWhere((w) => !w.isArchived, orElse: () => wallets.first).id;

    setState(() => _saving = true);
    final repo = ref.read(transactionRepoProvider);
    final recurring = ref.read(recurringRepoProvider);
    final settingsRepo = ref.read(settingsRepoProvider);
    final messenger = ScaffoldMessenger.of(context);
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    final cents = parsed.cents!;

    try {
      VoidCallback undo;
      if (_original == null) {
        int? ruleId;
        if (_repeat) {
          ruleId = await recurring.createFromRecord(
              type: _type, amountCents: cents, categoryId: _categoryId!, walletId: walletId, firstAt: _when, note: note);
        }
        final id = await repo.add(
          type: _type,
          amountCents: cents,
          categoryId: _categoryId!,
          walletId: walletId,
          occurredAt: _when,
          note: note,
          receiptPath: _receiptPath,
          recurringRuleId: ruleId,
        );
        undo = () async {
          await repo.delete(id);
          if (ruleId != null) await recurring.delete(ruleId);
        };
      } else {
        final before = _original!;
        int? ruleId = before.recurringRuleId;
        if (_repeat && ruleId == null) {
          ruleId = await recurring.createFromRecord(
              type: _type, amountCents: cents, categoryId: _categoryId!, walletId: walletId, firstAt: _when, note: note);
        } else if (!_repeat && ruleId != null) {
          await recurring.delete(ruleId);
          ruleId = null;
        }
        await repo.update(before.copyWith(
          type: _type,
          amountCents: cents,
          categoryId: _categoryId!,
          walletId: walletId,
          occurredAt: _when,
          note: Value(note),
          receiptPath: Value(_receiptPath),
          recurringRuleId: Value(ruleId),
        ));
        undo = () => repo.update(before);
      }
      await settingsRepo.setInt(_lastWalletKey, walletId);
      await settingsRepo.setInt(_lastCategoryKey(_type), _categoryId!);
      if (_type == typeExpense) {
        checkBudgetAlerts(
          settingsRepo: settingsRepo,
          settings: ref.read(settingsProvider),
          budgets: ref.read(budgetRepoProvider),
          categories: ref.read(categoryRepoProvider),
          transactions: repo,
        );
      }
      if (!mounted) return;
      context.pop();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
        content: Text(_original == null ? 'Record saved' : 'Record updated'),
        action: SnackBarAction(label: 'Undo', onPressed: undo),
      ));
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showSnack(context, 'Could not save: $e');
      }
    }
  }

  Future<void> _delete() async {
    final r = _original;
    if (r == null) return;
    final ok = await confirmDialog(context,
        title: 'Delete this record?', message: 'It will be removed from all totals.');
    if (!ok || !mounted) return;
    final repo = ref.read(transactionRepoProvider);
    final messenger = ScaffoldMessenger.of(context);
    await repo.delete(r.id);
    if (!mounted) return;
    context.pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: const Text('Record deleted'),
      action: SnackBarAction(label: 'Undo', onPressed: () => repo.restore(r)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final accent = _type == typeIncome ? pal.income : pal.expense;
    final allCats = ref.watch(categoriesProvider).value ?? const <CategoryRow>[];
    final cats = allCats.where((c) => c.type == _type).toList();
    final wallets = (ref.watch(walletsProvider).value ?? const <WalletRow>[])
        .where((w) => !w.isArchived || w.id == _walletId)
        .toList();
    final selectedWallet = wallets.any((w) => w.id == _walletId)
        ? _walletId
        : wallets.where((w) => !w.isArchived).firstOrNull?.id;
    final symbol = ref.watch(moneyProvider).symbol;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              children: [
                Row(children: [
                  SquareIconButton(icon: 'close', tooltip: 'Close', onTap: () => context.pop()),
                  Expanded(
                    child: Text(_editing ? 'Edit record' : 'New record',
                        textAlign: TextAlign.center, style: T.section(context)),
                  ),
                  if (_editing)
                    SquareIconButton(icon: 'trash', tooltip: 'Delete record', onTap: _delete)
                  else
                    const SizedBox(width: 44, height: 44),
                ]),
                const SizedBox(height: 16),
                SegmentedTabs<String>(
                  values: const [typeExpense, typeIncome],
                  selected: _type,
                  label: (t) => t == typeExpense ? 'Expense' : 'Income',
                  height: 44,
                  radius: 16,
                  selectedBg: (t) => t == typeExpense ? pal.expense : pal.income,
                  selectedFg: (_) => Colors.white,
                  onChanged: _setType,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  decoration: BoxDecoration(color: pal.surface, borderRadius: BorderRadius.circular(20)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Amount', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: pal.muted)),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Text(symbol, style: T.number(22, color: accent)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amount,
                          autofocus: !_editing,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                          onChanged: (_) {
                            if (_amountError != null) setState(() => _amountError = null);
                          },
                          style: T.number(40, weight: FontWeight.w700, color: accent),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: T.number(40, weight: FontWeight.w700, color: accent.withValues(alpha: 0.35)),
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ]),
                    if (_amountError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(_amountError!,
                            style: TextStyle(color: pal.expense, fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                  ]),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: Text('Category', style: T.section(context, size: 15))),
                  TextButton(onPressed: () => context.push('/categories?type=$_type'), child: const Text('Edit')),
                ]),
                if (_categoryError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_categoryError!,
                        style: TextStyle(color: pal.expense, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                GridView.count(
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.78,
                  children: [
                    for (final c in cats)
                      Semantics(
                        selected: c.id == _categoryId,
                        button: true,
                        label: c.name,
                        excludeSemantics: true,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() {
                            _categoryId = c.id;
                            _categoryError = null;
                          }),
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                    color: c.id == _categoryId ? accent : Colors.transparent, width: 2),
                              ),
                              child: CatIcon(icon: c.icon, bg: c.colorBg, fg: c.colorFg, size: 44),
                            ),
                            const SizedBox(height: 5),
                            Text(c.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: pal.text,
                                    fontWeight: c.id == _categoryId ? FontWeight.w800 : FontWeight.w600)),
                          ]),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: pal.surface, borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    InkWell(
                      onTap: _pickDateTime,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 56),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: pal.divider))),
                        child: Row(children: [
                          AppIcon('calendar', color: pal.muted),
                          const SizedBox(width: 12),
                          Expanded(child: Text(_dateLabel(_when), style: T.row(context).copyWith(fontSize: 14))),
                          Text(DateFormat('h:mm a').format(_when), style: T.secondary(context, size: 13)),
                        ]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: pal.divider))),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_type == typeIncome ? 'Received in' : 'Paid with',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: pal.muted)),
                        const SizedBox(height: 10),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final w in wallets)
                            Pill(
                                label: w.name,
                                selected: w.id == selectedWallet,
                                onTap: () => setState(() => _walletId = w.id)),
                        ]),
                      ]),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: pal.divider))),
                      child: Row(children: [
                        AppIcon('pencil', color: pal.muted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _note,
                            maxLength: 200,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: pal.text),
                            decoration: InputDecoration(
                              hintText: 'Add a note (optional)',
                              hintStyle: TextStyle(color: pal.muted, fontWeight: FontWeight.w600),
                              filled: false,
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    InkWell(
                      onTap: _receipt,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 56),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: pal.divider))),
                        child: Row(children: [
                          AppIcon('camera', color: pal.muted),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(_receiptPath == null ? 'Attach receipt photo' : 'Receipt attached',
                                style: T.row(context).copyWith(fontSize: 14)),
                          ),
                          if (_receiptPath != null && File(_receiptPath!).existsSync())
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(File(_receiptPath!), width: 36, height: 36, fit: BoxFit.cover),
                              ),
                            ),
                          AppIcon('chevron-right', size: 18, color: pal.muted),
                        ]),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      child: Row(children: [
                        AppIcon('repeat', color: pal.muted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Repeat every month', style: T.row(context).copyWith(fontSize: 14)),
                            Text(
                                _repeat
                                    ? 'On day ${_when.day} of each month${_when.day > 28 ? ' (or the last day)' : ''}'
                                    : 'Off',
                                style: T.secondary(context)),
                          ]),
                        ),
                        Switch(
                          value: _repeat,
                          onChanged: (v) => setState(() => _repeat = v),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
                color: pal.background, border: Border(top: BorderSide(color: pal.track))),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontFamily: fontBody, fontSize: 16, fontWeight: FontWeight.w800)),
                icon: AppIcon('check', color: pal.onPrimary, strokeWidth: 2.4),
                label: Text(_editing
                    ? 'Save changes'
                    : (_type == typeIncome ? 'Save income' : 'Save expense')),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String _dateLabel(DateTime t) {
    final d = dateOnly(t), today = dateOnly(DateTime.now());
    final base = DateFormat('d MMM y').format(t);
    if (d == today) return 'Today, $base';
    if (d == DateTime(today.year, today.month, today.day - 1)) return 'Yesterday, $base';
    return DateFormat('EEE, d MMM y').format(t);
  }
}
