import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

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
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/station_tile.dart';
import '../../../data/providers.dart';

/// Saved tab: counters, saved trains and saved places.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final signedIn = ref.watch(isSignedInProvider);
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
            if (!signedIn && viewState == null)
              EmptyState(
                icon: Icons.lock_outline_rounded,
                title: l10n.emptySavedTitle,
                message: l10n.signInForSaved,
                action: PrimaryButton(
                  label: l10n.signIn,
                  expand: false,
                  onPressed: () => context.push(AppRoutes.signIn),
                ),
              )
            else
            AsyncView<SavedItems>(
              value: ref.watch(savedItemsProvider),
              state: viewState,
              isEmpty: (s) => s.isEmpty,
              onRetry: () => ref.invalidate(savedItemsProvider),
              content: (_, s) => _SavedContent(items: s),
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

class _SavedContent extends ConsumerWidget {
  const _SavedContent({required this.items});

  final SavedItems items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final routes = ref.watch(recentSearchesProvider).value?.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SavedCounter(
                icon: Icons.train_outlined,
                count: '${items.trains.length}',
                label: l10n.statTrains,
                onTap: () => context.push(AppRoutes.favoriteTrains),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.route_outlined,
                count: '$routes',
                label: l10n.statRoutes,
                onTap: () => context.push(AppRoutes.journeySearch),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.location_city_outlined,
                count: '${items.stations.length}',
                label: l10n.statStations,
                onTap: () => context.push(AppRoutes.stationDirectory),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SavedCounter(
                icon: Icons.place_outlined,
                count: '${items.destinations.length}',
                label: l10n.statPlaces,
                onTap: () => context.push(AppRoutes.favoriteDestinations),
              ),
            ),
          ],
        ),
        if (items.trains.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: l10n.savedTrains,
            actionLabel: l10n.seeAll,
            onAction: () => context.push(AppRoutes.favoriteTrains),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final t in items.trains.take(3)) ...[
            SavedTrainTile(
              trainName: '${t.name.of(context)} #${t.number}',
              route: l10n.fromTo(
                t.originName.of(context),
                t.destinationName.of(context),
              ),
              nextDepartureLabel: l10n.nextDeparture,
              nextDepartureTime: t.departTime,
              onTap: () =>
                  context.push(AppRoutes.withId(AppRoutes.trainDetails, t.id)),
            ),
            const SizedBox(height: AppSpacing.s10),
          ],
        ],
        if (items.stations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: l10n.statStations),
          const SizedBox(height: AppSpacing.sm),
          for (final s in items.stations) ...[
            StationTile(
              code: s.code,
              name: s.name.en,
              nativeName: s.name.si,
              subtitle: s.lineName?.of(context) ?? '',
              showChevron: true,
              onTap: () =>
                  context.push(AppRoutes.withId(AppRoutes.stationDetails, s.id)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
        if (items.destinations.isNotEmpty) ...[
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
                for (final d in items.destinations) ...[
                  SizedBox(
                    width: 150,
                    child: DestinationGridTile(
                      title: d.name.of(context),
                      subtitle: d.nearest?.station.name.of(context) ?? '',
                      imageUrl: d.coverUrl,
                      placeholderColor: AppColors.photoEarth,
                      onTap: () => context.push(
                        AppRoutes.withId(AppRoutes.destinationDetails, d.id),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
              ],
            ),
          ),
        ],
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
