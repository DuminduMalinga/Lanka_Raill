import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/station_tile.dart';
import '../../../core/widgets/ui_state_view.dart';

enum StationPickerKind { departure, arrival }

/// Departure / arrival station picker (one widget, two routes).
class StationPickerScreen extends ConsumerWidget {
  const StationPickerScreen({super.key, required this.kind, this.viewState});

  final StationPickerKind kind;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final title = kind == StationPickerKind.departure
        ? l10n.departureStation
        : l10n.arrivalStation;
    final popularId = '${UiSelections.popularStation}.${kind.name}';
    final popular = ref.watch(uiSelectionProvider(popularId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: title),
            Expanded(
              child: PageScroll(
                spacing: AppSpacing.md,
                children: [
                  AppSearchBar(hint: l10n.searchStationsHint),
                  _UseLocationRow(
                    title: l10n.useMyLocation,
                    subtitle: l10n.nearestStation('Colombo Fort', '0.8 km'),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SectionLabel(l10n.popular),
                  // Design preview content.
                  ChoicePillRow(
                    wrap: true,
                    padding: EdgeInsets.zero,
                    labels: const [
                      'Colombo Fort',
                      'Kandy',
                      'Galle',
                      'Nanu Oya',
                    ],
                    selectedIndex: popular,
                    onSelected: (i) => ref
                        .read(uiSelectionProvider(popularId).notifier)
                        .select(i),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SectionLabel(l10n.allStations),
                  UiStateView(
                    state: viewState,
                    content: (_) => _StationsContent(kind: kind),
                    empty: (_) => EmptyState(
                      icon: Icons.search_off_rounded,
                      title: l10n.emptyStationsTitle,
                      message: l10n.emptyStationsBody,
                    ),
                    loading: (_) => const ShimmerList(
                      itemCount: 5,
                      itemHeight: 64,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            _ConfirmBar(
              label: l10n.confirmStation,
              onPressed: () => popOrGo(context, AppRoutes.home)(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationsContent extends ConsumerWidget {
  const _StationsContent({required this.kind});

  final StationPickerKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = '${UiSelections.stationPick}.${kind.name}';
    final selected = ref.watch(uiSelectionProvider(id));
    void pick(int i) => ref.read(uiSelectionProvider(id).notifier).select(i);
    // Design preview content — pass real stations through StationTile.
    const stations = <(String, String, String)>[
      ('FOT', 'Colombo Fort', 'Main · Coastal · Northern · Puttalam'),
      ('MDA', 'Maradana', 'Main · Kelani Valley'),
      ('KDT', 'Kandy', 'Main Line branch · Matale Line'),
      ('PDA', 'Peradeniya Junction', 'Main Line'),
      ('GLE', 'Galle', 'Coastal Line'),
      ('NOA', 'Nanu Oya', 'Main Line · for Nuwara Eliya'),
    ];
    return Column(
      children: [
        for (var i = 0; i < stations.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          StationTile(
            code: stations[i].$1,
            name: stations[i].$2,
            subtitle: stations[i].$3,
            selected: i == selected,
            onTap: () => pick(i),
          ),
        ],
      ],
    );
  }
}

class _UseLocationRow extends StatelessWidget {
  const _UseLocationRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: () {},
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Row(
        children: [
          const IconTile(icon: Icons.my_location_rounded, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.md,
          AppSpacing.gutter,
          AppSpacing.md,
        ),
        child: MaxWidth(
          child: PrimaryButton(
            label: label,
            onPressed: onPressed,
            tone: PrimaryButtonTone.dark,
          ),
        ),
      ),
    );
  }
}
