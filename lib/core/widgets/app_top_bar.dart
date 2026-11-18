import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'circle_icon_button.dart';

/// Centered-title top bar with a circular back button (light screens).
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSizes.tapTarget,
            child: showBack
                ? CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconSize: AppSizes.iconSm + 2,
                    semanticLabel: context.l10n.back,
                    onPressed: onBack ?? () => _pop(context),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Semantics(
              header: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.screenTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox.square(dimension: AppSizes.tapTarget, child: trailing),
        ],
      ),
    );
  }

  static void _pop(BuildContext context) {
    if (context.canPop()) context.pop();
  }
}

/// Top row for dark hero screens: back (scrim) · brand · spacer.
class HeroTopBar extends StatelessWidget {
  const HeroTopBar({
    super.key,
    required this.center,
    this.onBack,
    this.trailing,
    this.backLabel,
  });

  final Widget center;
  final VoidCallback? onBack;
  final Widget? trailing;
  final String? backLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSizes.tapTarget,
            child: onBack == null
                ? null
                : CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconSize: AppSizes.iconSm + 2,
                    tone: CircleIconTone.scrim,
                    semanticLabel: backLabel ?? context.l10n.back,
                    onPressed: onBack,
                  ),
          ),
          Expanded(child: Center(child: center)),
          SizedBox.square(dimension: AppSizes.tapTarget, child: trailing),
        ],
      ),
    );
  }
}

/// Default `onBack` for hero screens that should pop or go to [fallback].
VoidCallback popOrGo(BuildContext context, String fallback) {
  return () {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallback);
    }
  };
}
