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
import '../../../core/widgets/ui_state_view.dart';

/// Grid of destination categories.
class DestinationCategoriesScreen extends StatelessWidget {
  const DestinationCategoriesScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.destinationCategories),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _CategoriesContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.category_outlined,
                    title: l10n.emptyPlacesTitle,
                    message: l10n.emptyPlacesBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 4, itemHeight: 150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent();

  @override
  Widget build(BuildContext context) {
    void open() => context.push(AppRoutes.destinationDetails);
    // Design preview content.
    final tiles = <Widget>[
      CategoryTile(
        title: 'Hill country & tea',
        subtitle: 'Main Line · Hatton to Ella',
        icon: Icons.eco_outlined,
        color: AppColors.photoLeaf,
        onTap: open,
      ),
      CategoryTile(
        title: 'Beaches & coast',
        subtitle: 'Coastal Line · Bentota to Matara',
        icon: Icons.beach_access_outlined,
        color: AppColors.photoSea,
        onTap: open,
      ),
      CategoryTile(
        title: 'Ancient cities',
        subtitle: 'Anuradhapura, Polonnaruwa',
        icon: Icons.account_balance_outlined,
        color: AppColors.photoSand,
        onTap: open,
      ),
      CategoryTile(
        title: 'Wildlife & nature',
        subtitle: 'Horton Plains, Minneriya',
        icon: Icons.pets_outlined,
        color: AppColors.photoEarth,
        onTap: open,
      ),
      CategoryTile(
        title: 'Northern culture',
        subtitle: 'Northern Line · Jaffna',
        icon: Icons.temple_hindu_outlined,
        color: AppColors.forestRaised,
        onTap: open,
      ),
    ];
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        CategoryTile(
          title: 'Scenic bridges & views',
          subtitle: 'Nine Arch, Demodara loop',
          imageAsset: AppAssets.nineArchBridge,
          wide: true,
          onTap: open,
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
