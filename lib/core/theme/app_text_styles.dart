import 'package:material_ui/material_ui.dart';

/// Typography from the design: Plus Jakarta Sans for display/headings,
/// Inter for UI text, Noto Sans Sinhala as fallback for Sinhala glyphs.
///
/// Fonts are bundled as variable fonts, so every style sets the `wght`
/// axis through [FontVariation] in addition to [FontWeight].
/// Styles carry no colour; widgets apply colour from [AppPalette].
abstract final class AppFonts {
  static const String display = 'PlusJakartaSans';
  static const String body = 'Inter';
  static const String sinhala = 'NotoSansSinhala';
  static const List<String> fallback = <String>[sinhala];
}

abstract final class AppTextStyles {
  static const TextStyle _display = TextStyle(
    fontFamily: AppFonts.display,
    fontFamilyFallback: AppFonts.fallback,
  );
  static const TextStyle _body = TextStyle(
    fontFamily: AppFonts.body,
    fontFamilyFallback: AppFonts.fallback,
  );

  static const FontVariation _w400 = FontVariation('wght', 400);
  static const FontVariation _w500 = FontVariation('wght', 500);
  static const FontVariation _w600 = FontVariation('wght', 600);
  static const FontVariation _w700 = FontVariation('wght', 700);
  static const FontVariation _w800 = FontVariation('wght', 800);

  // Display / headings (Plus Jakarta Sans)
  static final TextStyle splashBrand = _display.copyWith(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
    letterSpacing: -0.76,
  );
  static final TextStyle hero = _display.copyWith(
    fontSize: 36,
    height: 1.12,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
    letterSpacing: -0.72,
  );
  static final TextStyle h1 = _display.copyWith(
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
    letterSpacing: -0.64,
  );
  static final TextStyle h2 = _display.copyWith(
    fontSize: 28,
    height: 1.18,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
    letterSpacing: -0.56,
  );
  static final TextStyle h3 = _display.copyWith(
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
    letterSpacing: -0.52,
  );
  static final TextStyle h4 = _display.copyWith(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle brand = _display.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle optionTitle = _display.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );

  // UI text (Inter)
  static final TextStyle screenTitle = _body.copyWith(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle sectionTitle = screenTitle;
  static final TextStyle titleLarge = _body.copyWith(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle titleMedium = _body.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle cardTitle = _body.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle rowTitle = _body.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontVariations: const [_w600],
  );
  static final TextStyle bodyLarge = _body.copyWith(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontVariations: const [_w400],
  );
  static final TextStyle body = _body.copyWith(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    fontVariations: const [_w400],
  );
  static final TextStyle bodyStrong = _body.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontVariations: const [_w600],
  );
  static final TextStyle bodySmall = _body.copyWith(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
    fontVariations: const [_w400],
  );
  static final TextStyle caption = _body.copyWith(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w400,
    fontVariations: const [_w400],
  );
  static final TextStyle captionStrong = _body.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontVariations: const [_w600],
  );
  static final TextStyle label = _body.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontVariations: const [_w500],
  );
  static final TextStyle overline = _body.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    fontVariations: const [_w400],
    letterSpacing: 0.66,
  );
  static final TextStyle sectionLabel = _body.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
    letterSpacing: 0.72,
  );
  static final TextStyle tag = _body.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle button = _body.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle buttonSmall = _body.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
  static final TextStyle chip = _body.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontVariations: const [_w600],
  );
  static final TextStyle input = _body.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontVariations: const [_w500],
  );
  static final TextStyle timeLarge = _body.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle timeMedium = _body.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle timeSmall = _body.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle statValue = _body.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    fontVariations: const [_w800],
  );
  static final TextStyle navLabel = _body.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontVariations: const [_w500],
  );
  static final TextStyle navLabelActive = navLabel.copyWith(
    fontWeight: FontWeight.w700,
    fontVariations: const [_w700],
  );
}
