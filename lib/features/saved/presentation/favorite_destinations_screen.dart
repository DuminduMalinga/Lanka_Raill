import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

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
    final saved = ref.watch(savedItemsProvider);
    final dests = saved.value?.destinations ?? const <Destination>[];
    final cats = <String, LocalizedText>{
      for (final d in dests)
        if (d.categoryId != null && d.categoryName != null)
          d.categoryId!: d.categoryName!,
    };
    final catIds = cats.keys.toList();
    final selectedCat = filter > 0 && filter <= catIds.length
        ? catIds[filter - 1]
        : null;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.favoriteDestinationsTitle,
            ),
            ChoicePillRow(
              labels: [
                l10n.allCount(dests.length),
                for (final id in catIds) cats[id]!.of(context),
              ],
              selectedIndex: filter.clamp(0, catIds.length),
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.favoriteDestFilter)
                        .notifier,
                  )
                  .select(i),
            ),
            Expanded(
              child: AsyncView<SavedItems>(
                value: saved,
                state: viewState,
                isEmpty: (s) => s.destinations.isEmpty,
                onRetry: () => ref.invalidate(savedItemsProvider),
                content: (_, s) => _DestinationsContent(
                  destinations: s.destinations
                      .where(
                        (d) => selectedCat == null || d.categoryId == selectedCat,
                      )
                      .toList(),
                ),
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
  const _DestinationsContent({required this.destinations});

  final List<Destination> destinations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = <Widget>[
      for (final d in destinations)
        DestinationGridTile(
          title: d.name.of(context),
          subtitle: [
            d.nearest?.station.name.of(context),
            d.nearest?.station.lineName?.of(context),
          ].whereType<String>().join(' · '),
          imageUrl: d.coverUrl,
          onTap: () => context.push(
            AppRoutes.withId(AppRoutes.destinationDetails, d.id),
          ),
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
