import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum CircleIconTone {
  /// White surface with hairline border (light screens).
  surface,

  /// Translucent white on dark surfaces.
  glass,

  /// Dark scrim over photos.
  scrim,

  /// Lime accent.
  accent,

  /// Brand green (avatar style).
  primary,
}

/// 48dp circular icon button with a required semantic label.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.tone = CircleIconTone.surface,
    this.size = AppSizes.tapTarget,
    this.iconSize = AppSizes.icon,
    this.child,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final CircleIconTone tone;
  final double size;
  final double iconSize;

  /// Optional custom content (e.g. initials) replacing the icon.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (Color bg, Color fg, Color? border) = switch (tone) {
      CircleIconTone.surface => (
        palette.surface,
        palette.textPrimary,
        palette.border,
      ),
      CircleIconTone.glass => (AppColors.glass, AppColors.white, null),
      CircleIconTone.scrim => (AppColors.scrim, AppColors.white, null),
      CircleIconTone.accent => (AppColors.lime, AppColors.ink, null),
      CircleIconTone.primary => (AppColors.green, AppColors.white, null),
    };

    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: bg,
        shape: CircleBorder(
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: child ?? Icon(icon, size: iconSize, color: fg),
            ),
          ),
        ),
      ),
    );
  }
}
