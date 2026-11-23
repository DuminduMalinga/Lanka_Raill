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
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/station_tile.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Stations that have a tourist destination nearby.
final _touristStationIdsProvider = FutureProvider<Set<String>>((ref) async {
  final dests = await ref.watch(destinationsProvider(null).future);
  return {
    for (final d in dests)
      for (final n in d.nearestStations) n.station.id,
  };
});

/// A–Z station directory with search, line filters and a letter index.
class StationDirectoryScreen extends ConsumerStatefulWidget {
  const StationDirectoryScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  ConsumerState<StationDirectoryScreen> createState() =>
      _StationDirectoryScreenState();
}

class _StationDirectoryScreenState
    extends ConsumerState<StationDirectoryScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filter = ref.watch(uiSelectionProvider(UiSelections.stationFilter));
    final tourist = ref.watch(_touristStationIdsProvider).value ?? const {};
    final stations = ref.watch(stationsProvider).whenData((all) {
      final q = _query.toLowerCase();
      return all.where((s) {
        final line = s.lineName?.en ?? '';
        final lineOk = switch (filter) {
          1 => line == 'Main Line' || line == 'Matale Line',
          2 => line == 'Coastal Line',
          3 => line == 'Northern Line' || line == 'Mannar Line',
          4 => tourist.contains(s.id),
          _ => true,
        };
        final textOk =
            q.isEmpty ||
            s.name.en.toLowerCase().contains(q) ||
            (s.name.si ?? '').contains(_query) ||
            s.code.toLowerCase() == q;
        return lineOk && textOk;
      }).toList();
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.stationDirectory),
            Padding(
              padding: AppSpacing.page,
              child: MaxWidth(
                child: AppSearchBar(
                  hint: l10n.searchByNameOrCode,
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
              ),
            ),
            ChoicePillRow(
              labels: [
                l10n.filterAll,
                l10n.filterMain,
                l10n.filterCoastal,
                l10n.filterNorthern,
                l10n.filterTouristStops,
              ],
              selectedIndex: filter,
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.stationFilter).notifier,
                  )
                  .select(i),
            ),
            Expanded(
              child: AsyncView<List<Station>>(
                value: stations,
                state: widget.viewState,
                isEmpty: (s) => s.isEmpty,
                onRetry: () => ref.invalidate(stationsProvider),
                content: (_, s) =>
                    _DirectoryContent(stations: s, tourist: tourist),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.emptyStationsTitle,
                    message: _query.isEmpty
                        ? l10n.emptyStationsBody
                        : l10n.noStationsMatch,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(
                    itemCount: 6,
                    itemHeight: 64,
                    header: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectoryContent extends StatefulWidget {
  const _DirectoryContent({required this.stations, required this.tourist});

  final List<Station> stations;
  final Set<String> tourist;

  @override
  State<_DirectoryContent> createState() => _DirectoryContentState();
}

class _DirectoryContentState extends State<_DirectoryContent> {
  final Map<String, GlobalKey> _keys = {};

  @override
  Widget build(BuildContext context) {
    final byLetter = <String, List<Station>>{};
    for (final s in widget.stations) {
      byLetter.putIfAbsent(s.name.en[0].toUpperCase(), () => []).add(s);
    }
    final letters = byLetter.keys.toList()..sort();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageScroll(
            spacing: AppSpacing.sm,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.xxl,
            ),
            children: [
              for (final letter in letters) ...[
                SectionLabel(
                  letter,
                  key: _keys.putIfAbsent(letter, GlobalKey.new),
                ),
                for (final s in byLetter[letter]!)
                  StationTile(
                    code: s.code,
                    name: s.name.en,
                    nativeName: s.name.si,
                    subtitle: [
                      s.lineName?.of(context),
                      if (widget.tourist.contains(s.id))
                        context.l10n.touristStop,
                    ].whereType<String>().join(' · '),
                    showChevron: true,
                    onTap: () => context.push(
                      AppRoutes.withId(AppRoutes.stationDetails, s.id),
                    ),
                  ),
              ],
            ],
          ),
        ),
        _LetterIndex(
          letters: letters,
          onTap: (l) {
            final ctx = _keys[l]?.currentContext;
            if (ctx != null) {
              Scrollable.ensureVisible(
                ctx,
                duration: const Duration(milliseconds: 250),
              );
            }
          },
        ),
      ],
    );
  }
}

class _LetterIndex extends StatelessWidget {
  const _LetterIndex({required this.letters, required this.onTap});

  final List<String> letters;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs, top: AppSpacing.sm),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final letter in letters)
              Semantics(
                button: true,
                label: context.l10n.jumpToLetter(letter),
                excludeSemantics: true,
                child: InkWell(
                  onTap: () => onTap(letter),
                  borderRadius: AppRadii.cardAll,
                  child: SizedBox(
                    width: 24,
                    height: 22,
                    child: Center(
                      child: Text(
                        letter,
                        style: AppTextStyles.tag.copyWith(
                          color: palette.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
