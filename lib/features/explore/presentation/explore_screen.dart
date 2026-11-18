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
import '../../../core/widgets/ui_state_view.dart';

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
                l10n.catHillCountry,
                l10n.catBeaches,
                l10n.catHeritage,
                l10n.catWildlife,
              ],
              icons: const [
                Icons.terrain_outlined,
                Icons.beach_access_outlined,
                Icons.account_balance_outlined,
                Icons.pets_outlined,
              ],
              selectedIndex: category,
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
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _ExploreContent(),
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

class _ExploreContent extends StatelessWidget {
  const _ExploreContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open() => context.push(AppRoutes.destinationDetails);
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FeaturedDestinationCard(
          imageAsset: AppAssets.nineArchBridge,
          semanticLabel: l10n.welcomeImageAlt,
          tagLabel: l10n.featured,
          title: 'Nine Arch Bridge',
          subtitle: 'Ella · Main Line · ≈2.5 km from station',
          ctaLabel: l10n.planTrip,
          onTap: open,
          onCta: () => context.push(AppRoutes.searchResults),
        ),
        const SizedBox(height: AppSpacing.s14),
        SectionHeader(
          title: l10n.easyByTrain,
          actionLabel: l10n.viewAll,
          onAction: () => context.push(AppRoutes.destinationCategories),
        ),
        const SizedBox(height: AppSpacing.sm),
        DestinationCard(
          title: 'Kandy',
          description: 'Temple of the Sacred Tooth Relic',
          stationLabel: 'Kandy station · Main Line',
          placeholderColor: AppColors.photoEarth,
          onTap: open,
        ),
        const SizedBox(height: AppSpacing.md),
        DestinationCard(
          title: 'Galle Fort',
          description: 'UNESCO-listed ramparts by the sea',
          stationLabel: 'Galle station · Coastal Line',
          placeholderColor: AppColors.photoSea,
          onTap: open,
        ),
      ],
    );
  }
}
