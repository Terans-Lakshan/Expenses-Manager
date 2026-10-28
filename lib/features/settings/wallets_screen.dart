import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/database.dart';
import '../../widgets/common.dart';
import '../../widgets/icons.dart';

/// Wallets & accounts (FR-44): add, rename, archive, delete unused.
class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.pal;
    final wallets = ref.watch(walletsProvider).value ?? const <WalletRow>[];
    final active = wallets.where((w) => !w.isArchived).toList();
    final archived = wallets.where((w) => w.isArchived).toList();

    Widget list(List<WalletRow> ws) => Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            for (var i = 0; i < ws.length; i++)
              SettingsRow(
                icon: ws[i].icon,
                label: ws[i].name,
                divider: i < ws.length - 1,
                onTap: () => _edit(context, ref, ws[i]),
              ),
          ]),
        );

    return Scaffold(
      body: SafeArea(
        child: ListView(padding: screenPadding, children: [
          const BackHeader(title: 'Wallets & accounts'),
          const SizedBox(height: 16),
          if (active.isEmpty) const EmptyCard('No active wallets.') else list(active),
          if (archived.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
              child: Text('ARCHIVED',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.7, color: p.muted)),
            ),
            list(archived),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _edit(context, ref, null),
              style: OutlinedButton.styleFrom(
                foregroundColor: p.text,
                side: BorderSide(color: p.border, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontFamily: fontBody, fontWeight: FontWeight.w800, fontSize: 15),
              ),
              icon: AppIcon('plus', size: 18, color: p.text),
              label: const Text('Add wallet'),
            ),
          ),
          const SizedBox(height: 12),
          Text('Archived wallets keep their records but are hidden when adding new ones.',
              textAlign: TextAlign.center, style: T.secondary(context, size: 13)),
        ]),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, WalletRow? w) async {
    final name = TextEditingController(text: w?.name ?? '');
    var icon = w?.icon ?? 'wallet';
    final repo = ref.read(walletRepoProvider);
    final p = context.pal;
    final result = await showDialog<String>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (d, setState) => AlertDialog(
          title: Text(w == null ? 'New wallet' : 'Edit wallet', style: T.section(d)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: name,
              autofocus: w == null,
              maxLength: 30,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final ic in walletIconChoices)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => icon = ic),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: p.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ic == icon ? p.text : Colors.transparent, width: 2),
                    ),
                    child: Center(child: AppIcon(ic, color: p.text)),
                  ),
                ),
            ]),
          ]),
          actions: [
            if (w != null)
              TextButton(
                onPressed: () => Navigator.pop(d, w.isArchived ? 'unarchive' : 'archive'),
                child: Text(w.isArchived ? 'Restore' : 'Archive'),
              ),
            if (w != null)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: p.expense),
                onPressed: () => Navigator.pop(d, 'delete'),
                child: const Text('Delete'),
              ),
            TextButton(onPressed: () => Navigator.pop(d, 'save'), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (result == null) return;
    switch (result) {
      case 'save':
        if (name.text.trim().isEmpty) return;
        if (w == null) {
          await repo.add(name.text, icon);
        } else {
          await repo.edit(w.id, name: name.text, icon: icon);
        }
      case 'archive':
        final activeCount = (ref.read(walletsProvider).value ?? const <WalletRow>[]).where((x) => !x.isArchived).length;
        if (activeCount <= 1) {
          if (context.mounted) showSnack(context, 'Keep at least one active wallet.');
          return;
        }
        await repo.setArchived(w!.id, true);
      case 'unarchive':
        await repo.setArchived(w!.id, false);
      case 'delete':
        if (!await repo.deleteIfUnused(w!.id) && context.mounted) {
          showSnack(context, '${w.name} has records, so it was archived instead.');
          await repo.setArchived(w.id, true);
        }
    }
  }
}
