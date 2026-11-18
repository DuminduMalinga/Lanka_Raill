import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Section title with an optional trailing text action ("See all").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: palette.primary,
              minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              textStyle: AppTextStyles.chip,
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

/// Small uppercase muted label above grouped content ("PREFERENCES").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.onDark = false});

  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Semantics(
        header: true,
        child: Text(
          text.toUpperCase(),
          style: AppTextStyles.sectionLabel.copyWith(
            color: onDark ? AppColors.mutedOnDark : context.palette.textMuted,
          ),
        ),
      ),
    );
  }
}
