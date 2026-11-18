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
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Train overview: hero, times, stats, links, scenic highlights.
class TrainDetailsScreen extends StatelessWidget {
  const TrainDetailsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Design preview content — train identity comes from data.
            PhotoHeader(
              imageAsset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              title: 'Podi Menike',
              subtitle: 'Train #1005 · Daily',
              tags: const [
                StatusChip(label: 'Express', tone: StatusTone.lime),
                StatusChip(label: 'Main Line', tone: StatusTone.glass),
              ],
              actions: [
                HeaderAction(icon: Icons.ios_share_rounded, label: l10n.share),
                HeaderAction(
                  icon: Icons.bookmark_border_rounded,
                  label: l10n.saveTrain,
                ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _TrainContent(),
                  empty: (_) => EmptyState(
                    icon: Icons.info_outline_rounded,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                  loading: (_) => const ShimmerList(
                    itemCount: 4,
                    itemHeight: 88,
                    padding: EdgeInsets.zero,
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

class _TrainContent extends StatelessWidget {
  const _TrainContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TimesStrip(
          departTime: '05:55',
          from: 'Colombo Fort',
          arriveTime: '16:20',
          to: 'Badulla',
        ),
        const SizedBox(height: AppSpacing.md),
        EqualRow(
          children: [
            StatTile(value: '10h 25m', label: l10n.duration),
            StatTile(value: '≈290 km', label: l10n.distance),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        EqualRow(
          children: [
            StatTile(value: '10', label: l10n.majorStops),
            StatTile(value: '3', label: l10n.classes),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.timeline_rounded,
              title: l10n.stopTimeline,
              subtitle: l10n.stopTimelineSub,
              onTap: () => context.push(AppRoutes.stopTimeline),
            ),
            SettingsTile(
              icon: Icons.map_outlined,
              title: l10n.routeMap,
              subtitle: 'Colombo Fort to Badulla, through the hill country',
              onTap: () => context.push(AppRoutes.routeMap),
            ),
            SettingsTile(
              icon: Icons.event_seat_outlined,
              title: l10n.classesFacilities,
              subtitle: '2nd reserved, 3rd, buffet coach',
              onTap: () => context.push(AppRoutes.classesFacilities),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.scenicHighlights),
        const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(label: 'Kadugannawa pass'),
            StatusChip(label: 'Tea estates near Hatton'),
            StatusChip(label: 'Pattipola summit'),
            StatusChip(label: 'Nine Arch Bridge'),
          ],
        ),
      ],
    );
  }
}

/// Departure → arrival summary card with a train glyph between.
class TimesStrip extends StatelessWidget {
  const TimesStrip({
    super.key,
    required this.departTime,
    required this.from,
    required this.arriveTime,
    required this.to,
  });

  final String departTime;
  final String from;
  final String arriveTime;
  final String to;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final time = AppTextStyles.timeLarge.copyWith(color: palette.textPrimary);
    final place = AppTextStyles.caption.copyWith(color: palette.textMuted);
    return AppCard(
      radius: AppRadii.cardLg,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(departTime, style: time),
                Text(from, style: place),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.train_rounded,
              size: AppSizes.icon,
              color: AppColors.ink,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(arriveTime, style: time),
                Text(to, style: place),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
