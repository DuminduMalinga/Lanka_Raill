import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Centered illustration-free empty state used by every list screen.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.onDark = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final titleColor = onDark ? AppColors.white : palette.textPrimary;
    final bodyColor = onDark ? AppColors.mutedOnDark : palette.textMuted;
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: onDark ? AppColors.glass : palette.tint,
                borderRadius: BorderRadius.circular(AppRadii.hero),
              ),
              child: Icon(
                icon,
                size: 28,
                color: onDark ? AppColors.lime : palette.onTint,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(color: titleColor),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: bodyColor),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
