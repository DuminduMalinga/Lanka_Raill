import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Explore tab: categories, featured place, easy trips from Colombo.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final category = ref.watch(
      uiSelectionProvider(UiSelections.exploreCategory),
    );
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final cats = categories.where((c) => c.count > 0).toList();
    final selectedCat = category > 0 && category <= cats.length
        ? cats[category - 1]
        : null;
    final destinations = ref.watch(destinationsProvider(selectedCat?.id));
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.navClearance),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.exploreEyebrow,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Semantics(
                          header: true,
                          child: Text(
                            l10n.exploreTitle,
                            style: AppTextStyles.h3.copyWith(
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.search_rounded,
                    semanticLabel: l10n.searchPlaces,
                    onPressed: () =>
                        context.push(AppRoutes.destinationCategories),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ChoicePillRow(
              height: 40,
              labels: [
                l10n.allCategories,
                for (final c in cats) c.name.of(context),
              ],
              icons: [
                Icons.explore_outlined,
                for (final c in cats) c.iconData,
              ],
              selectedIndex: category.clamp(0, cats.length),
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.exploreCategory).notifier,
                  )
                  .select(i),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                0,
              ),
              child: MaxWidth(
                child: AsyncView<List<Destination>>(
                  value: destinations,
                  state: viewState,
                  isEmpty: (d) => d.isEmpty,
                  onRetry: () =>
                      ref.invalidate(destinationsProvider(selectedCat?.id)),
                  content: (_, d) => _ExploreContent(destinations: d),
                  empty: (_) => EmptyState(
                    icon: Icons.explore_outlined,
                    title: l10n.emptyPlacesTitle,
                    message: l10n.emptyPlacesBody,
                  ),
                  loading: (_) => const ShimmerList(
                    itemCount: 3,
                    itemHeight: 90,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreContent extends ConsumerWidget {
  const _ExploreContent({required this.destinations});

  final List<Destination> destinations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final featured = destinations.firstWhere(
      (d) => d.name.en == 'Nine Arch Bridge',
      orElse: () => destinations.firstWhere(
        (d) => d.coverUrl != null,
        orElse: () => destinations.first,
      ),
    );
    final rest = destinations.where((d) => d.id != featured.id).toList();
    String stationLine(Destination d) {
      final n = d.nearest;
      if (n == null) return d.categoryName?.of(context) ?? '';
      return [
        n.station.name.of(context),
        n.station.lineName?.of(context),
        if (n.km != null) l10n.approxKm(n.km!.toStringAsFixed(1)),
      ].whereType<String>().join(' · ');
    }

    void open(Destination d) =>
        context.push(AppRoutes.withId(AppRoutes.destinationDetails, d.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FeaturedDestinationCard(
          imageAsset: featured.coverUrl == null ? AppAssets.nineArchBridge : null,
          imageUrl: featured.coverUrl,
          semanticLabel: featured.name.of(context),
          tagLabel: l10n.featured,
          title: featured.name.of(context),
          subtitle: stationLine(featured),
          ctaLabel: l10n.planTrip,
          onTap: () => open(featured),
          onCta: () {
            final n = featured.nearest;
            if (n != null) {
              final journey = ref.read(journeyProvider.notifier);
              journey.setTo(n.station.code);
              context.push(AppRoutes.searchResults);
            } else {
              open(featured);
            }
          },
        ),
        PhotoCredit(featured.coverCredit),
        const SizedBox(height: AppSpacing.s14),
        if (rest.isNotEmpty) ...[
          SectionHeader(
            title: l10n.easyByTrain,
            actionLabel: l10n.viewAll,
            onAction: () => context.push(AppRoutes.destinationCategories),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final d in rest) ...[
            DestinationCard(
              title: d.name.of(context),
              description: d.description?.of(context) ?? '',
              stationLabel: stationLine(d),
              imageUrl: d.coverUrl,
              placeholderColor: AppColors.photoEarth,
              onTap: () => open(d),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ],
    );
  }
}
