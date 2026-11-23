import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_photo.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/destination_card.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Destination categories; with `categoryId`, the places in one category.
class DestinationCategoriesScreen extends ConsumerWidget {
  const DestinationCategoriesScreen({
    super.key,
    this.categoryId,
    this.viewState,
  });

  final String? categoryId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider);
    final id = categoryId;
    DestinationCategory? current;
    for (final c in categories.value ?? const <DestinationCategory>[]) {
      if (c.id == id) current = c;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: current?.name.of(context) ?? l10n.destinationCategories,
            ),
            Expanded(
              child: id == null
                  ? AsyncView<List<DestinationCategory>>(
                      value: categories,
                      state: viewState,
                      isEmpty: (c) => c.every((x) => x.count == 0),
                      onRetry: () => ref.invalidate(categoriesProvider),
                      content: (_, c) => _CategoriesContent(
                        categories: c.where((x) => x.count > 0).toList(),
                      ),
                      empty: (_) => _empty(context),
                      loading: (_) => const SingleChildScrollView(
                        child: ShimmerList(itemCount: 4, itemHeight: 150),
                      ),
                    )
                  : AsyncView<List<Destination>>(
                      value: ref.watch(destinationsProvider(id)),
                      state: viewState,
                      isEmpty: (d) => d.isEmpty,
                      onRetry: () => ref.invalidate(destinationsProvider(id)),
                      content: (_, d) => _PlacesContent(destinations: d),
                      empty: (_) => _empty(context),
                      loading: (_) => const SingleChildScrollView(
                        child: ShimmerList(itemCount: 4, itemHeight: 120),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(BuildContext context) => SingleChildScrollView(
    child: EmptyState(
      icon: Icons.category_outlined,
      title: context.l10n.emptyPlacesTitle,
      message: context.l10n.emptyPlacesBody,
    ),
  );
}

class _CategoriesContent extends ConsumerWidget {
  const _CategoriesContent({required this.categories});

  final List<DestinationCategory> categories;

  static const _colors = [
    AppColors.photoLeaf,
    AppColors.photoSea,
    AppColors.photoSand,
    AppColors.photoEarth,
    AppColors.forestRaised,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final all = ref.watch(destinationsProvider(null)).value ?? const [];
    String? coverFor(String id) {
      for (final d in all) {
        if (d.categoryId == id && d.coverUrl != null) return d.coverUrl;
      }
      return null;
    }

    void open(DestinationCategory c) => context.push(
      AppRoutes.withId(AppRoutes.destinationCategories, c.id),
    );
    final tiles = <Widget>[
      for (var i = 1; i < categories.length; i++)
        CategoryTile(
          title: categories[i].name.of(context),
          subtitle: l10n.placesCount(categories[i].count),
          icon: categories[i].iconData,
          imageUrl: coverFor(categories[i].id),
          color: _colors[i % _colors.length],
          onTap: () => open(categories[i]),
        ),
    ];
    final first = categories.first;
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        CategoryTile(
          title: first.name.of(context),
          subtitle: l10n.placesCount(first.count),
          imageUrl: coverFor(first.id),
          imageAsset: coverFor(first.id) == null ? AppAssets.nineArchBridge : null,
          wide: true,
          onTap: () => open(first),
        ),
        for (var i = 0; i < tiles.length; i += 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: tiles[i]),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: i + 1 < tiles.length
                    ? tiles[i + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
      ],
    );
  }
}

class _PlacesContent extends StatelessWidget {
  const _PlacesContent({required this.destinations});

  final List<Destination> destinations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        for (final d in destinations)
          DestinationCard(
            title: d.name.of(context),
            description: d.description?.of(context) ?? '',
            stationLabel: d.nearest == null
                ? null
                : [
                    d.nearest!.station.name.of(context),
                    if (d.nearest!.km != null)
                      l10n.approxKm(d.nearest!.km!.toStringAsFixed(1)),
                  ].join(' · '),
            imageUrl: d.coverUrl,
            onTap: () => context.push(
              AppRoutes.withId(AppRoutes.destinationDetails, d.id),
            ),
          ),
      ],
    );
  }
}

/// Photo/colour tile with icon, title and subtitle.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.imageAsset,
    this.imageUrl,
    this.color = AppColors.forest,
    this.wide = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imageAsset;
  final String? imageUrl;
  final Color color;
  final bool wide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = imageAsset != null || imageUrl != null;
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      excludeSemantics: true,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.cardLg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: wide ? 160 : 168),
            child: Stack(
              children: [
                if (hasPhoto)
                  Positioned.fill(
                    child: AppPhoto(
                      asset: imageAsset,
                      imageUrl: imageUrl,
                      radius: 0,
                    ),
                  ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.35, 1],
                        colors: [Color(0x000B1912), Color(0xCC0B1912)],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s14),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (wide ? 160 : 168) - AppSpacing.s14 * 2,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (icon != null)
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(
                                  AppRadii.iconTile,
                                ),
                              ),
                              child: Icon(
                                icon,
                                size: AppSizes.icon,
                                color: AppColors.white,
                              ),
                            ),
                          const Spacer(),
                          Text(
                            title,
                            style: AppTextStyles.cardTitle.copyWith(
                              color: AppColors.white,
                              fontSize: wide ? 18 : 15,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.captionOnDark,
                            ),
                          ),
                        ],
                      ),
                    ),
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
