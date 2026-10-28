import 'package:flutter/foundation.dart';

import '../data/repositories/recurring_repository.dart';

bool _running = false;

/// Creates due recurring records. Called on app start and on every resume.
Future<int> runRecurring(RecurringRepository repo) async {
  if (_running) return 0;
  _running = true;
  try {
    return await repo.runDue(DateTime.now());
  } catch (e) {
    debugPrint('Recurring run failed: $e');
    return 0;
  } finally {
    _running = false;
  }
}
