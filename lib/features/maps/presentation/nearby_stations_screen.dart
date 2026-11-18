import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_map.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/ui_state_view.dart';
import 'widgets/map_top_bar.dart';

/// Map of stations near a destination with a distance-sorted list.
class NearbyStationsScreen extends StatelessWidget {
  const NearbyStationsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mapHeight = (MediaQuery.sizeOf(context).height * 0.44).clamp(
      260.0,
      420.0,
    );
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: mapHeight,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: AppMap(
                    zoom: 12,
                    controlsAlignment: Alignment.bottomRight,
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: MapTopBar(
                    // Design preview content.
                    title: l10n.nearPlace('Nine Arch Bridge'),
                    titleIcon: Icons.location_on_outlined,
                    fallbackRoute: AppRoutes.explore,
                    trailing: CircleIconButton(
                      icon: Icons.near_me_outlined,
                      tone: CircleIconTone.accent,
                      semanticLabel: l10n.useMyLocation,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -AppSpacing.xl),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.palette.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadii.sheet),
                  ),
                ),
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _NearbyContent(),
                  empty: (_) => SingleChildScrollView(
                    child: EmptyState(
                      icon: Icons.location_off_outlined,
                      title: l10n.emptyStationsTitle,
                      message: l10n.emptyStationsBody,
                    ),
                  ),
                  loading: (_) => const SingleChildScrollView(
                    padding: EdgeInsets.only(top: AppSpacing.xxl),
                    child: ShimmerList(itemCount: 3, header: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyContent extends StatelessWidget {
  const _NearbyContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    void open() => context.push(AppRoutes.stationDetails);
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.md,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xxl,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.nearbyRailwayStations,
            style: AppTextStyles.h4.copyWith(color: palette.textPrimary),
          ),
        ),
        NearbyStationTile(
          name: 'Ella',
          subtitle: 'Main Line · tourist stop',
          distance: '2.5 km',
          travelTime: '≈35 min walk',
          highlighted: true,
          onTap: open,
        ),
        NearbyStationTile(
          name: 'Demodara',
          subtitle: 'Main Line · famous loop',
          distance: '3.8 km',
          travelTime: '≈15 min by tuk-tuk',
          onTap: open,
        ),
        NearbyStationTile(
          name: 'Kital Ella',
          subtitle: 'Main Line · small halt',
          distance: '4.1 km',
          travelTime: '≈15 min by tuk-tuk',
          onTap: open,
        ),
      ],
    );
  }
}

/// Station row with distance and travel time on the right.
class NearbyStationTile extends StatelessWidget {
  const NearbyStationTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.distance,
    required this.travelTime,
    this.highlighted = false,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final String distance;
  final String travelTime;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s14),
      borderColor: highlighted ? palette.primary : null,
      borderWidth: highlighted ? 2 : 1,
      child: Row(
        children: [
          IconTile(
            icon: Icons.train_outlined,
            size: 42,
            background: highlighted ? AppColors.lime : null,
            foreground: highlighted ? AppColors.ink : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  distance,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  travelTime,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.label.copyWith(color: palette.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
