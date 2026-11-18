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
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Grid of saved destinations with category filters.
class FavoriteDestinationsScreen extends ConsumerWidget {
  const FavoriteDestinationsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(
      uiSelectionProvider(UiSelections.favoriteDestFilter),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.favoriteDestinationsTitle,
              trailing: CircleIconButton(
                icon: Icons.grid_view_rounded,
                semanticLabel: l10n.gridView,
                onPressed: () {},
              ),
            ),
            ChoicePillRow(
              labels: [
                l10n.allCount(5),
                l10n.catHillCountry,
                l10n.catCoast,
                l10n.catHeritage,
              ],
              selectedIndex: filter,
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.favoriteDestFilter)
                        .notifier,
                  )
                  .select(i),
            ),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _DestinationsContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.place_outlined,
                    title: l10n.emptySavedTitle,
                    message: l10n.emptySavedBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 3, itemHeight: 190),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationsContent extends StatelessWidget {
  const _DestinationsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open() => context.push(AppRoutes.destinationDetails);
    // Design preview content.
    final tiles = <Widget>[
      DestinationGridTile(
        title: 'Nine Arch Bridge',
        subtitle: 'Ella · Main Line',
        imageAsset: AppAssets.nineArchBridge,
        onTap: open,
      ),
      DestinationGridTile(
        title: 'Galle Fort',
        subtitle: 'Galle · Coastal Line',
        placeholderColor: AppColors.photoSea,
        onTap: open,
      ),
      DestinationGridTile(
        title: 'Temple of the Tooth',
        subtitle: 'Kandy · Main Line',
        placeholderColor: AppColors.photoEarth,
        onTap: open,
      ),
      DestinationGridTile(
        title: 'Horton Plains',
        subtitle: 'Ohiya · Main Line',
        placeholderColor: AppColors.photoLeaf,
        onTap: open,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 600 ? 3 : 2;
        return PageScroll(
          spacing: AppSpacing.md,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.sm,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          maxWidth: 900,
          children: [
            for (var i = 0; i < tiles.length; i += columns)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var c = 0; c < columns; c++) ...[
                    if (c > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: i + c < tiles.length
                          ? tiles[i + c]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: AppSpacing.xs),
            PrimaryButton(
              label: l10n.planTripSaved,
              icon: Icons.map_outlined,
              tone: PrimaryButtonTone.dark,
              onPressed: () => context.push(AppRoutes.journeySearch),
            ),
          ],
        );
      },
    );
  }
}
