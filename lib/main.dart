import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/lock_gate.dart';
import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'data/database.dart';
import 'data/repositories/recurring_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'services/notifications.dart';
import 'services/recurring_runner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase(); // seeds default categories and wallets on first launch
  await runRecurring(RecurringRepository(db));

  // Notifications are not needed to show Home, so don't block startup on them.
  final settings = SettingsRepository(prefs).load();
  notificationService.init().then((_) {
    if (settings.reminderEnabled) {
      notificationService.scheduleDailyReminder(settings.reminderTime);
    }
  });

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPrefsProvider.overrideWithValue(prefs),
    ],
    child: const ExpenseManagerApp(),
  ));
}

class ExpenseManagerApp extends ConsumerWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(settingsProvider.select((s) => s.theme));
    return MaterialApp.router(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: theme,
      routerConfig: router,
      builder: (context, child) => LockGate(child: child ?? const SizedBox()),
    );
  }
}
