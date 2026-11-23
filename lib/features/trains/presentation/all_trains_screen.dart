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
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/journey_stations_card.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Trains tab: pick stations, day and time slot, then browse departures.
class AllTrainsScreen extends ConsumerWidget {
  const AllTrainsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final slot = ref.watch(uiSelectionProvider(UiSelections.trainsSlot));
    final dayIndex = ref.watch(uiSelectionProvider(UiSelections.trainsDate));
    final day = DateLabels.upcomingDays(7)[dayIndex.clamp(0, 6)];
    final journey = ref.watch(journeyProvider);
    final from = ref.watch(stationByCodeProvider(journey.fromCode)).value;
    final to = ref.watch(stationByCodeProvider(journey.toCode)).value;
    final trains = ref.watch(trainsProvider).whenData(
      (all) => all.where((t) {
        if (!runsOnDay(t.runsOn, day.weekday)) return false;
        final m = t.departMinutes;
        return switch (slot) {
          1 => m < 12 * 60,
          2 => m >= 12 * 60 && m < 17 * 60,
          3 => m >= 17 * 60,
          _ => true,
        };
      }).toList(),
    );

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
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    JourneyStationsCard(
                      fromLabel: l10n.fromYourStation,
                      from: from?.name.of(context) ?? journey.fromCode,
                      fromCode: journey.fromCode,
                      toLabel: l10n.toDestination,
                      to: to?.name.of(context) ?? journey.toCode,
                      toCode: journey.toCode,
                      onFromTap: () => context.push(AppRoutes.departureStation),
                      onToTap: () => context.push(AppRoutes.arrivalStation),
                      onSwap: () => ref.read(journeyProvider.notifier).swap(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      label: l10n.searchTrains,
                      icon: Icons.search_rounded,
                      tone: PrimaryButtonTone.dark,
                      onPressed: () {
                        ref.read(journeyProvider.notifier).setDate(day);
                        ref
                            .read(recentSearchesProvider.notifier)
                            .add(journey.fromCode, journey.toCode);
                        context.push(AppRoutes.searchResults);
                      },
                    ),
                  ],
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
                child: AsyncView<List<TrainSummary>>(
                  value: trains,
                  state: viewState,
                  isEmpty: (t) => t.isEmpty,
                  onRetry: () => ref.invalidate(trainsProvider),
                  content: (_, t) => _TrainsContent(trains: t, day: day),
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
  const _TrainsContent({required this.trains, required this.day});

  final List<TrainSummary> trains;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateLabels.weekdayDayMonth(day, locale);
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(day, now);
    final nowMin = now.hour * 60 + now.minute;
    final remaining = isToday
        ? trains.where((t) => t.departMinutes >= nowMin).length
        : trains.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.dateAndCount(l10n.trainsCount(trains.length), date),
            style: AppTextStyles.sectionTitle.copyWith(
              color: palette.textPrimary,
            ),
          ),
        ),
        Text(
          l10n.stillToDepart(remaining),
          style: AppTextStyles.caption.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final t in trains) ...[
          TrainCard(
            dimmed: isToday && t.departMinutes < nowMin,
            trainName: t.name.of(context),
            trainMeta: '#${t.number} · ${t.type}',
            tag: isToday && t.departMinutes < nowMin
                ? TrainTag(l10n.departed, tone: StatusTone.neutral)
                : switch (t.type) {
                    'Express' => TrainTag(t.type, tone: StatusTone.lime),
                    'Night Mail' => TrainTag(t.type, tone: StatusTone.blue),
                    _ => null,
                  },
            departTime: t.departTime,
            from: t.originName.of(context),
            duration: formatDuration(t.durationMinutes),
            stopsLabel: l10n.stopsCount((t.stopCount - 2).clamp(0, 99)),
            arriveTime: t.arriveTime,
            arriveNote: t.arriveDay > 0 ? l10n.nextDay : null,
            to: t.destinationName.of(context),
            footer: l10n.runsOn(t.runsOn),
            onTap: () =>
                context.push(AppRoutes.withId(AppRoutes.trainDetails, t.id)),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
