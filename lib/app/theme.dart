import 'package:flutter/material.dart';

/// Design tokens from PRD section 5.
class AppColors {
  static const background = Color(0xFFF2F4F7);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0F1B2D);
  static const muted = Color(0xFF5A6575);
  static const track = Color(0xFFE3E7ED);
  static const divider = Color(0xFFEEF1F4);
  static const border = Color(0xFFD5DBE3);
  static const income = Color(0xFF1D5FCC);
  static const expense = Color(0xFFB4471A);
  static const expenseBar = Color(0xFFF08A4B);
  static const warning = Color(0xFFE07B39);
  static const incomeOnDark = Color(0xFF9EC2FF);
  static const expenseOnDark = Color(0xFFFFB48C);
  static const switchOff = Color(0xFFC9D0DA);

  /// Donut slice colours in order (differ in lightness, not only hue).
  static const donut = [
    Color(0xFF0F1B2D), Color(0xFF1D5FCC), Color(0xFF7FB2F7),
    Color(0xFFB4471A), Color(0xFFF2A272), Color(0xFFA7B0BC),
  ];
}

const fontDisplay = 'Sora';
const fontBody = 'Manrope';

/// Theme-aware tokens. Read with `context.pal`.
class Palette extends ThemeExtension<Palette> {
  final Color background, surface, text, muted, track, divider, border;
  final Color income, expense, expenseBar, warning;
  final Color primary, onPrimary; // ink buttons, selected chips, + button
  final Color card, onCard, cardTile; // balance / budget ring card
  final Color segmentSelected;
  final List<Color> donut;

  const Palette({
    required this.background,
    required this.surface,
    required this.text,
    required this.muted,
    required this.track,
    required this.divider,
    required this.border,
    required this.income,
    required this.expense,
    required this.expenseBar,
    required this.warning,
    required this.primary,
    required this.onPrimary,
    required this.card,
    required this.onCard,
    required this.cardTile,
    required this.segmentSelected,
    required this.donut,
  });

  static const light = Palette(
    background: AppColors.background,
    surface: AppColors.surface,
    text: AppColors.ink,
    muted: AppColors.muted,
    track: AppColors.track,
    divider: AppColors.divider,
    border: AppColors.border,
    income: AppColors.income,
    expense: AppColors.expense,
    expenseBar: AppColors.expenseBar,
    warning: AppColors.warning,
    primary: AppColors.ink,
    onPrimary: Colors.white,
    card: AppColors.ink,
    onCard: Colors.white,
    cardTile: Color(0x14FFFFFF),
    segmentSelected: Colors.white,
    donut: AppColors.donut,
  );

  /// Dark mode: same layout, lighter income/expense hues for 4.5:1 contrast.
  static const dark = Palette(
    background: Color(0xFF0B1220),
    surface: Color(0xFF141D2B),
    text: Color(0xFFE8ECF2),
    muted: Color(0xFF9AA6B6),
    track: Color(0xFF1F2A3B),
    divider: Color(0xFF1F2A3B),
    border: Color(0xFF2C3A4F),
    income: Color(0xFF7FB2F7),
    expense: Color(0xFFFF9F6E),
    expenseBar: AppColors.expenseBar,
    warning: Color(0xFFF2A272),
    primary: Color(0xFFE8ECF2),
    onPrimary: Color(0xFF0B1220),
    card: Color(0xFF1C2940),
    onCard: Colors.white,
    cardTile: Color(0x14FFFFFF),
    segmentSelected: Color(0xFF2C3A4F),
    donut: [
      Color(0xFFE8ECF2), Color(0xFF4F8DF0), Color(0xFF9EC2FF),
      Color(0xFFE0703A), Color(0xFFF2A272), Color(0xFF6B7686),
    ],
  );

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(ThemeExtension<Palette>? other, double t) =>
      t < 0.5 ? this : (other as Palette? ?? this);
}

extension PaletteX on BuildContext {
  Palette get pal => Theme.of(this).extension<Palette>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.light ? Palette.light : Palette.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: fontBody,
    scaffoldBackgroundColor: p.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.income,
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      surface: p.surface,
      onSurface: p.text,
      error: p.expense,
    ),
    extensions: [p],
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    dividerColor: p.divider,
    splashFactory: InkRipple.splashFactory,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: p.primary,
      contentTextStyle: TextStyle(
          fontFamily: fontBody, color: p.onPrimary, fontWeight: FontWeight.w600),
      actionTextColor: brightness == Brightness.light
          ? AppColors.incomeOnDark
          : AppColors.income,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.background,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
            fontFamily: fontBody, fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.income,
        minimumSize: const Size(44, 44),
        textStyle: const TextStyle(
            fontFamily: fontBody, fontWeight: FontWeight.w700, fontSize: 14),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? p.income : AppColors.switchOff),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
  );
}

/// Text styles used across screens.
class T {
  static TextStyle title(BuildContext c) => TextStyle(
      fontFamily: fontDisplay,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: c.pal.text);
  static TextStyle section(BuildContext c, {double size = 17}) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: c.pal.text);
  static TextStyle row(BuildContext c) =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.pal.text);
  static TextStyle secondary(BuildContext c, {double size = 12}) =>
      TextStyle(fontSize: size, fontWeight: FontWeight.w600, color: c.pal.muted);
  static TextStyle number(double size, {FontWeight weight = FontWeight.w600, Color? color}) =>
      TextStyle(
          fontFamily: fontDisplay,
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: size >= 26 ? -0.6 : 0);
}

Color hexColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}
