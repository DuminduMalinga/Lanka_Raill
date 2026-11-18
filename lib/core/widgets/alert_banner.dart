import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'status_chip.dart';

/// Amber service-alert banner (Home): `Line: message  [Verified]`.
class AlertBanner extends StatelessWidget {
  const AlertBanner({
    super.key,
    required this.lead,
    required this.message,
    this.badgeLabel,
    this.onTap,
  });

  final String lead;
  final String message;
  final String? badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      child: Material(
        color: AppColors.amberBg,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s14,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: AppSizes.icon,
                    color: AppColors.amberIcon,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$lead: ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontVariations: [FontVariation('wght', 700)],
                            ),
                          ),
                          TextSpan(text: message),
                        ],
                      ),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.amberFg,
                        height: 1.35,
                      ),
                    ),
                  ),
                  if (badgeLabel != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    StatusChip(label: badgeLabel!, tone: StatusTone.mint),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
