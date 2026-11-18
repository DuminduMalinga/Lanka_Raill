import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Gradient presets matching the design's photo overlays.
enum BackdropFade {
  /// Welcome: clear in the middle, solid at the bottom.
  welcome,

  /// Language / auth: darkens from a third of the way down.
  form,
}

/// Full-bleed photo with the forest gradient overlay. Always dark.
class PhotoBackdrop extends StatelessWidget {
  const PhotoBackdrop({
    super.key,
    required this.child,
    this.asset = AppAssets.mistyHillTrain,
    this.semanticLabel,
    this.alignment = const Alignment(-0.4, 0.2),
    this.fade = BackdropFade.form,
  });

  final Widget child;
  final String asset;
  final String? semanticLabel;
  final Alignment alignment;
  final BackdropFade fade;

  static const _welcomeStops = [0.0, 0.22, 0.42, 0.68, 1.0];
  static const _welcomeColors = [
    Color(0x8C0B1912),
    Color(0x000B1912),
    Color(0x000B1912),
    Color(0xEB0B1912),
    AppColors.forestDeep,
  ];
  static const _formStops = [0.0, 0.18, 0.34, 0.52, 1.0];
  static const _formColors = [
    Color(0x8C0B1912),
    Color(0x260B1912),
    Color(0x8C0B1912),
    Color(0xF00B1912),
    AppColors.forestDeep,
  ];

  @override
  Widget build(BuildContext context) {
    final isWelcome = fade == BackdropFade.welcome;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: AppColors.forestDeep,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              alignment: alignment,
              semanticLabel: semanticLabel,
              excludeFromSemantics: semanticLabel == null,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: isWelcome ? _welcomeStops : _formStops,
                  colors: isWelcome ? _welcomeColors : _formColors,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

/// Plain dark forest background (splash, onboarding).
class ForestBackground extends StatelessWidget {
  const ForestBackground({
    super.key,
    required this.child,
    this.color = AppColors.forest,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(color: color, child: child),
    );
  }
}
