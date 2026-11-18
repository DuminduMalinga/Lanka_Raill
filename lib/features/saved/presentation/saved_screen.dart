import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Saved tab: counters, saved trains and saved places.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageScroll(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.navClearance,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.savedTitle,
                    style: AppTextStyles.h2.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.savedSubtitle,
                  style: AppTextStyles.body.copyWith(color: palette.textMuted),
                ),
              ],
            ),
            UiStateView(
              state: viewState,
              content: (_) => const _SavedContent(),
              empty: (_) => EmptyState(
                icon: Icons.bookmark_border_rounded,
                title: l10n.emptySavedTitle,
                message: l10n.emptySavedBody,
              ),
              loading: (_) =>
                  const ShimmerList(itemCount: 4, padding: EdgeInsets.zero),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedContent extends StatelessWidget {
  const _SavedContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void train() => context.push(AppRoutes.trainDetails);
    void place() => context.push(AppRoutes.destinationDetails);
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SavedCounter(
                icon: Icons.train_outlined,
                count: '3',
                label: l10n.statTrains,
                onTap: () => context.push(AppRoutes.favoriteTrains),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.route_outlined,
                count: '2',
                label: l10n.statRoutes,
                onTap: () => context.push(AppRoutes.favoriteTrains),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.location_city_outlined,
                count: '4',
                label: l10n.statStations,
                onTap: () => context.push(AppRoutes.stationDirectory),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.place_outlined,
                count: '5',
                label: l10n.statPlaces,
                onTap: () => context.push(AppRoutes.favoriteDestinations),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: l10n.savedTrains,
          actionLabel: l10n.seeAll,
          onAction: () => context.push(AppRoutes.favoriteTrains),
        ),
        const SizedBox(height: AppSpacing.sm),
        SavedTrainTile(
          trainName: 'Podi Menike #1005',
          route: 'Colombo Fort → Badulla',
          nextDepartureLabel: l10n.nextDeparture,
          nextDepartureTime: '05:55',
          onTap: train,
        ),
        const SizedBox(height: AppSpacing.s10),
        SavedTrainTile(
          trainName: 'Ruhunu Kumari #8058',
          route: 'Maradana → Matara',
          nextDepartureLabel: l10n.nextDeparture,
          nextDepartureTime: '15:50',
          onTap: train,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: l10n.savedPlaces,
          actionLabel: l10n.seeAll,
          onAction: () => context.push(AppRoutes.favoriteDestinations),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: DestinationGridTile(
                  title: 'Nine Arch Bridge',
                  subtitle: 'Ella',
                  imageAsset: AppAssets.nineArchBridge,
                  onTap: place,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 150,
                child: DestinationGridTile(
                  title: 'Galle Fort',
                  subtitle: 'Galle',
                  placeholderColor: AppColors.photoSea,
                  onTap: place,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(
                width: 150,
                child: DestinationGridTile(
                  title: 'Temple of the Tooth',
                  subtitle: 'Kandy',
                  placeholderColor: AppColors.photoEarth,
                  onTap: place,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Small count tile (icon, number, label).
class SavedCounter extends StatelessWidget {
  const SavedCounter({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String count;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      semanticLabel: '$count $label',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: ExcludeSemantics(
        child: Column(
          children: [
            Icon(icon, size: AppSizes.icon, color: palette.primary),
            const SizedBox(height: AppSpacing.s6),
            Text(
              count,
              style: AppTextStyles.statValue.copyWith(
                color: palette.textPrimary,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label.copyWith(color: palette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
