import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/station_tile.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

enum StationPickerKind { departure, arrival }

/// Departure / arrival station picker (one widget, two routes).
class StationPickerScreen extends ConsumerStatefulWidget {
  const StationPickerScreen({super.key, required this.kind, this.viewState});

  final StationPickerKind kind;
  final UiViewState? viewState;

  @override
  ConsumerState<StationPickerScreen> createState() =>
      _StationPickerScreenState();
}

class _StationPickerScreenState extends ConsumerState<StationPickerScreen> {
  static const _popularCodes = ['FOT', 'KDT', 'ELL', 'GLE', 'NOA', 'JFN'];

  String _query = '';
  String? _picked;

  bool get _departure => widget.kind == StationPickerKind.departure;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _departure ? l10n.departureStation : l10n.arrivalStation;
    final journey = ref.watch(journeyProvider);
    final current = _picked ?? (_departure ? journey.fromCode : journey.toCode);
    final stations = ref.watch(stationsProvider);
    final all = stations.value ?? const <Station>[];
    final popular = [
      for (final c in _popularCodes)
        ...all.where((s) => s.code == c),
    ];

    void confirm() {
      final n = ref.read(journeyProvider.notifier);
      _departure ? n.setFrom(current) : n.setTo(current);
      popOrGo(context, AppRoutes.home)();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: title),
            Expanded(
              child: PageScroll(
                spacing: AppSpacing.md,
                children: [
                  AppSearchBar(
                    hint: l10n.searchStationsHint,
                    onChanged: (v) => setState(() => _query = v.trim()),
                  ),
                  if (popular.isNotEmpty && _query.isEmpty) ...[
                    SectionLabel(l10n.popular),
                    ChoicePillRow(
                      wrap: true,
                      padding: EdgeInsets.zero,
                      labels: [for (final s in popular) s.name.of(context)],
                      selectedIndex: popular.indexWhere(
                        (s) => s.code == current,
                      ),
                      onSelected: (i) =>
                          setState(() => _picked = popular[i].code),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  SectionLabel(l10n.allStations),
                  AsyncView<List<Station>>(
                    value: stations,
                    state: widget.viewState,
                    onRetry: () => ref.invalidate(stationsProvider),
                    isEmpty: (list) => _filter(list).isEmpty,
                    content: (_, list) => _StationsContent(
                      stations: _filter(list),
                      selectedCode: current,
                      onPick: (code) => setState(() => _picked = code),
                    ),
                    empty: (_) => EmptyState(
                      icon: Icons.search_off_rounded,
                      title: l10n.emptyStationsTitle,
                      message: _query.isEmpty
                          ? l10n.emptyStationsBody
                          : l10n.noStationsMatch,
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
            _ConfirmBar(label: l10n.confirmStation, onPressed: confirm),
          ],
        ),
      ),
    );
  }

  List<Station> _filter(List<Station> list) {
    if (_query.isEmpty) return list;
    final q = _query.toLowerCase();
    return list
        .where(
          (s) =>
              s.name.en.toLowerCase().contains(q) ||
              (s.name.si ?? '').contains(_query) ||
              s.code.toLowerCase() == q,
        )
        .toList();
  }
}

class _StationsContent extends StatelessWidget {
  const _StationsContent({
    required this.stations,
    required this.selectedCode,
    required this.onPick,
  });

  final List<Station> stations;
  final String selectedCode;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < stations.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          StationTile(
            code: stations[i].code,
            name: stations[i].name.en,
            nativeName: stations[i].name.si,
            subtitle: [
              stations[i].lineName?.of(context),
              stations[i].district,
            ].whereType<String>().join(' · '),
            selected: stations[i].code == selectedCode,
            onTap: () => onPick(stations[i].code),
          ),
        ],
      ],
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
