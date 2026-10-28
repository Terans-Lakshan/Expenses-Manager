import 'package:intl/intl.dart';

/// Largest amount accepted on input: Rs 999,999,999.
const maxAmountCents = 99999999900;

final _whole = NumberFormat('#,##0', 'en_US');
final _cents = NumberFormat('#,##0.00', 'en_US');

/// Formats integer cents for display. All money in the app is integer cents;
/// only this layer converts to text.
class Money {
  final String symbol;
  const Money([this.symbol = 'Rs']);

  /// `Rs 12,345`, or `Rs 2,250.50` when the amount has cents. Negative → `−Rs 1,200`.
  String format(int cents) {
    final neg = cents < 0;
    final a = cents.abs();
    final body = a % 100 == 0 ? _whole.format(a ~/ 100) : _cents.format(a / 100);
    return '${neg ? '−' : ''}$symbol $body';
  }

  /// `+Rs 1,200` / `−Rs 1,200` for record amounts.
  String signed(int cents, {required bool income}) =>
      '${income ? '+' : '−'}${format(cents.abs())}';

  /// Net with explicit sign for non-zero: `+Rs 400`, `−Rs 400`, `Rs 0`.
  String net(int cents) => cents == 0
      ? format(0)
      : '${cents > 0 ? '+' : '−'}${format(cents.abs())}';

  /// Short form for report tiles: `Rs 950`, `Rs 112k`, `Rs 1.91M`.
  String short(int cents) {
    final neg = cents < 0;
    final v = cents.abs() / 100;
    String body;
    if (v >= 1e9) {
      body = '${_trim(v / 1e9, 2)}B';
    } else if (v >= 1e6) {
      body = '${_trim(v / 1e6, 2)}M';
    } else if (v >= 1e3) {
      body = '${_trim(v / 1e3, v >= 1e5 ? 0 : 1)}k';
    } else {
      body = _whole.format(v.round());
    }
    return '${neg ? '−' : ''}$symbol $body';
  }

  /// Axis label without symbol: `0`, `950`, `110k`, `1.2M`.
  static String axis(int cents) {
    final v = cents / 100;
    if (v >= 1e6) return '${_trim(v / 1e6, 1)}M';
    if (v >= 1e3) return '${_trim(v / 1e3, v >= 1e4 ? 0 : 1)}k';
    return v.round().toString();
  }

  static String _trim(double v, int decimals) {
    var s = v.toStringAsFixed(decimals);
    if (s.contains('.')) s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }
}

/// Result of parsing user-typed amount text.
class AmountParse {
  final int? cents;
  final String? error;
  const AmountParse.ok(this.cents) : error = null;
  const AmountParse.fail(this.error) : cents = null;
}

/// Validates an amount: required, > 0, at most 2 decimals, at most Rs 999,999,999.
/// Accepts thousands separators (`2,250.50`).
AmountParse parseAmount(String raw) {
  final s = raw.trim().replaceAll(',', '');
  if (s.isEmpty) return const AmountParse.fail('Enter an amount');
  if (!RegExp(r'^-?\d*\.?\d*$').hasMatch(s) || s == '.' || s == '-') {
    return const AmountParse.fail('Enter a valid number');
  }
  if (s.startsWith('-')) return const AmountParse.fail('Amount must be more than 0');
  final parts = s.split('.');
  if (parts.length == 2 && parts[1].length > 2) {
    return const AmountParse.fail('Use at most 2 decimals');
  }
  final whole = int.tryParse(parts[0].isEmpty ? '0' : parts[0]);
  if (whole == null) return const AmountParse.fail('Amount is too large');
  final frac = parts.length == 2 ? parts[1].padRight(2, '0') : '00';
  final cents = whole * 100 + int.parse(frac.isEmpty ? '0' : frac);
  if (cents <= 0) return const AmountParse.fail('Amount must be more than 0');
  if (cents > maxAmountCents) {
    return const AmountParse.fail('Amount must be at most 999,999,999');
  }
  return AmountParse.ok(cents);
}

/// Cents → editable text without separators: 225050 → "2250.5", 225000 → "2250".
String centsToInput(int cents) {
  final whole = cents ~/ 100, frac = cents % 100;
  if (frac == 0) return '$whole';
  final f = frac.toString().padLeft(2, '0');
  return '$whole.${f.endsWith('0') ? f[0] : f}';
}
