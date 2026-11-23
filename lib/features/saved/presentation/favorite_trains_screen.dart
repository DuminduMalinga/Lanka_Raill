import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Saved trains and saved routes, with an alerts toggle.
class FavoriteTrainsScreen extends ConsumerWidget {
  const FavoriteTrainsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tab = ref.watch(uiSelectionProvider(UiSelections.favoriteTab));
    final saved = ref.watch(savedItemsProvider);
    final recent = ref.watch(recentSearchesProvider).value ?? const [];
    final trainCount = saved.value?.trains.length ?? 0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.favoriteTrainsTitle),
            Padding(
              padding: AppSpacing.page,
              child: MaxWidth(
                child: SegmentedTabs(
                  labels: [
                    l10n.tabTrainsCount(trainCount),
                    l10n.tabRoutesCount(recent.length),
                  ],
                  selectedIndex: tab,
                  onSelected: (i) => ref
                      .read(
                        uiSelectionProvider(UiSelections.favoriteTab).notifier,
                      )
                      .select(i),
                ),
              ),
            ),
            Expanded(
              child: AsyncView<SavedItems>(
                value: saved,
                state: viewState,
                isEmpty: (s) => tab == 0 ? s.trains.isEmpty : recent.isEmpty,
                onRetry: () => ref.invalidate(savedItemsProvider),
                content: (_, s) => tab == 0
                    ? _TrainsTab(trains: s.trains)
                    : _RoutesTab(routes: recent),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.bookmark_border_rounded,
                    title: l10n.emptySavedTitle,
                    message: l10n.emptySavedBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: ShimmerList(itemCount: 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainsTab extends StatelessWidget {
  const _TrainsTab({required this.trains});

  final List<TrainSummary> trains;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        for (final t in trains)
          SavedTrainTile(
            trainName: '${t.name.of(context)} #${t.number}',
            route: l10n.fromTo(
              t.originName.of(context),
              t.destinationName.of(context),
            ),
            nextDepartureLabel: l10n.nextDeparture,
            nextDepartureTime: t.departTime,
            onTap: () =>
                context.push(AppRoutes.withId(AppRoutes.trainDetails, t.id)),
          ),
      ],
    );
  }
}

class _RoutesTab extends ConsumerWidget {
  const _RoutesTab({required this.routes});

  final List<RecentSearch> routes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    Station? st(String code) => ref.watch(stationByCodeProvider(code)).value;
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        for (final r in routes)
          SavedRouteCard(
            from: st(r.fromCode)?.name.of(context) ?? r.fromCode,
            to: st(r.toCode)?.name.of(context) ?? r.toCode,
            line: st(r.toCode)?.lineName?.of(context) ?? '',
            note: DateLabels.dayMonth(r.at, locale),
            onTap: () {
              ref.read(journeyProvider.notifier).set(r.fromCode, r.toCode);
              context.push(AppRoutes.searchResults);
            },
          ),
      ],
    );
  }
}

/// Saved route: From → To with line + note tags.
class SavedRouteCard extends StatelessWidget {
  const SavedRouteCard({
    super.key,
    required this.from,
    required this.to,
    required this.line,
    required this.note,
    this.noteTone = StatusTone.neutral,
    this.onTap,
  });

  final String from;
  final String to;
  final String line;
  final String note;
  final StatusTone noteTone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = AppTextStyles.cardTitle.copyWith(color: palette.textPrimary);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trip_origin_rounded, size: 16, color: palette.primary),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: Text(from, style: style)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: palette.textMuted,
                ),
              ),
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: palette.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(child: Text(to, style: style)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.s6,
            children: [
              StatusChip(label: line),
              StatusChip(label: note, tone: noteTone),
            ],
          ),
        ],
      ),
    );
  }
}
