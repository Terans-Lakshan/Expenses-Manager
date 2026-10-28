import '../data/repositories/category_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/wallet_budget_repositories.dart';
import '../domain/calculations.dart';
import '../domain/money.dart';
import '../domain/period.dart';
import 'notifications.dart';

/// After an expense is saved, sends one notification per budget per month when
/// it first reaches the alert threshold (80%) and once more when it goes over.
Future<void> checkBudgetAlerts({
  required SettingsRepository settingsRepo,
  required AppSettings settings,
  required BudgetRepository budgets,
  required CategoryRepository categories,
  required TransactionRepository transactions,
}) async {
  if (!settings.budgetAlertsEnabled) return;
  final now = DateTime.now();
  final month = periodRange(PeriodKind.month, now);
  final list = await budgets.all();
  if (list.isEmpty) return;
  final records = (await transactions.range(month)).where((r) => r.type == typeExpense);
  final cats = {for (final c in await categories.all()) c.id: c};
  final money = Money(settings.currencySymbol);
  final monthKey = '${now.year}${now.month.toString().padLeft(2, '0')}';

  for (final b in list) {
    final spent = records
        .where((r) => b.categoryId == null || r.categoryId == b.categoryId)
        .fold<int>(0, (s, r) => s + r.amountCents);
    final status = BudgetStatus(spent, b.limitCents, alertAt: settings.budgetAlertAt);
    final name = b.categoryId == null ? 'Monthly budget' : (cats[b.categoryId]?.name ?? 'Budget');
    if (status.state == BudgetState.over) {
      final key = 'alert_${b.id}_${monthKey}_over';
      if (!settingsRepo.flag(key)) {
        await settingsRepo.setFlag(key);
        await notificationService.showBudgetAlert(b.id, '$name is over budget',
            'Over by ${money.format(status.overByCents)} this month.');
      }
    } else if (status.state != BudgetState.normal) {
      final key = 'alert_${b.id}_${monthKey}_warn';
      if (!settingsRepo.flag(key)) {
        await settingsRepo.setFlag(key);
        await notificationService.showBudgetAlert(b.id, '$name is ${status.percent.round()}% used',
            '${money.format(status.remainingCents)} left of ${money.format(b.limitCents)}.');
      }
    }
  }
}
