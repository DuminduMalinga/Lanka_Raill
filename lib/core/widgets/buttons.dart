import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum PrimaryButtonTone { accent, dark }

/// Full-width pill call-to-action (lime by default, ink for "Search trains").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.tone = PrimaryButtonTone.accent,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final PrimaryButtonTone tone;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final isAccent = tone == PrimaryButtonTone.accent;
    return _PillButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      trailingIcon: trailingIcon,
      expand: expand,
      background: isAccent ? AppColors.lime : AppColors.ink,
      foreground: isAccent ? AppColors.ink : AppColors.white,
    );
  }
}

enum SecondaryButtonTone { light, glass }

/// Outlined pill button. `light` on light screens, `glass` on dark screens.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = SecondaryButtonTone.light,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SecondaryButtonTone tone;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isGlass = tone == SecondaryButtonTone.glass;
    return _PillButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
      background: isGlass ? AppColors.glass : palette.surface,
      foreground: isGlass ? AppColors.white : palette.textPrimary,
      borderColor: isGlass ? AppColors.glassBorder : palette.border,
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
    required this.expand,
    this.icon,
    this.trailingIcon,
    this.borderColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final bool expand;
  final IconData? icon;
  final IconData? trailingIcon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppSizes.iconSm + 2, color: foreground),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.button.copyWith(color: foreground),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: AppSizes.iconSm + 2, color: foreground),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Material(
          color: background,
          shape: StadiumBorder(
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.buttonHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s22,
                  vertical: AppSpacing.md,
                ),
                child: Center(widthFactor: 1, child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon + label as a single rich text, so it wraps instead of overflowing
/// when width is tight and still works inside horizontally scrolling rows.
class IconLabel extends StatelessWidget {
  const IconLabel({
    super.key,
    required this.label,
    required this.style,
    this.icon,
    this.iconSize = AppSizes.iconSm,
    this.gap = AppSpacing.sm,
    this.textAlign = TextAlign.center,
  });

  final String label;
  final TextStyle style;
  final IconData? icon;
  final double iconSize;
  final double gap;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (icon != null) ...[
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(icon, size: iconSize, color: style.color),
            ),
            WidgetSpan(child: SizedBox(width: gap)),
          ],
          TextSpan(text: label),
        ],
      ),
      textAlign: textAlign,
      style: style,
    );
  }
}

/// Small lime/ink pill used inline (e.g. "Find trains", "Plan trip").
class CompactPillButton extends StatelessWidget {
  const CompactPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background = AppColors.lime,
    this.foreground = AppColors.ink,
    this.height = AppSizes.tapTarget,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: background,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s18),
              child: Center(
                widthFactor: 1,
                child: IconLabel(
                  label: label,
                  icon: icon,
                  iconSize: AppSizes.iconSm + 2,
                  style: AppTextStyles.buttonSmall.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
