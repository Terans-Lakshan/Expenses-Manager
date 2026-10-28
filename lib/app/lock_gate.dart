import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_lock.dart';
import '../services/recurring_runner.dart';
import '../widgets/icons.dart';
import 'providers.dart';
import 'theme.dart';

/// Shows the lock screen on open and after 1 minute in the background when
/// App lock is on. Also runs due recurring records when the app resumes.
class LockGate extends ConsumerStatefulWidget {
  final Widget child;
  const LockGate({super.key, required this.child});

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  static const relockAfter = Duration(minutes: 1);
  late bool _locked;
  bool _authenticating = false;
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locked = ref.read(settingsProvider).appLock;
    if (_locked) WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_authenticating) return; // the OS prompt itself pauses the app
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final away = _backgroundedAt;
      _backgroundedAt = null;
      ref.invalidate(currentMonthRangeProvider);
      runRecurring(ref.read(recurringRepoProvider));
      if (ref.read(settingsProvider).appLock &&
          away != null &&
          DateTime.now().difference(away) >= relockAfter) {
        setState(() => _locked = true);
        _unlock();
      }
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    _authenticating = true;
    final ok = await appLockService.authenticate();
    _authenticating = false;
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_locked) return widget.child;
    final p = context.pal;
    return Stack(children: [
      Offstage(child: widget.child),
      Positioned.fill(
        child: Material(
          color: p.background,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(24)),
                    alignment: Alignment.center,
                    child: AppIcon('lock', size: 32, color: p.onCard),
                  ),
                  const SizedBox(height: 20),
                  Text('Expense Manager is locked', style: T.section(context)),
                  const SizedBox(height: 6),
                  Text('Use your fingerprint, face or device PIN to continue.',
                      textAlign: TextAlign.center, style: T.secondary(context, size: 14)),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _unlock, child: const Text('Unlock')),
                ]),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
