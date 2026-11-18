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
import '../../../core/widgets/ui_state_view.dart';

/// A–Z station directory with search, line filters and a letter index.
class StationDirectoryScreen extends ConsumerWidget {
  const StationDirectoryScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(uiSelectionProvider(UiSelections.stationFilter));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.stationDirectory),
            Padding(
              padding: AppSpacing.page,
              child: MaxWidth(
                child: AppSearchBar(hint: l10n.searchByNameOrCode),
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
              child: UiStateView(
                state: viewState,
                content: (_) => const _DirectoryContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    title: l10n.emptyStationsTitle,
                    message: l10n.emptyStationsBody,
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

class _DirectoryContent extends StatelessWidget {
  const _DirectoryContent();

  static const List<String> _letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'G',
    'H',
    'J',
    'K',
    'M',
    'N',
    'P',
    'R',
    'T',
    'V', //
  ];

  @override
  Widget build(BuildContext context) {
    void open() => context.push(AppRoutes.stationDetails);
    // Design preview content.
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
              const SectionLabel('A'),
              StationTile(
                name: 'Aluthgama',
                nativeName: 'අළුත්ගම',
                subtitle: 'Coastal Line',
                showChevron: true,
                onTap: open,
              ),
              StationTile(
                name: 'Anuradhapura',
                nativeName: 'අනුරාධපුරය',
                subtitle: 'Northern Line',
                showChevron: true,
                onTap: open,
              ),
              const SectionLabel('B'),
              StationTile(
                name: 'Badulla',
                nativeName: 'බදුල්ල',
                subtitle: 'Main Line · terminus',
                showChevron: true,
                onTap: open,
              ),
              StationTile(
                name: 'Bandarawela',
                nativeName: 'බණ්ඩාරවෙල',
                subtitle: 'Main Line',
                showChevron: true,
                onTap: open,
              ),
              StationTile(
                name: 'Bentota',
                nativeName: 'බෙන්තොට',
                subtitle: 'Coastal Line',
                showChevron: true,
                onTap: open,
              ),
              const SectionLabel('C'),
              StationTile(
                name: 'Colombo Fort',
                nativeName: 'කොළඹ කොටුව',
                subtitle: 'All lines · central hub',
                showChevron: true,
                onTap: open,
              ),
              const SectionLabel('E'),
              StationTile(
                name: 'Ella',
                nativeName: 'ඇල්ල',
                subtitle: 'Main Line · tourist stop',
                showChevron: true,
                onTap: open,
              ),
            ],
          ),
        ),
        const _LetterIndex(letters: _letters),
      ],
    );
  }
}

class _LetterIndex extends StatelessWidget {
  const _LetterIndex({required this.letters});

  final List<String> letters;

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
                  onTap: () {},
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
