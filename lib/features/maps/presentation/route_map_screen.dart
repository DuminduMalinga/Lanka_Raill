import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
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
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/map_layers.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';
import 'widgets/map_top_bar.dart';

/// Full-screen dark map for a train's route with a summary sheet.
class RouteMapScreen extends ConsumerWidget {
  const RouteMapScreen({super.key, this.trainId, this.viewState});

  final String? trainId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(trainIdProvider(trainId));
    final train = resolved(ref, id, (v) => ref.watch(trainProvider(v))).value;
    final stops = resolved(ref, id, (v) => ref.watch(trainStopsProvider(v)));
    final points = [
      for (final s in stops.value ?? const <TrainStop>[])
        if (s.station.hasLocation)
          (LatLng(s.station.lat!, s.station.lng!), s.station.code),
    ];
    final (center, zoom) = fitPoints([for (final p in points) p.$1]);
    final list = stops.value ?? const <TrainStop>[];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forestDeep,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppMap(
                      key: ValueKey('${center.latitude},${center.longitude},$zoom'),
                      center: center,
                      zoom: zoom,
                      controlsPadding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.xxl,
                      ),
                      controlsAlignment: Alignment.bottomRight,
                      children: routeLayers(
                        points,
                        onTap: (i) => context.push(
                          AppRoutes.withId(
                            AppRoutes.stationDetails,
                            list.where((s) => s.station.hasLocation).elementAt(i).station.id,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: MapTopBar(
                      title: train == null
                          ? context.l10n.routeMap
                          : '${train.name.of(context)} · #${train.number}',
                      fallbackRoute: AppRoutes.trainDetails,
                    ),
                  ),
                ],
              ),
            ),
            _RouteSheet(
              viewState: viewState,
              train: train,
              stops: stops,
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteSheet extends StatelessWidget {
  const _RouteSheet({this.viewState, this.train, required this.stops});

  final UiViewState? viewState;
  final TrainSummary? train;
  final AsyncValue<List<TrainStop>?> stops;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final t = train;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.forestDeep.withValues(alpha: 0.96),
        border: const Border(top: BorderSide(color: AppColors.hairlineOnDark)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.62,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.lg,
            ),
            child: MaxWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SheetHandle(),
                  const SizedBox(height: AppSpacing.lg),
                  AsyncView<List<TrainStop>?>(
                    value: stops,
                    state: viewState,
                    isEmpty: (s) => s == null || s.isEmpty || t == null,
                    content: (_, s) => _RouteSummary(train: t!, stops: s!),
                    empty: (_) => EmptyState(
                      onDark: true,
                      icon: Icons.map_outlined,
                      title: l10n.emptyDetailsTitle,
                      message: l10n.emptyDetailsBody,
                    ),
                    loading: (_) => const ShimmerList(
                      onDark: true,
                      itemCount: 2,
                      itemHeight: 64,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: l10n.stopTimeline,
                          icon: Icons.timeline_rounded,
                          tone: SecondaryButtonTone.glass,
                          onPressed: t == null
                              ? null
                              : () => context.push(
                                  AppRoutes.withId(AppRoutes.stopTimeline, t.id),
                                ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s10),
                      Expanded(
                        child: PrimaryButton(
                          label: l10n.exploreStops,
                          icon: Icons.explore_outlined,
                          onPressed: () => context.go(AppRoutes.explore),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.25),
          borderRadius: AppRadii.pillAll,
        ),
      ),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.train, required this.stops});

  final TrainSummary train;
  final List<TrainStop> stops;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Row(
          children: [
            const IconTile(
              icon: Icons.route_rounded,
              size: 44,
              radius: AppRadii.iconTileLg,
              background: AppColors.lime,
              foreground: AppColors.ink,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fromTo(
                      train.originName.of(context),
                      train.destinationName.of(context),
                    ),
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    stops.map((s) => s.station.name.of(context)).join(' · '),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedOnDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        EqualRow(
          children: [
            StatTile(value: train.departTime, label: l10n.departureTime, onDark: true),
            StatTile(
              value: formatDuration(train.durationMinutes),
              label: l10n.journeyLower,
              onDark: true,
            ),
            StatTile(
              value: '${stops.length}',
              label: l10n.majorStopsLower,
              onDark: true,
            ),
          ],
        ),
      ],
    );
  }
}
