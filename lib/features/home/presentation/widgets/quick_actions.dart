import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Four shortcut tiles: Trains · Lines · Stations · Explore.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <(IconData, String, VoidCallback)>[
      (
        Icons.train_outlined,
        l10n.quickTrains,
        () => context.go(AppRoutes.trains),
      ),
      (
        Icons.route_outlined,
        l10n.quickLines,
        () => context.push(AppRoutes.railwayLines),
      ),
      (
        Icons.location_city_outlined,
        l10n.quickStations,
        () => context.push(AppRoutes.stationDirectory),
      ),
      (
        Icons.explore_outlined,
        l10n.quickExplore,
        () => context.go(AppRoutes.explore),
      ),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: _QuickAction(
              icon: items[i].$1,
              label: items[i].$2,
              onTap: items[i].$3,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.cardAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: palette.border),
                ),
                child: Icon(icon, color: palette.primary),
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionStrong.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
