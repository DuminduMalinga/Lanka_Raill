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
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Stations of a line in route order (taken from its longest train).
final _lineStationsProvider = FutureProvider.family<List<Station>, String>((
  ref,
  lineId,
) async {
  final stations = await ref.watch(stationsProvider.future);
  final trains = await ref.watch(trainsProvider.future);
  final onLine = stations.where((s) => s.lineId == lineId).toList();
  final lineTrains = trains.where((t) => t.lineId == lineId).toList()
    ..sort((a, b) => b.stopCount.compareTo(a.stopCount));
  if (lineTrains.isEmpty) return onLine;
  final stops = await ref.watch(trainStopsProvider(lineTrains.first.id).future);
  final ordered = [
    for (final s in stops)
      if (s.station.lineId == lineId) s.station,
  ];
  final seen = ordered.map((s) => s.id).toSet();
  return [...ordered, ...onLine.where((s) => !seen.contains(s.id))];
});

/// A single railway line: stats, key stations, trains, places.
class LineDetailsScreen extends ConsumerWidget {
  const LineDetailsScreen({super.key, this.lineId, this.viewState});

  final String? lineId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(lineIdProvider(lineId));
    final lines = ref.watch(linesProvider);
    final line = resolved<RailwayLine>(
      ref,
      id,
      (v) => lines.whenData((all) {
        for (final l in all) {
          if (l.id == v) return l;
        }
        return null;
      }),
    );
    final l = line.value;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoHeader(
              imageAsset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              height: 280,
              title: l?.name.of(context) ?? '',
              subtitle: l?.description?.of(context),
              tags: [
                if (l != null)
                  StatusChip(
                    label: l10n.stationsCount(l.stationCount),
                    tone: StatusTone.lime,
                  ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: AsyncView<RailwayLine?>(
                  value: line,
                  state: viewState,
                  isEmpty: (v) => v == null,
                  onRetry: () => ref.invalidate(linesProvider),
                  content: (_, v) => _LineContent(line: v!),
                  empty: (_) => EmptyState(
                    icon: Icons.route_outlined,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                  loading: (_) =>
                      const ShimmerList(itemCount: 4, padding: EdgeInsets.zero),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineContent extends ConsumerWidget {
  const _LineContent({required this.line});

  final RailwayLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stations = ref.watch(_lineStationsProvider(line.id)).value ?? const [];
    final trains = (ref.watch(trainsProvider).value ?? const <TrainSummary>[])
        .where((t) => t.lineId == line.id)
        .toList();
    final stationIds = stations.map((s) => s.id).toSet();
    final places = (ref.watch(destinationsProvider(null)).value ?? const [])
        .where((d) => d.nearestStations.any((n) => stationIds.contains(n.station.id)))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EqualRow(
          children: [
            StatTile(value: '${stations.length}', label: l10n.allStations),
            StatTile(value: '${trains.length}', label: l10n.trainsOnLine),
            StatTile(value: '${places.length}', label: l10n.placesAlongLine),
          ],
        ),
        if (stations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: l10n.keyStations,
            actionLabel: l10n.allStations,
            onAction: () => context.push(AppRoutes.stationDirectory),
          ),
          const SizedBox(height: AppSpacing.sm),
          StationPath(
            stations: [for (final s in stations) s.name.of(context)],
            onStationTap: (i) => context.push(
              AppRoutes.withId(AppRoutes.stationDetails, stations[i].id),
            ),
          ),
        ],
        if (trains.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(title: l10n.trainsOnLine),
          const SizedBox(height: AppSpacing.sm),
          for (final t in trains) ...[
            TrainDepartureTile(
              time: t.departTime,
              trainName: t.name.of(context),
              subtitle:
                  '#${t.number} · ${l10n.toStation(t.destinationName.of(context))}',
              showChevron: true,
              onTap: () =>
                  context.push(AppRoutes.withId(AppRoutes.trainDetails, t.id)),
            ),
            const SizedBox(height: AppSpacing.s10),
          ],
        ],
        if (places.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionLabel(l10n.placesAlongLine),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final d in places)
                ActionChip(
                  label: Text(d.name.of(context)),
                  onPressed: () => context.push(
                    AppRoutes.withId(AppRoutes.destinationDetails, d.id),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Horizontal station path: dots joined by a rail with names below.
class StationPath extends StatelessWidget {
  const StationPath({super.key, required this.stations, this.onStationTap});

  final List<String> stations;
  final ValueChanged<int>? onStationTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < stations.length; i++)
              InkWell(
                onTap: onStationTap == null ? null : () => onStationTap!(i),
                borderRadius: AppRadii.cardAll,
                child: SizedBox(
                  width: 84,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == 0
                                    ? Colors.transparent
                                    : palette.primary.withValues(alpha: 0.35),
                              ),
                            ),
                            _PathDot(
                              endpoint: i == 0 || i == stations.length - 1,
                            ),
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == stations.length - 1
                                    ? Colors.transparent
                                    : palette.primary.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        stations[i],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.captionStrong.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PathDot extends StatelessWidget {
  const _PathDot({required this.endpoint});

  final bool endpoint;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: endpoint ? 18 : 12,
      height: endpoint ? 18 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: endpoint ? AppColors.lime : palette.surface,
        border: Border.all(
          color: endpoint ? palette.primary : palette.primary,
          width: endpoint ? 3 : 2,
        ),
      ),
    );
  }
}
