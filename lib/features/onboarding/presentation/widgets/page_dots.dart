import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Pager indicator: accent pill for the current page, faint dots otherwise.
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.current,
    this.activeWidth = 28,
    this.height = 8,
    this.semanticLabel,
    this.activeColor = AppColors.lime,
    this.inactiveAlpha = 0.28,
  });

  final int count;
  final int current;
  final double activeWidth;
  final double height;
  final String? semanticLabel;
  final Color activeColor;
  final double inactiveAlpha;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s6),
            AnimatedContainer(
              duration: AppDurations.medium,
              width: i == current ? activeWidth : height,
              height: height,
              decoration: BoxDecoration(
                color: i == current
                    ? activeColor
                    : AppColors.white.withValues(alpha: inactiveAlpha),
                borderRadius: AppRadii.pillAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
