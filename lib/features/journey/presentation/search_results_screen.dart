import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Results for a From → To search with sort pills.
class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final sort = ref.watch(uiSelectionProvider(UiSelections.resultsSort));
    final date = DateLabels.weekdayDayMonth(DateTime.now(), locale);
    // Design preview content: route + result count come from the search.
    const route = 'Colombo Fort → Ella';
    const count = 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: route,
              subtitle: l10n.dateAndCount(date, l10n.trainsCount(count)),
              trailing: CircleIconButton(
                icon: Icons.tune_rounded,
                semanticLabel: l10n.filters,
                onPressed: () {},
              ),
            ),
            ChoicePillRow(
              labels: [
                l10n.sortEarliest,
                l10n.sortFastest,
                l10n.sortScenic,
                l10n.sortObservation,
              ],
              selectedIndex: sort,
              onSelected: (i) => ref
                  .read(uiSelectionProvider(UiSelections.resultsSort).notifier)
                  .select(i),
            ),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _ResultsContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.train_outlined,
                    title: l10n.emptyTrainsTitle,
                    message: l10n.emptyTrainsBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  padding: EdgeInsets.only(top: AppSpacing.s14),
                  child: ShimmerList(itemCount: 3, itemHeight: 170),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsContent extends StatelessWidget {
  const _ResultsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open() => context.push(AppRoutes.trainDetails);
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.md,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s10,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        TrainCard(
          highlighted: true,
          trainName: 'Podi Menike',
          trainMeta: '#1005 · Express',
          tag: TrainTag(l10n.scenic, tone: StatusTone.lime),
          departTime: '05:55',
          from: 'Colombo Fort',
          duration: '9h 20m',
          arriveTime: '15:15',
          to: 'Ella',
          classes: const ['2nd', '3rd', 'Reserved'],
          onTap: open,
        ),
        TrainCard(
          trainName: 'Udarata Menike',
          trainMeta: '#1015 · Express',
          tag: TrainTag(l10n.sortObservation),
          departTime: '08:30',
          from: 'Colombo Fort',
          duration: '9h 25m',
          arriveTime: '17:55',
          to: 'Ella',
          classes: const ['1st Observation', '2nd', '3rd'],
          onTap: open,
        ),
        TrainCard(
          trainName: 'Night Mail',
          trainMeta: '#1045 · Mail',
          tag: const TrainTag('Overnight', tone: StatusTone.blue),
          departTime: '20:00',
          from: 'Colombo Fort',
          duration: '10h 40m',
          arriveTime: '06:40',
          to: 'Ella',
          classes: const ['1st Sleeper', '2nd', '3rd'],
          onTap: open,
        ),
      ],
    );
  }
}
