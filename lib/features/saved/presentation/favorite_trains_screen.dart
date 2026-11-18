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
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Saved trains and saved routes, with an alerts toggle.
class FavoriteTrainsScreen extends ConsumerWidget {
  const FavoriteTrainsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tab = ref.watch(uiSelectionProvider(UiSelections.favoriteTab));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.favoriteTrainsTitle),
            Padding(
              padding: AppSpacing.page,
              child: MaxWidth(
                child: SegmentedTabs(
                  // Counts are design preview content.
                  labels: [l10n.tabTrainsCount(3), l10n.tabRoutesCount(2)],
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
              child: UiStateView(
                state: viewState,
                content: (_) =>
                    tab == 0 ? const _TrainsTab() : const _RoutesTab(),
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

class _TrainsTab extends ConsumerWidget {
  const _TrainsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final alerts = ref.watch(uiToggleProvider(UiToggles.savedTrainAlerts));
    void open() => context.push(AppRoutes.trainDetails);
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        SavedTrainTile(
          trainName: 'Podi Menike #1005',
          route: 'Colombo Fort → Badulla',
          nextDepartureLabel: l10n.nextDeparture,
          nextDepartureTime: '05:55',
          onTap: open,
        ),
        SavedTrainTile(
          trainName: 'Ruhunu Kumari #8058',
          route: 'Maradana → Matara',
          nextDepartureLabel: l10n.nextDeparture,
          nextDepartureTime: '15:50',
          onTap: open,
        ),
        SavedTrainTile(
          trainName: 'Yal Devi #4001',
          route: 'Colombo Fort → Kankesanthurai',
          nextDepartureLabel: l10n.nextDeparture,
          nextDepartureTime: '05:45',
          onTap: open,
        ),
        const SizedBox(height: AppSpacing.xs),
        SettingsSection(
          children: [
            SettingsSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: l10n.alertsForSavedTrains,
              subtitle: l10n.savedAlertsBody,
              value: alerts,
              onChanged: (v) => ref
                  .read(uiToggleProvider(UiToggles.savedTrainAlerts).notifier)
                  .set(v),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoutesTab extends StatelessWidget {
  const _RoutesTab();

  @override
  Widget build(BuildContext context) {
    void open() => context.push(AppRoutes.searchResults);
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.s10,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        SavedRouteCard(
          from: 'Colombo Fort',
          to: 'Kandy',
          line: 'Main Line',
          note: 'Weekdays',
          onTap: open,
        ),
        SavedRouteCard(
          from: 'Kandy',
          to: 'Ella',
          line: 'Main Line',
          note: 'Scenic',
          noteTone: StatusTone.lime,
          onTap: open,
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
