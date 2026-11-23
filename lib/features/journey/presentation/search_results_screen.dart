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
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Classes for every train in the current results (for labels and filters).
final _resultClassesProvider = FutureProvider<Map<String, List<TrainClass>>>((
  ref,
) async {
  final results = await ref.watch(journeyResultsProvider.future);
  final repo = ref.watch(repositoryProvider);
  final entries = await Future.wait(
    results.map(
      (r) async => MapEntry(r.trainId, await repo.trainClasses(r.trainId)),
    ),
  );
  return Map.fromEntries(entries);
});

/// Results for a From → To search with sort pills.
class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final sort = ref.watch(uiSelectionProvider(UiSelections.resultsSort));
    final slot = ref.watch(uiSelectionProvider(UiSelections.departureSlot));
    final travelClass = ref.watch(
      uiSelectionProvider(UiSelections.travelClass),
    );
    final journey = ref.watch(journeyProvider);
    final from = ref.watch(stationByCodeProvider(journey.fromCode)).value;
    final to = ref.watch(stationByCodeProvider(journey.toCode)).value;
    final results = ref.watch(journeyResultsProvider);
    final classes = ref.watch(_resultClassesProvider).value ?? const {};
    final date = DateLabels.weekdayDayMonth(journey.date, locale);
    final fromName = from?.name.of(context) ?? journey.fromCode;
    final toName = to?.name.of(context) ?? journey.toCode;

    bool hasClass(JourneyOption o, bool Function(String) test) =>
        (classes[o.trainId] ?? const <TrainClass>[]).any((c) => test(c.name));

    List<JourneyOption> shape(List<JourneyOption> all) {
      bool slotOk(JourneyOption o) {
        final m = o.departMinutes;
        return switch (slot) {
          1 => m < 12 * 60,
          2 => m >= 12 * 60 && m < 18 * 60,
          3 => m >= 18 * 60,
          _ => true,
        };
      }

      bool classOk(JourneyOption o) => switch (travelClass) {
        1 => hasClass(
          o,
          (n) => n.startsWith('1st') || n.startsWith('Observation'),
        ),
        2 => hasClass(o, (n) => n.startsWith('2nd')),
        3 => hasClass(o, (n) => n.startsWith('3rd')),
        _ => true,
      };

      int byTime(JourneyOption a, JourneyOption b) =>
          a.departMinutes.compareTo(b.departMinutes);
      int rank(bool first) => first ? 0 : 1;

      final list = all.where((o) => slotOk(o) && classOk(o)).toList();
      list.sort(switch (sort) {
        1 => (a, b) => a.durationMinutes.compareTo(b.durationMinutes),
        2 => (a, b) {
          final d =
              rank(a.trainType != 'Train') - rank(b.trainType != 'Train');
          return d != 0 ? d : byTime(a, b);
        },
        3 => (a, b) {
          final d =
              rank(hasClass(a, (n) => n.startsWith('Observation'))) -
              rank(hasClass(b, (n) => n.startsWith('Observation')));
          return d != 0 ? d : byTime(a, b);
        },
        _ => byTime,
      });
      // Trains that don't run on the chosen day go last (stable sort).
      final running = list.where((o) => o.runsOnDate(journey.date));
      final notRunning = list.where((o) => !o.runsOnDate(journey.date));
      return [...running, ...notRunning];
    }

    final shaped = results.whenData(shape);
    final runningCount =
        shaped.value?.where((o) => o.runsOnDate(journey.date)).length ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.fromTo(fromName, toName),
              subtitle: l10n.dateAndCount(date, l10n.trainsCount(runningCount)),
              trailing: CircleIconButton(
                icon: Icons.tune_rounded,
                semanticLabel: l10n.filters,
                onPressed: () => context.push(AppRoutes.journeySearch),
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
              child: AsyncView<List<JourneyOption>>(
                value: shaped,
                state: viewState,
                isEmpty: (r) => r.isEmpty,
                onRetry: () => ref.invalidate(journeyResultsProvider),
                content: (_, r) => _ResultsContent(
                  options: r,
                  fromName: fromName,
                  toName: toName,
                  date: journey.date,
                  classes: classes,
                ),
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
  const _ResultsContent({
    required this.options,
    required this.fromName,
    required this.toName,
    required this.date,
    required this.classes,
  });

  final List<JourneyOption> options;
  final String fromName;
  final String toName;
  final DateTime date;
  final Map<String, List<TrainClass>> classes;

  static String _short(String c) => c
      .replaceAll(' reserved', ' res.')
      .replaceAll(' unreserved', '')
      .replaceAll(' class', '');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final firstRunning = options.indexWhere((o) => o.runsOnDate(date));
    return PageScroll(
      spacing: AppSpacing.md,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s10,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        for (var i = 0; i < options.length; i++)
          _card(context, options[i], highlighted: i == firstRunning),
        Text(
          l10n.timetableSourceNote('seat61.com'),
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _card(BuildContext context, JourneyOption o, {required bool highlighted}) {
    final l10n = context.l10n;
    final running = o.runsOnDate(date);
    final cls = classes[o.trainId] ?? const <TrainClass>[];
    return TrainCard(
      highlighted: highlighted,
      dimmed: !running,
      trainName: o.trainName.of(context),
      trainMeta: '#${o.trainNumber} · ${o.trainType}',
      tag: switch (o.trainType) {
        'Night Mail' => TrainTag(o.trainType, tone: StatusTone.blue),
        'Express' => TrainTag(o.trainType, tone: StatusTone.lime),
        _ => null,
      },
      departTime: o.departTime,
      from: fromName,
      duration: formatDuration(o.durationMinutes),
      arriveTime: o.arriveTime,
      arriveNote: o.arriveDay > o.departDay ? l10n.nextDayShort : null,
      to: toName,
      stopsLabel: l10n.stopsCount(o.stopsBetween),
      classes: {for (final c in cls) _short(c.name)}.toList(),
      footer: running ? l10n.runsOn(o.runsOn) : l10n.notRunningOnDate,
      onTap: () =>
          context.push(AppRoutes.withId(AppRoutes.trainDetails, o.trainId)),
    );
  }
}
