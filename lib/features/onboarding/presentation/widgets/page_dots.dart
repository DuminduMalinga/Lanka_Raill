import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Pager indicator: lime pill for the current page, faint dots otherwise.
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.current,
    this.activeWidth = 28,
    this.height = 8,
    this.semanticLabel,
  });

  final int count;
  final int current;
  final double activeWidth;
  final double height;
  final String? semanticLabel;

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
                    ? AppColors.lime
                    : AppColors.white.withValues(alpha: 0.28),
                borderRadius: AppRadii.pillAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
