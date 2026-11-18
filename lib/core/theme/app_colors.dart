import 'package:material_ui/material_ui.dart';

/// Raw brand palette extracted from the CeylonGO design.
///
/// Screens should prefer the semantic [AppPalette] (via `context.palette`)
/// so light and dark themes both work. The raw values here are used for
/// surfaces that are always dark in the design (splash, auth, maps).
abstract final class AppColors {
  // Brand
  static const Color forest = Color(0xFF12291D);
  static const Color forestDeep = Color(0xFF0B1912);
  static const Color forestRaised = Color(0xFF21402F);
  static const Color ink = Color(0xFF0E1F17);
  static const Color lime = Color(0xFFCDEB7A);
  static const Color green = Color(0xFF1E5B3C);
  static const Color mint = Color(0xFFE4F2D2);

  // Neutrals (light)
  static const Color canvas = Color(0xFFF3F6F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E8E2);
  static const Color muted = Color(0xFF56675C);
  static const Color neutralChip = Color(0xFFEDF1EE);
  static const Color segmentTrack = Color(0xFFE6ECE7);

  // On dark
  static const Color mutedOnDark = Color(0xFFA9BDB0);
  static const Color softOnDark = Color(0xFFC9D8CE);
  static const Color captionOnDark = Color(0xFFD3E0D7);
  static const Color errorOnDark = Color(0xFFF6B38E);
  static const Color glass = Color(0x1AFFFFFF); // white 10%
  static const Color glassStrong = Color(0x2EFFFFFF); // white 18%
  static const Color glassBorder = Color(0x24FFFFFF); // white 14%
  static const Color hairlineOnDark = Color(0x1AFFFFFF);
  static const Color scrim = Color(0x8C0B1912); // forestDeep 55%
  static const Color scrimStrong = Color(0xD90B1912); // forestDeep 85%

  // Status tones
  static const Color amberBg = Color(0xFFFDF3E4);
  static const Color amberFg = Color(0xFF5B2A04);
  static const Color amberIcon = Color(0xFFB45309);
  static const Color amberChipBg = Color(0xFFFDEBD3);
  static const Color amberChipFg = Color(0xFF8A3B06);
  static const Color blueChipBg = Color(0xFFDCEBFA);
  static const Color blueChipFg = Color(0xFF1D4F86);
  static const Color redChipBg = Color(0xFFFCE9E6);
  static const Color redChipFg = Color(0xFFA3281A);

  // Railway line accents
  static const Color lineMain = lime;
  static const Color lineCoastal = Color(0xFF7FD3E6);
  static const Color lineNorthern = Color(0xFFF2B866);
  static const Color lineBatticaloa = Color(0xFFC9A7F5);
  static const Color lineTrincomalee = Color(0xFFF28B82);

  // Photo placeholders
  static const Color photoEarth = Color(0xFF6A5A3C);
  static const Color photoSea = Color(0xFF2C5A62);
  static const Color photoLeaf = Color(0xFF355E45);
  static const Color photoSand = Color(0xFF7A6A44);

  // Third-party brand marks
  static const Color google = Color(0xFF1F1F1F);
  static const Color facebook = Color(0xFF1877F2);
}

/// Semantic colours that change between light and dark themes.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.primary,
    required this.accent,
    required this.onAccent,
    required this.tint,
    required this.onTint,
    required this.neutralChip,
    required this.segmentTrack,
    required this.selectedChip,
    required this.onSelectedChip,
    required this.hero,
    required this.onHero,
    required this.onHeroMuted,
  });

  final Color background;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color primary;
  final Color accent;
  final Color onAccent;
  final Color tint;
  final Color onTint;
  final Color neutralChip;
  final Color segmentTrack;
  final Color selectedChip;
  final Color onSelectedChip;
  final Color hero;
  final Color onHero;
  final Color onHeroMuted;

  static const AppPalette light = AppPalette(
    background: AppColors.canvas,
    surface: AppColors.white,
    border: AppColors.border,
    textPrimary: AppColors.ink,
    textMuted: AppColors.muted,
    primary: AppColors.green,
    accent: AppColors.lime,
    onAccent: AppColors.ink,
    tint: AppColors.mint,
    onTint: AppColors.green,
    neutralChip: AppColors.neutralChip,
    segmentTrack: AppColors.segmentTrack,
    selectedChip: AppColors.ink,
    onSelectedChip: AppColors.white,
    hero: AppColors.forest,
    onHero: AppColors.white,
    onHeroMuted: AppColors.mutedOnDark,
  );

  static const AppPalette dark = AppPalette(
    background: AppColors.forestDeep,
    surface: AppColors.forest,
    border: AppColors.hairlineOnDark,
    textPrimary: AppColors.white,
    textMuted: AppColors.mutedOnDark,
    primary: AppColors.lime,
    accent: AppColors.lime,
    onAccent: AppColors.ink,
    tint: AppColors.forestRaised,
    onTint: AppColors.lime,
    neutralChip: AppColors.forestRaised,
    segmentTrack: AppColors.forestRaised,
    selectedChip: AppColors.lime,
    onSelectedChip: AppColors.ink,
    hero: AppColors.forestRaised,
    onHero: AppColors.white,
    onHeroMuted: AppColors.mutedOnDark,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? primary,
    Color? accent,
    Color? onAccent,
    Color? tint,
    Color? onTint,
    Color? neutralChip,
    Color? segmentTrack,
    Color? selectedChip,
    Color? onSelectedChip,
    Color? hero,
    Color? onHero,
    Color? onHeroMuted,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      tint: tint ?? this.tint,
      onTint: onTint ?? this.onTint,
      neutralChip: neutralChip ?? this.neutralChip,
      segmentTrack: segmentTrack ?? this.segmentTrack,
      selectedChip: selectedChip ?? this.selectedChip,
      onSelectedChip: onSelectedChip ?? this.onSelectedChip,
      hero: hero ?? this.hero,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      border: l(border, other.border),
      textPrimary: l(textPrimary, other.textPrimary),
      textMuted: l(textMuted, other.textMuted),
      primary: l(primary, other.primary),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      tint: l(tint, other.tint),
      onTint: l(onTint, other.onTint),
      neutralChip: l(neutralChip, other.neutralChip),
      segmentTrack: l(segmentTrack, other.segmentTrack),
      selectedChip: l(selectedChip, other.selectedChip),
      onSelectedChip: l(onSelectedChip, other.onSelectedChip),
      hero: l(hero, other.hero),
      onHero: l(onHero, other.onHero),
      onHeroMuted: l(onHeroMuted, other.onHeroMuted),
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
