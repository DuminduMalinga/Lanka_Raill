import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/circle_icon_button.dart';

/// Floating bar over a map: back · title pill · trailing action.
class MapTopBar extends StatelessWidget {
  const MapTopBar({
    super.key,
    required this.title,
    required this.fallbackRoute,
    this.trailing,
    this.titleIcon,
  });

  final String title;
  final String fallbackRoute;
  final Widget? trailing;
  final IconData? titleIcon;

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
          CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            iconSize: AppSizes.iconSm + 2,
            tone: CircleIconTone.scrim,
            semanticLabel: context.l10n.back,
            onPressed: popOrGo(context, fallbackRoute),
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.scrimStrong,
                borderRadius: AppRadii.pillAll,
                border: Border.all(color: AppColors.hairlineOnDark),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (titleIcon != null) ...[
                    Icon(
                      titleIcon,
                      size: AppSizes.iconSm,
                      color: AppColors.lime,
                    ),
                    const SizedBox(width: AppSpacing.s6),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          SizedBox.square(dimension: AppSizes.tapTarget, child: trailing),
        ],
      ),
    );
  }
}
