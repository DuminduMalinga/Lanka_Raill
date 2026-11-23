import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_map.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/map_layers.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';
import 'widgets/map_top_bar.dart';

/// Map of stations near a destination with a distance-sorted list.
class NearbyStationsScreen extends ConsumerWidget {
  const NearbyStationsScreen({super.key, this.destinationId, this.viewState});

  final String? destinationId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(destinationIdProvider(destinationId));
    final dest = resolved(ref, id, (v) => ref.watch(destinationProvider(v)));
    final d = dest.value;
    final mapHeight = (MediaQuery.sizeOf(context).height * 0.44).clamp(
      260.0,
      420.0,
    );
    final stationPoints = [
      for (final n in d?.nearestStations ?? const <NearbyStation>[])
        if (n.station.hasLocation)
          (LatLng(n.station.lat!, n.station.lng!), n.station.code),
    ];
    final destPoint = d?.lat != null && d?.lng != null
        ? LatLng(d!.lat!, d.lng!)
        : null;
    final (center, zoom) = fitPoints([
      for (final p in stationPoints) p.$1,
      ?destPoint,
    ]);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: mapHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AppMap(
                    key: ValueKey('${center.latitude},${center.longitude}'),
                    center: center,
                    zoom: zoom,
                    controlsAlignment: Alignment.bottomRight,
                    children: [
                      MarkerLayer(
                        markers: [
                          for (final p in stationPoints)
                            Marker(
                              point: p.$1,
                              width: 56,
                              height: 46,
                              alignment: Alignment.topCenter,
                              child: MapPin(label: p.$2),
                            ),
                          if (destPoint != null)
                            Marker(
                              point: destPoint,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.lime,
                                size: 36,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: MapTopBar(
                    title: l10n.nearPlace(d?.name.of(context) ?? ''),
                    titleIcon: Icons.location_on_outlined,
                    fallbackRoute: AppRoutes.explore,
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
                child: AsyncView<Destination?>(
                  value: dest,
                  state: viewState,
                  isEmpty: (v) => v == null || v.nearestStations.isEmpty,
                  content: (_, v) => _NearbyContent(stations: v!.nearestStations),
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
  const _NearbyContent({required this.stations});

  final List<NearbyStation> stations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
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
        for (var i = 0; i < stations.length; i++)
          NearbyStationTile(
            name: stations[i].station.name.of(context),
            subtitle: stations[i].station.lineName?.of(context) ?? '',
            distance: stations[i].km == null
                ? ''
                : l10n.approxKm(stations[i].km!.toStringAsFixed(1)),
            travelTime: stations[i].station.code,
            highlighted: i == 0,
            onTap: () => context.push(
              AppRoutes.withId(AppRoutes.stationDetails, stations[i].station.id),
            ),
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
