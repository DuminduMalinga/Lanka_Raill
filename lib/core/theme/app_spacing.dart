import 'package:material_ui/material_ui.dart';

/// Spacing scale used throughout the design (multiples of 2/4 px).
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double s6 = 6;
  static const double sm = 8;
  static const double s10 = 10;
  static const double md = 12;
  static const double s14 = 14;
  static const double lg = 16;
  static const double s18 = 18;
  static const double xl = 20;
  static const double s22 = 22;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 44;

  /// Horizontal page gutter on light screens.
  static const double gutter = 20;

  /// Horizontal page gutter on dark hero screens (auth, onboarding).
  static const double heroGutter = 24;

  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: gutter);
  static const EdgeInsets heroPage = EdgeInsets.symmetric(
    horizontal: heroGutter,
  );

  /// Bottom padding so scroll content clears the bottom navigation bar.
  static const double navClearance = 24;
}

/// Corner radii from the design.
abstract final class AppRadii {
  static const double tag = 11;
  static const double iconTile = 12;
  static const double iconTileLg = 14;
  static const double stat = 16;
  static const double card = 18;
  static const double cardLg = 20;
  static const double cardXl = 22;
  static const double hero = 26;
  static const double sheet = 28;
  static const double photo = 32;
  static const double pill = 999;

  static const BorderRadius tagAll = BorderRadius.all(Radius.circular(tag));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius cardLgAll = BorderRadius.all(
    Radius.circular(cardLg),
  );
  static const BorderRadius cardXlAll = BorderRadius.all(
    Radius.circular(cardXl),
  );
  static const BorderRadius heroAll = BorderRadius.all(Radius.circular(hero));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}

/// Fixed component sizes.
abstract final class AppSizes {
  /// Minimum accessible tap target.
  static const double tapTarget = 48;
  static const double buttonHeight = 54;
  static const double fieldHeight = 56;
  static const double chipHeight = 36;
  static const double tagHeight = 22;
  static const double iconSm = 16;
  static const double icon = 20;
  static const double iconLg = 22;
  static const double bottomNavHeight = 64;
  static const double maxContentWidth = 560;
}

abstract final class AppShadows {
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> knob = [
    BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1)),
  ];
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration splash = Duration(milliseconds: 2200);
}
