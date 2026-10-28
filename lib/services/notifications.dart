import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Daily reminder (FR-43) and budget alerts (FR-32). Every call is safe to make
/// on platforms without notification support; failures are swallowed.
class NotificationService {
  static const _reminderId = 1;
  static const _budgetBaseId = 1000;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('Asia/Colombo'));
      }
      _ready = await _plugin.initialize(
            settings: const InitializationSettings(
              android: AndroidInitializationSettings('@mipmap/ic_launcher'),
              iOS: DarwinInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false,
              ),
              windows: WindowsInitializationSettings(
                appName: 'Expense Manager',
                appUserModelId: 'com.expensemanager.expense_manager',
                guid: '7b0c2a52-3c8e-4a8e-9d4a-0e6f3b1f5c21',
              ),
            ),
          ) ??
          false;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
      _ready = false;
    }
  }

  /// Asks for permission (Android 13+, iOS). Returns false if denied.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    try {
      if (Platform.isAndroid) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        return await android?.requestNotificationsPermission() ?? true;
      }
      if (Platform.isIOS) {
        final ios = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
      }
    } catch (_) {}
    return true;
  }

  static const _reminderDetails = NotificationDetails(
    android: AndroidNotificationDetails('daily_reminder', 'Daily reminder',
        channelDescription: 'A daily nudge to log today\'s spending',
        importance: Importance.defaultImportance),
    iOS: DarwinNotificationDetails(),
  );

  static const _budgetDetails = NotificationDetails(
    android: AndroidNotificationDetails('budget_alerts', 'Budget alerts',
        channelDescription: 'Warns when a budget is nearly used',
        importance: Importance.high),
    iOS: DarwinNotificationDetails(),
  );

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _reminderId);
      final now = tz.TZDateTime.now(tz.local);
      var at = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
      if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
      await _plugin.zonedSchedule(
        id: _reminderId,
        title: 'Log today\'s spending',
        body: 'Take 10 seconds to add today\'s expenses.',
        scheduledDate: at,
        notificationDetails: _reminderDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Could not schedule reminder: $e');
    }
  }

  Future<void> cancelDailyReminder() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _reminderId);
    } catch (_) {}
  }

  Future<void> showBudgetAlert(int budgetId, String title, String body) async {
    if (!_ready) return;
    try {
      await _plugin.show(
          id: _budgetBaseId + budgetId,
          title: title,
          body: body,
          notificationDetails: _budgetDetails);
    } catch (e) {
      debugPrint('Could not show budget alert: $e');
    }
  }
}

final notificationService = NotificationService();
