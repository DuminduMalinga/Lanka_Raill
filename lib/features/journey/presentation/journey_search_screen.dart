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
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/journey_stations_card.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/providers.dart';

/// "Plan a journey": stations, date, time slot, class, recent searches.
class JourneySearchScreen extends ConsumerWidget {
  const JourneySearchScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final slot = ref.watch(uiSelectionProvider(UiSelections.departureSlot));
    final travelClass = ref.watch(
      uiSelectionProvider(UiSelections.travelClass),
    );
    void select(String id, int i) =>
        ref.read(uiSelectionProvider(id).notifier).select(i);
    final journey = ref.watch(journeyProvider);
    final from = ref.watch(stationByCodeProvider(journey.fromCode)).value;
    final to = ref.watch(stationByCodeProvider(journey.toCode)).value;
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.planJourney),
            Expanded(
              child: PageScroll(
                spacing: AppSpacing.s18,
                children: [
                  JourneyStationsCard(
                    fromLabel: l10n.from,
                    from: from?.name.of(context) ?? journey.fromCode,
                    fromCode: journey.fromCode,
                    toLabel: l10n.to,
                    to: to?.name.of(context) ?? journey.toCode,
                    toCode: journey.toCode,
                    onFromTap: () => context.push(AppRoutes.departureStation),
                    onToTap: () => context.push(AppRoutes.arrivalStation),
                    onSwap: () => ref.read(journeyProvider.notifier).swap(),
                  ),
                  _Labelled(title: l10n.travelDate, child: const _DateStrip()),
                  _Labelled(
                    title: l10n.departureTime,
                    child: ChoicePillRow(
                      wrap: true,
                      padding: EdgeInsets.zero,
                      labels: [
                        l10n.anyTime,
                        l10n.morning,
                        l10n.afternoon,
                        l10n.night,
                      ],
                      selectedIndex: slot,
                      onSelected: (i) => select(UiSelections.departureSlot, i),
                    ),
                  ),
                  _Labelled(
                    title: l10n.travelClass,
                    child: ChoicePillRow(
                      wrap: true,
                      padding: EdgeInsets.zero,
                      labels: [
                        l10n.classAll,
                        l10n.class1stObservation,
                        l10n.class2nd,
                        l10n.class3rd,
                      ],
                      selectedIndex: travelClass,
                      onSelected: (i) => select(UiSelections.travelClass, i),
                    ),
                  ),
                  PrimaryButton(
                    label: l10n.searchTrains,
                    icon: Icons.search_rounded,
                    tone: PrimaryButtonTone.dark,
                    onPressed: () {
                      ref
                          .read(recentSearchesProvider.notifier)
                          .add(journey.fromCode, journey.toCode);
                      context.push(AppRoutes.searchResults);
                    },
                  ),
                  _Labelled(
                    title: l10n.recentSearches,
                    child: AsyncView<List<RecentSearch>>(
                      value: recent,
                      state: viewState,
                      isEmpty: (r) => r.isEmpty,
                      content: (_, r) => _RecentContent(searches: r),
                      empty: (_) => EmptyState(
                        icon: Icons.history_rounded,
                        title: l10n.emptyRecentTitle,
                        message: l10n.emptyRecentBody,
                      ),
                      loading: (_) => const ShimmerList(
                        itemCount: 3,
                        itemHeight: 40,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: AppSpacing.s10),
        child,
      ],
    );
  }
}

class _DateStrip extends ConsumerWidget {
  const _DateStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = ref.watch(journeyProvider.select((q) => q.date));
    final days = DateLabels.upcomingDays(4);
    final selected = days.indexWhere((d) => DateUtils.isSameDay(d, date));
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                    onTap: () =>
                        ref.read(journeyProvider.notifier).setDate(days[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        CircleIconButton(
          icon: Icons.calendar_month_outlined,
          semanticLabel: l10n.pickDate,
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date.isBefore(days.first) ? days.first : date,
              firstDate: days.first,
              lastDate: days.first.add(const Duration(days: 60)),
            );
            if (picked != null) {
              ref.read(journeyProvider.notifier).setDate(picked);
            }
          },
        ),
      ],
    );
  }
}

class _RecentContent extends ConsumerWidget {
  const _RecentContent({required this.searches});

  final List<RecentSearch> searches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    String name(String code) =>
        ref.watch(stationByCodeProvider(code)).value?.name.of(context) ?? code;
    return Column(
      children: [
        for (final r in searches)
          RecentSearchRow(
            route: context.l10n.fromTo(name(r.fromCode), name(r.toCode)),
            when: DateLabels.dayMonth(r.at, locale),
            onTap: () {
              ref.read(journeyProvider.notifier).set(r.fromCode, r.toCode);
              context.push(AppRoutes.searchResults);
            },
          ),
      ],
    );
  }
}

/// History row: clock icon, route, relative date.
class RecentSearchRow extends StatelessWidget {
  const RecentSearchRow({
    super.key,
    required this.route,
    required this.when,
    this.onTap,
  });

  final String route;
  final String when;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap ?? () => context.push(AppRoutes.searchResults),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: palette.border)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: AppSizes.icon,
              color: palette.textMuted,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                route,
                style: AppTextStyles.bodyStrong.copyWith(
                  color: palette.textPrimary,
                ),
              ),
            ),
            Text(
              when,
              style: AppTextStyles.caption.copyWith(color: palette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
