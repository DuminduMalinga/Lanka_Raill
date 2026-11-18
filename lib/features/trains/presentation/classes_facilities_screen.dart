import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Availability of a facility on board.
enum FacilityLevel { yes, limited, no }

/// Travel classes on a train and the facilities on board.
class ClassesFacilitiesScreen extends StatelessWidget {
  const ClassesFacilitiesScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.classesFacilities,
              subtitle: 'Podi Menike · #1005',
            ),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _ClassesContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.event_seat_outlined,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 3, itemHeight: 140),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassesContent extends StatelessWidget {
  const _ClassesContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        const ClassCard(
          title: '1st Class · Observation Saloon',
          available: false,
          description: 'Rear-facing panoramic windows. Reserved seats only — book early for the hill country.',
          tags: ['Reserved', 'Panoramic'],
          fare: 'LKR [FARE]',
        ),
        const ClassCard(
          title: '2nd Class · Reserved',
          available: true,
          description: 'Padded seats with fans and opening windows. The favourite for photos of the hills.',
          tags: ['Reserved', 'Fan', 'Window'],
          fare: 'LKR [FARE]',
        ),
        const ClassCard(
          title: '3rd Class',
          available: true,
          description:
              'Unreserved bench seating. Busy on weekends and holidays.',
          tags: ['Unreserved', 'Fan'],
          fare: 'LKR [FARE]',
        ),
        const SizedBox(height: AppSpacing.xs),
        SectionLabel(l10n.facilitiesOnBoard),
        _FacilitiesGrid(
          items: [
            (Icons.restaurant_outlined, l10n.facilityFood, FacilityLevel.yes),
            (Icons.wc_outlined, l10n.facilityToilets, FacilityLevel.yes),
            (Icons.luggage_outlined, l10n.facilityLuggage, FacilityLevel.yes),
            (
              Icons.power_outlined,
              l10n.facilityCharging,
              FacilityLevel.limited,
            ),
            (
              Icons.accessible_rounded,
              l10n.facilityStepFree,
              FacilityLevel.limited,
            ),
            (Icons.ac_unit_rounded, l10n.facilityAirCon, FacilityLevel.no),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: l10n.findTrainsWithClasses,
          tone: PrimaryButtonTone.dark,
          onPressed: () => context.go(AppRoutes.trains),
        ),
      ],
    );
  }
}

/// Travel class summary card.
class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.title,
    required this.available,
    required this.description,
    this.tags = const [],
    this.fare,
  });

  final String title;
  final bool available;
  final String description;
  final List<String> tags;
  final String? fare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Opacity(
      opacity: available ? 1 : 0.72,
      child: AppCard(
        radius: AppRadii.cardLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: StatusChip(
                    label: available ? l10n.onThisTrain : l10n.notOnThisTrain,
                    tone: available ? StatusTone.mint : StatusTone.neutral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(color: palette.textMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.s6,
                    runSpacing: AppSpacing.s6,
                    children: [
                      for (final t in tags)
                        StatusChip(label: t, tone: StatusTone.neutral),
                    ],
                  ),
                ),
                if (fare != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      fare!,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilitiesGrid extends StatelessWidget {
  const _FacilitiesGrid({required this.items});

  final List<(IconData, String, FacilityLevel)> items;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        EqualRow(
          children: [
            _FacilityTile(item: items[i]),
            if (i + 1 < items.length)
              _FacilityTile(item: items[i + 1])
            else
              const SizedBox.shrink(),
          ],
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          rows[i],
        ],
      ],
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({required this.item});

  final (IconData, String, FacilityLevel) item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final (icon, label, level) = item;
    final (String value, Color color) = switch (level) {
      FacilityLevel.yes => (l10n.yes, palette.primary),
      FacilityLevel.limited => (l10n.limited, AppColors.amberChipFg),
      FacilityLevel.no => (l10n.no, palette.textMuted),
    };
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconTile(icon: icon, size: 34),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.captionStrong.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
