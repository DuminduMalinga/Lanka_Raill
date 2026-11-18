import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Colour tones used by tags/badges across the design.
enum StatusTone { lime, mint, neutral, blue, amber, red, glass }

/// Small 22px pill tag ("Scenic", "Verified", "Delay", "2nd"...).
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.mint,
    this.icon,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (Color bg, Color fg) = switch (tone) {
      StatusTone.lime => (AppColors.lime, AppColors.ink),
      StatusTone.mint => (palette.tint, palette.onTint),
      StatusTone.neutral => (palette.neutralChip, palette.textMuted),
      StatusTone.blue => (AppColors.blueChipBg, AppColors.blueChipFg),
      StatusTone.amber => (AppColors.amberChipBg, AppColors.amberChipFg),
      StatusTone.red => (AppColors.redChipBg, AppColors.redChipFg),
      StatusTone.glass => (AppColors.glass, AppColors.white),
    };
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.tagHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.tagAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.tag.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}
