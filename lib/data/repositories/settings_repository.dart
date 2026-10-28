import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/period.dart';

/// Key–value settings (PRD section 7), stored in shared_preferences.
class AppSettings {
  final String currencyCode;
  final String currencySymbol;
  final int weekStart; // DateTime.monday .. DateTime.sunday
  final String language;
  final ThemeMode theme;
  final bool appLock;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final double budgetAlertAt;
  final bool budgetAlertsEnabled;
  final String profileName;
  final PeriodKind lastPeriodHome;
  final DateTime? lastBackupAt;

  const AppSettings({
    this.currencyCode = 'LKR',
    this.currencySymbol = 'Rs',
    this.weekStart = DateTime.monday,
    this.language = 'en',
    this.theme = ThemeMode.system,
    this.appLock = false,
    this.reminderEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 20, minute: 0),
    this.budgetAlertAt = 0.8,
    this.budgetAlertsEnabled = true,
    this.profileName = '',
    this.lastPeriodHome = PeriodKind.month,
    this.lastBackupAt,
  });

  AppSettings copyWith({
    String? currencyCode,
    String? currencySymbol,
    int? weekStart,
    String? language,
    ThemeMode? theme,
    bool? appLock,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    double? budgetAlertAt,
    bool? budgetAlertsEnabled,
    String? profileName,
    PeriodKind? lastPeriodHome,
    DateTime? lastBackupAt,
  }) =>
      AppSettings(
        currencyCode: currencyCode ?? this.currencyCode,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        weekStart: weekStart ?? this.weekStart,
        language: language ?? this.language,
        theme: theme ?? this.theme,
        appLock: appLock ?? this.appLock,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        budgetAlertAt: budgetAlertAt ?? this.budgetAlertAt,
        budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
        profileName: profileName ?? this.profileName,
        lastPeriodHome: lastPeriodHome ?? this.lastPeriodHome,
        lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      );

  Map<String, Object> toJson() => {
        'currency_code': currencyCode,
        'currency_symbol': currencySymbol,
        'week_start': weekStart,
        'language': language,
        'theme': theme.name,
        'app_lock': appLock,
        'reminder_enabled': reminderEnabled,
        'reminder_time':
            '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}',
        'budget_alert_at': budgetAlertAt,
        'budget_alerts_enabled': budgetAlertsEnabled,
        'profile_name': profileName,
        'last_period_home': lastPeriodHome.name,
      };

  static AppSettings fromJson(Map<String, Object?> j) {
    final t = (j['reminder_time'] as String? ?? '20:00').split(':');
    return AppSettings(
      currencyCode: j['currency_code'] as String? ?? 'LKR',
      currencySymbol: j['currency_symbol'] as String? ?? 'Rs',
      weekStart: (j['week_start'] as num?)?.toInt() ?? DateTime.monday,
      language: j['language'] as String? ?? 'en',
      theme: ThemeMode.values.firstWhere((m) => m.name == j['theme'],
          orElse: () => ThemeMode.system),
      appLock: j['app_lock'] as bool? ?? false,
      reminderEnabled: j['reminder_enabled'] as bool? ?? true,
      reminderTime: TimeOfDay(
          hour: int.tryParse(t[0]) ?? 20,
          minute: int.tryParse(t.length > 1 ? t[1] : '0') ?? 0),
      budgetAlertAt: (j['budget_alert_at'] as num?)?.toDouble() ?? 0.8,
      budgetAlertsEnabled: j['budget_alerts_enabled'] as bool? ?? true,
      profileName: j['profile_name'] as String? ?? '',
      lastPeriodHome: PeriodKindX.parse(j['last_period_home'] as String?),
    );
  }
}

class SettingsRepository {
  final SharedPreferences prefs;
  SettingsRepository(this.prefs);

  static const _keys = [
    'currency_code', 'currency_symbol', 'week_start', 'language', 'theme',
    'app_lock', 'reminder_enabled', 'reminder_time', 'budget_alert_at',
    'budget_alerts_enabled', 'profile_name', 'last_period_home',
  ];

  AppSettings load() {
    final map = <String, Object?>{for (final k in _keys) k: prefs.get(k)};
    final s = AppSettings.fromJson(map);
    final backup = prefs.getString('last_backup_at');
    return backup == null ? s : s.copyWith(lastBackupAt: DateTime.tryParse(backup));
  }

  Future<void> save(AppSettings s) async {
    for (final e in s.toJson().entries) {
      final v = e.value;
      if (v is String) await prefs.setString(e.key, v);
      if (v is bool) await prefs.setBool(e.key, v);
      if (v is int) await prefs.setInt(e.key, v);
      if (v is double) await prefs.setDouble(e.key, v);
    }
    if (s.lastBackupAt != null) {
      await prefs.setString('last_backup_at', s.lastBackupAt!.toIso8601String());
    }
  }

  // Small app-state values that are not user settings.
  int? getInt(String key) => prefs.getInt(key);
  Future<void> setInt(String key, int value) => prefs.setInt(key, value);
  bool flag(String key) => prefs.getBool(key) ?? false;
  Future<void> setFlag(String key) => prefs.setBool(key, true);
}
