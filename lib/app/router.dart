import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/add_record/add_record_screen.dart';
import '../features/budgets/budgets_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/home/home_screen.dart';
import '../features/records/records_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/recurring_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/wallets_screen.dart';
import 'app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Bottom bar shell (Home, Records, +, Reports, More) plus pushed screens.
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/records',
            builder: (_, state) =>
                RecordsScreen(focusSearch: state.uri.queryParameters['search'] == '1'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/reports', builder: (_, _) => const ReportsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/more', builder: (_, _) => const SettingsScreen()),
        ]),
      ],
    ),
    GoRoute(
      path: '/add',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, state) => MaterialPage(
        fullscreenDialog: true,
        child: AddRecordScreen(initialType: state.uri.queryParameters['type']),
      ),
    ),
    GoRoute(
      path: '/record/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) =>
          AddRecordScreen(recordId: int.tryParse(state.pathParameters['id'] ?? '')),
    ),
    GoRoute(
      path: '/budgets',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, _) => const BudgetsScreen(),
    ),
    GoRoute(
      path: '/categories',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) =>
          CategoriesScreen(initialType: state.uri.queryParameters['type']),
    ),
    GoRoute(
      path: '/wallets',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, _) => const WalletsScreen(),
    ),
    GoRoute(
      path: '/recurring',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, _) => const RecurringScreen(),
    ),
  ],
);
