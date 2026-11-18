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
import '../../../core/widgets/ui_state_view.dart';
import 'widgets/timeline_stop_tile.dart';

/// Every station on a train's run with times (All / Major toggle).
class StopTimelineScreen extends ConsumerWidget {
  const StopTimelineScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(uiSelectionProvider(UiSelections.stopFilter));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.stopTimeline,
              subtitle: 'Podi Menike · #1005',
              trailing: CircleIconButton(
                icon: Icons.map_outlined,
                semanticLabel: l10n.routeMap,
                onPressed: () => context.push(AppRoutes.routeMap),
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
              child: UiStateView(
                state: viewState,
                content: (_) => const _TimelineContent(),
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
  const _TimelineContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void station() => context.push(AppRoutes.stationDetails);
    // Design preview content.
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
              TimelineStopTile(
                time: '05:55',
                station: 'Colombo Fort',
                note: 'Platform 6 · departs',
                isEndpoint: true,
                onTap: station,
              ),
              TimelineStopTile(
                time: '06:03',
                station: 'Maradana',
                onTap: station,
              ),
              TimelineStopTile(
                time: '07:42',
                station: 'Polgahawela',
                note: 'Junction for Northern Line',
                onTap: station,
              ),
              TimelineStopTile(
                time: '09:22',
                station: 'Peradeniya Jn',
                note: 'Change here for Kandy',
                onTap: station,
              ),
              TimelineStopTile(
                time: '11:52',
                station: 'Hatton',
                note: 'Tea country begins',
                onTap: station,
              ),
              TimelineStopTile(
                time: '12:35',
                station: 'Nanu Oya',
                tag: l10n.touristStop,
                note: 'For Nuwara Eliya · 8 km',
                onTap: station,
              ),
              TimelineStopTile(
                time: '13:20',
                station: 'Pattipola',
                tag: l10n.highestPoint,
                tagTone: StatusTone.neutral,
                note: 'Highest station · 1,898 m',
                onTap: station,
              ),
              TimelineStopTile(
                time: '14:10',
                station: 'Haputale',
                note: 'Lipton’s Seat',
                onTap: station,
              ),
              TimelineStopTile(
                time: '15:15',
                station: 'Ella',
                tag: l10n.touristStop,
                note: 'Nine Arch Bridge · Little Adam’s Peak',
                onTap: station,
              ),
              TimelineStopTile(
                time: '16:20',
                station: 'Badulla',
                tag: l10n.terminus,
                tagTone: StatusTone.neutral,
                isEndpoint: true,
                isLast: true,
                onTap: station,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
