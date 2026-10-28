import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// OS biometric prompt with device PIN fallback (FR-42).
class AppLockService {
  final _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> authenticate({String reason = 'Unlock Expense Manager'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

final appLockService = AppLockService();
