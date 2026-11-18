import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Station row: optional code badge, name (+ native name), line subtitle,
/// and either a selected check or a chevron.
class StationTile extends StatelessWidget {
  const StationTile({
    super.key,
    required this.name,
    required this.subtitle,
    this.code,
    this.nativeName,
    this.trailingText,
    this.selected = false,
    this.showChevron = false,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String? code;
  final String? nativeName;
  final String? trailingText;
  final bool selected;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: selected ? palette.primary : palette.border,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s14,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (code != null) ...[
                    _CodeBadge(code: code!, selected: selected),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(child: _texts(palette)),
                  if (trailingText != null)
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Text(
                        trailingText!,
                        style: AppTextStyles.captionStrong.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ),
                  if (selected)
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: palette.surface,
                      ),
                    )
                  else if (showChevron)
                    Icon(Icons.chevron_right_rounded, color: palette.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _texts(AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: name),
              if (nativeName != null)
                TextSpan(
                  text: '  $nativeName',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: palette.textMuted,
                  ),
                ),
            ],
          ),
          style: AppTextStyles.cardTitle.copyWith(color: palette.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: palette.textMuted),
        ),
      ],
    );
  }
}

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({required this.code, required this.selected});

  final String code;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 46,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.lime : palette.neutralChip,
        borderRadius: BorderRadius.circular(AppRadii.iconTile),
      ),
      child: Text(
        code,
        style: AppTextStyles.tag.copyWith(
          fontSize: 12,
          letterSpacing: 0.7,
          color: selected ? AppColors.ink : palette.textMuted,
        ),
      ),
    );
  }
}
