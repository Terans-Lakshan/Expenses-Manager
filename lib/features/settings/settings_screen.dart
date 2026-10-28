import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../domain/calculations.dart';
import '../../domain/period.dart';
import '../../services/app_lock.dart';
import '../../services/backup.dart';
import '../../services/export.dart';
import '../../services/file_output.dart';
import '../../services/notifications.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

const appVersion = '1.0.0';

const _currencies = <(String, String, String)>[
  ('LKR', 'Rs', 'Sri Lankan rupee'),
  ('INR', '₹', 'Indian rupee'),
  ('USD', '\$', 'US dollar'),
  ('EUR', '€', 'Euro'),
  ('GBP', '£', 'British pound'),
  ('AUD', 'A\$', 'Australian dollar'),
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final s = ref.watch(settingsProvider);
    final money = ref.watch(moneyProvider);
    final cats = ref.watch(categoriesProvider).value ?? const <CategoryRow>[];
    final wallets = (ref.watch(walletsProvider).value ?? const <WalletRow>[]).where((w) => !w.isArchived);
    final rules = ref.watch(recurringRulesProvider).value ?? const <RecurringRuleRow>[];
    final catMap = ref.watch(categoryMapProvider);
    final overall = (ref.watch(budgetsProvider).value ?? const <BudgetRow>[])
        .where((b) => b.categoryId == null)
        .firstOrNull;
    final nExp = cats.where((c) => c.type == typeExpense).length;
    final nInc = cats.length - nExp;
    final ruleNames = rules.map((r) => r.note?.isNotEmpty == true ? r.note! : (catMap[r.categoryId]?.name ?? '')).toSet();
    final settings = ref.read(settingsProvider.notifier);

    Widget group(List<Widget> rows) => Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(children: rows),
        );
    Widget heading(String t) => Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Semantics(
            header: true,
            child: Text(t.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.7, color: p.muted)),
          ),
        );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: screenPadding.copyWith(top: 20),
        children: [
          Semantics(header: true, child: Text('More', style: T.title(context))),
          const SizedBox(height: 16),
          SurfaceCard(
            onTap: () => _editName(context, ref),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(16)),
                child: Text(s.profileName.isEmpty ? '?' : s.profileName.trim()[0].toUpperCase(),
                    style: T.number(20, weight: FontWeight.w700, color: p.onCard)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.profileName.isEmpty ? 'Add your name' : s.profileName, style: T.row(context).copyWith(fontSize: 16)),
                  Text('Profile', style: T.secondary(context, size: 13)),
                ]),
              ),
              AppIcon('chevron-right', size: 18, color: p.muted),
            ]),
          ),
          heading('Money'),
          group([
            SettingsRow(
                icon: 'pie',
                label: 'Budgets',
                detail: overall == null ? 'Not set' : '${money.format(overall.limitCents)} / mo',
                onTap: () => context.push('/budgets')),
            SettingsRow(
                icon: 'tag', label: 'Categories', detail: '$nExp expense · $nInc income', onTap: () => context.push('/categories')),
            SettingsRow(
                icon: 'repeat',
                label: 'Recurring records',
                detail: rules.isEmpty ? 'None' : _short(ruleNames.join(', ')),
                onTap: () => context.push('/recurring')),
            SettingsRow(
                icon: 'wallet',
                label: 'Wallets & accounts',
                detail: _short(wallets.map((w) => w.name).join(', ')),
                divider: false,
                onTap: () => context.push('/wallets')),
          ]),
          heading('Preferences'),
          group([
            SettingsRow(
                label: 'Currency', detail: '${s.currencyCode} · ${s.currencySymbol}', onTap: () => _pickCurrency(context, ref)),
            SettingsRow(
                label: 'Week starts on',
                detail: DateFormat('EEEE').format(DateTime(2024, 1, s.weekStart)), // 1 Jan 2024 was a Monday
                onTap: () => _pickWeekStart(context, ref)),
            SettingsRow(label: 'Language', detail: 'English', onTap: () => _pickLanguage(context)),
            SettingsRow(
                label: 'Theme',
                detail: switch (s.theme) {
                  ThemeMode.system => 'System',
                  ThemeMode.light => 'Light',
                  ThemeMode.dark => 'Dark',
                },
                divider: false,
                onTap: () => _pickTheme(context, ref)),
          ]),
          heading('Security & reminders'),
          group([
            SettingsRow(
              icon: 'lock',
              label: 'App lock',
              subtitle: 'PIN or fingerprint when opening',
              trailing: Switch(
                value: s.appLock,
                onChanged: (v) async {
                  if (v) {
                    if (!await appLockService.isAvailable()) {
                      if (context.mounted) showSnack(context, 'Set up a screen lock on this device first.');
                      return;
                    }
                    if (!await appLockService.authenticate(reason: 'Confirm to turn on App lock')) return;
                  }
                  settings.update((x) => x.copyWith(appLock: v));
                },
              ),
            ),
            SettingsRow(
              icon: 'bell',
              label: 'Daily reminder',
              subtitle: 'Log today\'s spending · ${s.reminderTime.format(context)}',
              onTap: s.reminderEnabled ? () => _pickReminderTime(context, ref) : null,
              divider: false,
              trailing: Switch(
                value: s.reminderEnabled,
                onChanged: (v) async {
                  await settings.update((x) => x.copyWith(reminderEnabled: v));
                  if (v) {
                    await notificationService.requestPermission();
                    await notificationService.scheduleDailyReminder(s.reminderTime);
                  } else {
                    await notificationService.cancelDailyReminder();
                  }
                },
              ),
            ),
          ]),
          heading('Data'),
          group([
            SettingsRow(icon: 'download', label: 'Export records', detail: 'CSV · PDF', onTap: () => _export(context, ref)),
            SettingsRow(
              icon: 'database',
              label: 'Backup & restore',
              subtitle: s.lastBackupAt == null
                  ? 'No backup yet'
                  : 'Last backup: ${DateFormat('d MMM y, h:mm a').format(s.lastBackupAt!)}',
              divider: false,
              onTap: () => _backup(context, ref),
            ),
          ]),
          const SizedBox(height: 24),
          Center(child: Text('Version $appVersion', style: T.secondary(context, size: 13))),
        ],
      ),
    );
  }

  String _short(String s) => s.length > 22 ? '${s.substring(0, 21)}…' : s;

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final c = TextEditingController(text: ref.read(settingsProvider).profileName);
    final name = await showDialog<String>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('Your name', style: T.section(d)),
        content: TextField(
          controller: c,
          autofocus: true,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (v) => Navigator.pop(d, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(d, c.text), child: const Text('Save')),
        ],
      ),
    );
    if (name != null) {
      await ref.read(settingsProvider.notifier).update((s) => s.copyWith(profileName: name.trim()));
    }
  }

  Future<V?> _choose<V>(BuildContext context, String title, List<(V, String)> options, V current) =>
      showDialog<V>(
        context: context,
        builder: (d) => SimpleDialog(
          title: Text(title, style: T.section(d)),
          children: [
            RadioGroup<V>(
              groupValue: current,
              onChanged: (v) => Navigator.pop(d, v),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final (v, label) in options)
                  RadioListTile<V>(value: v, title: Text(label, style: T.row(d))),
              ]),
            ),
          ],
        ),
      );

  Future<void> _pickCurrency(BuildContext context, WidgetRef ref) async {
    final s = ref.read(settingsProvider);
    final v = await _choose<String>(
        context, 'Currency', [for (final c in _currencies) (c.$1, '${c.$3} (${c.$2})')], s.currencyCode);
    if (v == null) return;
    final c = _currencies.firstWhere((c) => c.$1 == v);
    await ref.read(settingsProvider.notifier).update((s) => s.copyWith(currencyCode: c.$1, currencySymbol: c.$2));
  }

  Future<void> _pickWeekStart(BuildContext context, WidgetRef ref) async {
    final v = await _choose<int>(
        context,
        'Week starts on',
        const [(DateTime.monday, 'Monday'), (DateTime.saturday, 'Saturday'), (DateTime.sunday, 'Sunday')],
        ref.read(settingsProvider).weekStart);
    if (v != null) await ref.read(settingsProvider.notifier).update((s) => s.copyWith(weekStart: v));
  }

  Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
    final v = await _choose<ThemeMode>(
        context,
        'Theme',
        const [(ThemeMode.system, 'System'), (ThemeMode.light, 'Light'), (ThemeMode.dark, 'Dark')],
        ref.read(settingsProvider).theme);
    if (v != null) await ref.read(settingsProvider.notifier).update((s) => s.copyWith(theme: v));
  }

  Future<void> _pickLanguage(BuildContext context) => showDialog(
        context: context,
        builder: (d) => AlertDialog(
          title: Text('Language', style: T.section(d)),
          content: Text('English is available now. Sinhala and Tamil are coming in a later version.',
              style: T.secondary(d, size: 14)),
          actions: [TextButton(onPressed: () => Navigator.pop(d), child: const Text('OK'))],
        ),
      );

  Future<void> _pickReminderTime(BuildContext context, WidgetRef ref) async {
    final t = await showTimePicker(context: context, initialTime: ref.read(settingsProvider).reminderTime);
    if (t == null) return;
    await ref.read(settingsProvider.notifier).update((s) => s.copyWith(reminderTime: t));
    await notificationService.scheduleDailyReminder(t);
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final choice = await showModalBottomSheet<_ExportChoice>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _ExportSheet(),
    );
    if (choice == null || !context.mounted) return;
    final records = await ref.read(transactionRepoProvider).range(choice.range);
    final cats = ref.read(categoryMapProvider);
    final wallets = ref.read(walletMapProvider);
    final stamp = '${DateFormat('yyyyMMdd').format(choice.range.start)}-'
        '${DateFormat('yyyyMMdd').format(DateTime(choice.range.end.year, choice.range.end.month, choice.range.end.day - 1))}';
    String? msg;
    if (!context.mounted) return;
    if (choice.pdf) {
      final bytes = await recordsToPdf(
          records: records, cats: cats, wallets: wallets, range: choice.range, money: ref.read(moneyProvider));
      if (!context.mounted) return;
      msg = await deliverFile(context,
          fileName: 'expense-records-$stamp.pdf', bytes: bytes, mimeType: 'application/pdf', subject: 'Expense records');
    } else {
      msg = await deliverFile(context,
          fileName: 'expense-records-$stamp.csv',
          bytes: csvBytes(recordsToCsv(records, cats, wallets)),
          mimeType: 'text/csv',
          subject: 'Expense records');
    }
    if (msg != null && context.mounted) showSnack(context, '$msg · ${records.length} records');
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SettingsRow(
              icon: 'upload',
              label: 'Create backup',
              subtitle: 'Save all records, categories, budgets and settings to one file',
              onTap: () => Navigator.pop(c, 'backup')),
          SettingsRow(
              icon: 'download',
              label: 'Restore from backup',
              subtitle: 'Replaces everything in the app with the file\'s data',
              divider: false,
              onTap: () => Navigator.pop(c, 'restore')),
          const SizedBox(height: 8),
        ]),
      ),
    );
    if (action == null || !context.mounted) return;
    final db = ref.read(databaseProvider);
    if (action == 'backup') {
      final bytes = await createBackup(db, ref.read(settingsProvider));
      if (!context.mounted) return;
      final msg = await deliverFile(context,
          fileName: 'expense-manager-backup-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.json',
          bytes: bytes,
          mimeType: 'application/json',
          subject: 'Expense Manager backup');
      if (msg != null) {
        await ref.read(settingsProvider.notifier).update((s) => s.copyWith(lastBackupAt: DateTime.now()));
        if (context.mounted) showSnack(context, msg);
      }
      return;
    }
    final files = await FilePicker.pickFiles(
        dialogTitle: 'Choose a backup file', type: FileType.custom, allowedExtensions: ['json']);
    if (files.isEmpty || !context.mounted) return;
    try {
      final contents = readBackup(await files.first.readAsBytes());
      if (!context.mounted) return;
      final ok = await confirmDialog(context,
          title: 'Restore this backup?',
          message: 'It has ${contents.records} records. Everything currently in the app will be replaced.',
          confirm: 'Restore');
      if (!ok) return;
      await restoreBackup(db, contents);
      await ref.read(settingsProvider.notifier).replace(
          contents.settings.copyWith(lastBackupAt: ref.read(settingsProvider).lastBackupAt));
      if (contents.settings.reminderEnabled) {
        await notificationService.scheduleDailyReminder(contents.settings.reminderTime);
      } else {
        await notificationService.cancelDailyReminder();
      }
      if (context.mounted) showSnack(context, 'Backup restored · ${contents.records} records');
    } on FormatException catch (e) {
      if (context.mounted) showSnack(context, e.message);
    } catch (e) {
      if (context.mounted) showSnack(context, 'Restore failed. Your data was not changed.');
    }
  }
}

class _ExportChoice {
  final DateRange range;
  final bool pdf;
  const _ExportChoice(this.range, this.pdf);
}

class _ExportSheet extends StatefulWidget {
  const _ExportSheet();
  @override
  State<_ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<_ExportSheet> {
  String _preset = 'this_month';
  DateRange? _custom;
  bool _pdf = false;

  DateRange get _range {
    final now = DateTime.now();
    return switch (_preset) {
      'last_month' => periodRange(PeriodKind.month, DateTime(now.year, now.month - 1)),
      'this_year' => periodRange(PeriodKind.year, now),
      'all' => DateRange(DateTime(1970), DateTime(now.year + 100)),
      'custom' => _custom ?? periodRange(PeriodKind.month, now),
      _ => periodRange(PeriodKind.month, now),
    };
  }

  Future<void> _pickCustom() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(now.year + 5));
    if (r != null) {
      setState(() {
        _custom = customRange(r.start, r.end);
        _preset = 'custom';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const presets = [
      ('this_month', 'This month'),
      ('last_month', 'Last month'),
      ('this_year', 'This year'),
      ('all', 'All time'),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Export records', style: T.section(context)),
          const SizedBox(height: 14),
          Text('Range', style: T.secondary(context, size: 13)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final (k, label) in presets)
              Pill(label: label, selected: _preset == k, onTap: () => setState(() => _preset = k)),
            Pill(
              label: _preset == 'custom' && _custom != null ? periodLabel(PeriodKind.custom, _custom!) : 'Custom…',
              selected: _preset == 'custom',
              onTap: _pickCustom,
            ),
          ]),
          const SizedBox(height: 16),
          Text('Format', style: T.secondary(context, size: 13)),
          const SizedBox(height: 8),
          SegmentedTabs<bool>(
            values: const [false, true],
            selected: _pdf,
            label: (v) => v ? 'PDF' : 'CSV',
            onChanged: (v) => setState(() => _pdf = v),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context, _ExportChoice(_range, _pdf)),
              child: const Text('Export'),
            ),
          ),
        ]),
      ),
    );
  }
}
