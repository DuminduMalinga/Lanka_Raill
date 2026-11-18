import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/journey_stations_card.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Trains tab: pick stations, day and time slot, then browse departures.
class AllTrainsScreen extends ConsumerWidget {
  const AllTrainsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final slot = ref.watch(uiSelectionProvider(UiSelections.trainsSlot));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(title: l10n.findAvailableTrains)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.lg,
                AppSpacing.gutter,
                0,
              ),
              // Design preview content — stations come from user selection.
              sliver: SliverToBoxAdapter(
                child: JourneyStationsCard(
                  fromLabel: l10n.fromYourStation,
                  from: 'Colombo Fort',
                  toLabel: l10n.toDestination,
                  to: 'Ella',
                  onFromTap: () => context.push(AppRoutes.departureStation),
                  onToTap: () => context.push(AppRoutes.arrivalStation),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _DayStrip()),
            SliverToBoxAdapter(
              child: ChoicePillRow(
                labels: [
                  l10n.anyTime,
                  l10n.morning,
                  l10n.afternoon,
                  l10n.evening,
                ],
                selectedIndex: slot,
                onSelected: (i) => ref
                    .read(uiSelectionProvider(UiSelections.trainsSlot).notifier)
                    .select(i),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                AppSpacing.navClearance,
              ),
              sliver: SliverToBoxAdapter(
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _TrainsContent(),
                  empty: (_) => EmptyState(
                    icon: Icons.train_outlined,
                    title: l10n.emptyTrainsTitle,
                    message: l10n.emptyTrainsBody,
                  ),
                  loading: (_) => const ShimmerList(
                    itemCount: 3,
                    itemHeight: 150,
                    padding: EdgeInsets.zero,
                    header: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: palette.background,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.trainsEyebrow,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: palette.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleIconButton(
            icon: Icons.notifications_none_rounded,
            semanticLabel: l10n.announcements,
            onPressed: () => context.push(AppRoutes.announcements),
          ),
        ],
      ),
    );
  }
}

class _DayStrip extends ConsumerWidget {
  const _DayStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final selected = ref.watch(uiSelectionProvider(UiSelections.trainsDate));
    final days = DateLabels.upcomingDays(7);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            DateChip(
              weekday: i == 0
                  ? l10n.today
                  : DateLabels.weekday(days[i], locale),
              day: DateLabels.day(days[i], locale),
              selected: i == selected,
              onTap: () => ref
                  .read(uiSelectionProvider(UiSelections.trainsDate).notifier)
                  .select(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrainsContent extends StatelessWidget {
  const _TrainsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateLabels.weekdayDayMonth(DateTime.now(), locale);
    void open() => context.push(AppRoutes.trainDetails);
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.dateAndCount(l10n.trainsCount(3), date),
            style: AppTextStyles.sectionTitle.copyWith(
              color: palette.textPrimary,
            ),
          ),
        ),
        Text(
          l10n.stillToDepart(2),
          style: AppTextStyles.caption.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        TrainCard(
          dimmed: true,
          trainName: 'Podi Menike',
          trainMeta: '#1005 · Express',
          tag: TrainTag(l10n.departed, tone: StatusTone.neutral),
          departTime: '05:55',
          from: 'Colombo Fort',
          duration: '9h 20m',
          stopsLabel: l10n.stopsCount(8),
          arriveTime: '15:15',
          to: 'Ella',
          footer: 'Main Line · 2nd · 3rd',
          onTap: open,
        ),
        const SizedBox(height: AppSpacing.md),
        TrainCard(
          trainName: 'Udarata Menike',
          trainMeta: '#1015 · Express',
          tag: TrainTag(l10n.scenic, tone: StatusTone.lime),
          departTime: '08:30',
          from: 'Colombo Fort',
          duration: '9h 25m',
          stopsLabel: l10n.stopsCount(8),
          arriveTime: '17:55',
          to: 'Ella',
          footer: 'Main Line · 1st Obs. · 2nd · 3rd',
          onTap: open,
        ),
        const SizedBox(height: AppSpacing.md),
        TrainCard(
          trainName: 'Night Mail',
          trainMeta: '#1045 · Mail',
          departTime: '20:00',
          from: 'Colombo Fort',
          duration: '10h 40m',
          stopsLabel: l10n.stopsCount(7),
          arriveTime: '06:40',
          arriveNote: l10n.nextDay,
          to: 'Ella',
          footer: 'Main Line · 1st Sleeper · 2nd · 3rd',
          onTap: open,
        ),
      ],
    );
  }
}
