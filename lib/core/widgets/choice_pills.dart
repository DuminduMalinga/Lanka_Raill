import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'buttons.dart';

/// Single selectable pill: ink when selected, white with border otherwise.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.height = AppSizes.chipHeight,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fg = selected ? palette.onSelectedChip : palette.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? palette.selectedChip : palette.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? palette.selectedChip : palette.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            // Visual height follows the design; the row adds padding so the
            // effective tap target reaches 48dp.
            constraints: BoxConstraints(minHeight: height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
              child: Center(
                widthFactor: 1,
                child: IconLabel(
                  label: label,
                  icon: icon,
                  gap: AppSpacing.s6,
                  style: AppTextStyles.chip.copyWith(color: fg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row of [ChoicePill]s. Scrolls horizontally unless [wrap] is true.
class ChoicePillRow extends StatelessWidget {
  const ChoicePillRow({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.icons,
    this.wrap = false,
    this.padding = AppSpacing.page,
    this.height = AppSizes.chipHeight,
  });

  final List<String> labels;
  final List<IconData>? icons;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool wrap;
  final EdgeInsets padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    final pills = [
      for (var i = 0; i < labels.length; i++)
        ChoicePill(
          label: labels[i],
          icon: icons?[i],
          height: height,
          selected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
    ];
    if (wrap) {
      return Padding(
        padding: padding,
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: pills,
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding.copyWith(top: AppSpacing.s6, bottom: AppSpacing.s6),
      child: Row(
        children: [
          for (var i = 0; i < pills.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            pills[i],
          ],
        ],
      ),
    );
  }
}

/// Day picker tile (weekday + date number).
class DateChip extends StatelessWidget {
  const DateChip({
    super.key,
    required this.weekday,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final String weekday;
  final String day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fg = selected ? palette.onSelectedChip : palette.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      label: '$weekday $day',
      excludeSemantics: true,
      child: Material(
        color: selected ? palette.selectedChip : palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(
            color: selected ? palette.selectedChip : palette.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 58, minHeight: 66),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: AppTextStyles.label.copyWith(
                      color: fg.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    day,
                    style: AppTextStyles.titleMedium.copyWith(color: fg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Two-or-more option segmented control on a muted track.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.dark = false,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: dark ? AppColors.glass : palette.segmentTrack,
        borderRadius: BorderRadius.circular(AppRadii.cardXl),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: _Segment(
                label: labels[i],
                selected: i == selectedIndex,
                onTap: () => onSelected(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? palette.surface : Colors.transparent,
          borderRadius: AppRadii.pillAll,
          boxShadow: selected ? AppShadows.raised : null,
        ),
        child: InkWell(
          borderRadius: AppRadii.pillAll,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.chip.copyWith(
                    color: selected ? palette.textPrimary : palette.textMuted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
