import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';
import 'widgets/timeline_stop_tile.dart';

/// Every station on a train's run with times (All / Major toggle).
class StopTimelineScreen extends ConsumerWidget {
  const StopTimelineScreen({super.key, this.trainId, this.viewState});

  final String? trainId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(uiSelectionProvider(UiSelections.stopFilter));
    final id = ref.watch(trainIdProvider(trainId));
    final train = resolved(ref, id, (v) => ref.watch(trainProvider(v))).value;
    final stops = resolved(ref, id, (v) => ref.watch(trainStopsProvider(v)));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.stopTimeline,
              subtitle: train == null
                  ? null
                  : '${train.name.of(context)} · #${train.number}',
              trailing: CircleIconButton(
                icon: Icons.map_outlined,
                semanticLabel: l10n.routeMap,
                onPressed: train == null
                    ? null
                    : () => context.push(
                        AppRoutes.withId(AppRoutes.routeMap, train.id),
                      ),
              ),
            ),
            Padding(
              padding: AppSpacing.page,
              child: MaxWidth(
                child: SegmentedTabs(
                  labels: [l10n.allStops, l10n.majorStops],
                  selectedIndex: filter,
                  onSelected: (i) => ref
                      .read(
                        uiSelectionProvider(UiSelections.stopFilter).notifier,
                      )
                      .select(i),
                ),
              ),
            ),
            Expanded(
              child: AsyncView<List<TrainStop>?>(
                value: stops,
                state: viewState,
                isEmpty: (s) => s == null || s.isEmpty,
                onRetry: id.value == null
                    ? null
                    : () => ref.invalidate(trainStopsProvider(id.value!)),
                content: (_, s) => _TimelineContent(
                  stops: filter == 1
                      ? s!.where((x) => x.isMajor).toList()
                      : s!,
                  source: train?.source,
                ),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.timeline_rounded,
                    title: l10n.emptyStopsTitle,
                    message: l10n.emptyStopsBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: ShimmerList(itemCount: 7, itemHeight: 44),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineContent extends StatelessWidget {
  const _TimelineContent({required this.stops, this.source});

  final List<TrainStop> stops;
  final String? source;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageScroll(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        AppCard(
          radius: AppRadii.cardXl,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.s18,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Column(
            children: [
              for (var i = 0; i < stops.length; i++)
                TimelineStopTile(
                  time: stops[i].displayTime,
                  station: stops[i].station.name.of(context),
                  note: _note(context, stops[i], i),
                  tag: i == stops.length - 1 ? l10n.terminus : null,
                  tagTone: StatusTone.neutral,
                  isEndpoint: i == 0 || i == stops.length - 1,
                  isLast: i == stops.length - 1,
                  onTap: () => context.push(
                    AppRoutes.withId(
                      AppRoutes.stationDetails,
                      stops[i].station.id,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Text(
          l10n.timetableSourceNote(source ?? 'seat61.com'),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  String? _note(BuildContext context, TrainStop s, int i) {
    final l10n = context.l10n;
    final parts = <String>[];
    if (s.arriveTime != null &&
        s.departTime != null &&
        s.arriveTime != s.departTime) {
      parts.add('${s.arriveTime} → ${s.departTime}');
    }
    if (s.dayOffset > 0) parts.add(l10n.nextDayShort);
    if (s.station.lineName != null && i == 0) {
      parts.add(s.station.lineName!.of(context));
    }
    return parts.isEmpty ? null : parts.join(' · ');
  }
}
