import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';

/// A single railway line: stats, key stations, trains, places.
class LineDetailsScreen extends StatelessWidget {
  const LineDetailsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Design preview content.
            PhotoHeader(
              imageAsset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              height: 280,
              title: 'Main Line',
              subtitle: 'Colombo Fort → Badulla',
              tags: [StatusChip(label: l10n.mostScenic, tone: StatusTone.lime)],
              actions: [
                HeaderAction(
                  icon: Icons.bookmark_border_rounded,
                  label: l10n.saveLine,
                ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _LineContent(),
                  empty: (_) => EmptyState(
                    icon: Icons.route_outlined,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                  loading: (_) =>
                      const ShimmerList(itemCount: 4, padding: EdgeInsets.zero),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineContent extends StatelessWidget {
  const _LineContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void train() => context.push(AppRoutes.trainDetails);
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EqualRow(
          children: [
            StatTile(value: '≈290 km', label: l10n.lineLength),
            StatTile(value: '1,898 m', label: l10n.highestPoint),
            StatTile(value: '1864', label: l10n.firstSection),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: l10n.keyStations,
          actionLabel: l10n.allStations,
          onAction: () => context.push(AppRoutes.stationDirectory),
        ),
        const SizedBox(height: AppSpacing.sm),
        StationPath(
          stations: const [
            'Colombo Fort',
            'Peradeniya',
            'Hatton',
            'Nanu Oya',
            'Ella',
            'Badulla',
          ],
          onStationTap: (_) => context.push(AppRoutes.stationDetails),
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: l10n.trainsOnLine),
        const SizedBox(height: AppSpacing.sm),
        TrainDepartureTile(
          time: '05:55',
          trainName: 'Podi Menike',
          subtitle: '#1005 · to Badulla',
          showChevron: true,
          onTap: train,
        ),
        const SizedBox(height: AppSpacing.s10),
        TrainDepartureTile(
          time: '08:30',
          trainName: 'Udarata Menike',
          subtitle: '#1015 · to Badulla',
          showChevron: true,
          onTap: train,
        ),
        const SizedBox(height: AppSpacing.s10),
        TrainDepartureTile(
          time: '20:00',
          trainName: 'Night Mail',
          subtitle: '#1045 · to Badulla',
          showChevron: true,
          onTap: train,
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.placesAlongLine),
        const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(label: 'Nuwara Eliya'),
            StatusChip(label: 'Horton Plains'),
            StatusChip(label: 'Haputale'),
            StatusChip(label: 'Ella'),
          ],
        ),
      ],
    );
  }
}

/// Horizontal station path: dots joined by a rail with names below.
class StationPath extends StatelessWidget {
  const StationPath({super.key, required this.stations, this.onStationTap});

  final List<String> stations;
  final ValueChanged<int>? onStationTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < stations.length; i++)
              InkWell(
                onTap: onStationTap == null ? null : () => onStationTap!(i),
                borderRadius: AppRadii.cardAll,
                child: SizedBox(
                  width: 84,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == 0
                                    ? Colors.transparent
                                    : palette.primary.withValues(alpha: 0.35),
                              ),
                            ),
                            _PathDot(
                              endpoint: i == 0 || i == stations.length - 1,
                            ),
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == stations.length - 1
                                    ? Colors.transparent
                                    : palette.primary.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        stations[i],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.captionStrong.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PathDot extends StatelessWidget {
  const _PathDot({required this.endpoint});

  final bool endpoint;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: endpoint ? 18 : 12,
      height: endpoint ? 18 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: endpoint ? AppColors.lime : palette.surface,
        border: Border.all(
          color: endpoint ? palette.primary : palette.primary,
          width: endpoint ? 3 : 2,
        ),
      ),
    );
  }
}
