import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Five-tab bottom navigation (Home · Trains · Explore · Saved · Profile).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final items = <(IconData, IconData, String)>[
      (Icons.home_outlined, Icons.home_rounded, l10n.navHome),
      (Icons.train_outlined, Icons.train_rounded, l10n.navTrains),
      (Icons.explore_outlined, Icons.explore_rounded, l10n.navExplore),
      (Icons.bookmark_border_rounded, Icons.bookmark_rounded, l10n.navSaved),
      (Icons.person_outline_rounded, Icons.person_rounded, l10n.navProfile),
    ];

    return Semantics(
      container: true,
      label: l10n.mainNavigation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border(top: BorderSide(color: palette.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.s10,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavItem(
                      icon: items[i].$1,
                      activeIcon: items[i].$2,
                      label: items[i].$3,
                      selected: i == currentIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        borderRadius: AppRadii.cardAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppDurations.fast,
                width: 52,
                height: 30,
                decoration: BoxDecoration(
                  color: selected ? AppColors.lime : Colors.transparent,
                  borderRadius: AppRadii.pillAll,
                ),
                child: Icon(
                  selected ? activeIcon : icon,
                  size: AppSizes.iconLg,
                  color: selected ? AppColors.ink : palette.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (selected
                            ? AppTextStyles.navLabelActive
                            : AppTextStyles.navLabel)
                        .copyWith(
                          color: selected ? palette.primary : palette.textMuted,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
