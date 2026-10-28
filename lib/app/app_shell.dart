import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/icons.dart';
import 'theme.dart';

/// Scaffold with the 84 px bottom bar: Home, Records, [+], Reports, More.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        height: 84 + (bottomInset > 0 ? bottomInset - 8 : 0),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        decoration: BoxDecoration(
          color: p.surface,
          border: Border(top: BorderSide(color: p.track)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tab(context, 0, 'Home', 'nav-home'),
            _tab(context, 1, 'Records', 'nav-list'),
            _addButton(context),
            _tab(context, 2, 'Reports', 'nav-reports'),
            _tab(context, 3, 'More', 'nav-more'),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int index, String label, String icon) {
    final p = context.pal;
    final active = shell.currentIndex == index;
    final color = active ? p.text : p.muted;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => shell.goBranch(index, initialLocation: index == shell.currentIndex),
        child: SizedBox(
          width: 64,
          height: 52,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppIcon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w700,
                    color: color)),
          ]),
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    final p = context.pal;
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Semantics(
        label: 'Add record',
        button: true,
        excludeSemantics: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x470F1B2D), blurRadius: 20, offset: Offset(0, 8)),
            ],
          ),
          child: Material(
            color: p.primary,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => context.push('/add'),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Center(
                    child: AppIcon('plus', size: 26, color: p.onPrimary, strokeWidth: 2.4)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
