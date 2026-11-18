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
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Station page: facilities, next departures, nearby places.
class StationDetailsScreen extends StatelessWidget {
  const StationDetailsScreen({super.key, this.viewState});

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
              title: 'Ella  ඇල්ල',
              subtitle: 'Main Line · Badulla District · ≈1,040 m',
              bottom: const _CodeBadge(code: 'ELL'),
              actions: [
                HeaderAction(
                  icon: Icons.bookmark_border_rounded,
                  label: l10n.saveStation,
                ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _StationContent(),
                  empty: (_) => EmptyState(
                    icon: Icons.location_city_outlined,
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

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        code,
        style: AppTextStyles.tag.copyWith(
          fontSize: 12,
          letterSpacing: 0.8,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _StationContent extends StatelessWidget {
  const _StationContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void place() => context.push(AppRoutes.destinationDetails);
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(
              label: 'Ticket counter',
              tone: StatusTone.neutral,
              icon: Icons.confirmation_number_outlined,
            ),
            StatusChip(
              label: 'Waiting room',
              tone: StatusTone.neutral,
              icon: Icons.chair_outlined,
            ),
            StatusChip(
              label: 'Toilets',
              tone: StatusTone.neutral,
              icon: Icons.wc_outlined,
            ),
            StatusChip(
              label: 'Tuk-tuk stand',
              tone: StatusTone.neutral,
              icon: Icons.local_taxi_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.nextDepartures),
        EqualRow(
          children: [
            _DepartureBox(
              direction: l10n.toStation('Badulla'),
              time: '15:15',
              train: 'Podi Menike',
            ),
            _DepartureBox(
              direction: l10n.toStation('Colombo Fort'),
              time: '06:45',
              train: 'Udarata Menike',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.nearbyPlaces),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.landscape_outlined,
              title: 'Nine Arch Bridge',
              value: '≈2.5 km',
              onTap: place,
            ),
            SettingsTile(
              icon: Icons.terrain_outlined,
              title: 'Little Adam’s Peak',
              value: '≈4 km',
              onTap: place,
            ),
            SettingsTile(
              icon: Icons.water_outlined,
              title: 'Ravana Falls',
              value: '≈6 km',
              onTap: place,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: l10n.timetable,
                icon: Icons.schedule_rounded,
                tone: PrimaryButtonTone.dark,
                onPressed: () => context.go(AppRoutes.trains),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: SecondaryButton(
                label: l10n.directions,
                icon: Icons.directions_outlined,
                onPressed: () => context.push(AppRoutes.nearbyStations),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DepartureBox extends StatelessWidget {
  const _DepartureBox({
    required this.direction,
    required this.time,
    required this.train,
  });

  final String direction;
  final String time;
  final String train;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            direction,
            style: AppTextStyles.caption.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            time,
            style: AppTextStyles.timeLarge.copyWith(color: palette.textPrimary),
          ),
          Text(
            train,
            style: AppTextStyles.captionStrong.copyWith(color: palette.primary),
          ),
        ],
      ),
    );
  }
}
