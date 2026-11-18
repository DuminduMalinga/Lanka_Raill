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
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Overview of every railway line.
class RailwayLinesScreen extends StatelessWidget {
  const RailwayLinesScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.railwayLines),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _LinesContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.route_outlined,
                    title: l10n.emptyLinesTitle,
                    message: l10n.emptyLinesBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 5, itemHeight: 84),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinesContent extends StatelessWidget {
  const _LinesContent();

  @override
  Widget build(BuildContext context) {
    void open() => context.push(AppRoutes.lineDetails);
    // Design preview content.
    return PageScroll(
      spacing: AppSpacing.md,
      children: [
        LinesOverviewCard(
          title: '9 lines across the island',
          body: context.l10n.linesIntro,
          legend: const [
            ('Main', AppColors.lineMain),
            ('Coastal', AppColors.lineCoastal),
            ('Northern', AppColors.lineNorthern),
            ('Batticaloa', AppColors.lineBatticaloa),
            ('Trincomalee', AppColors.lineTrincomalee),
            ('Puttalam', AppColors.mutedOnDark),
          ],
        ),
        LineCard(
          name: 'Main Line',
          route: 'Colombo Fort → Badulla',
          highlights: 'Tea country, Ella, Nine Arch Bridge',
          color: AppColors.lineMain,
          onTap: open,
        ),
        LineCard(
          name: 'Coastal Line',
          route: 'Colombo Fort → Beliatta',
          highlights: 'Bentota, Hikkaduwa, Galle Fort',
          color: AppColors.lineCoastal,
          onTap: open,
        ),
        LineCard(
          name: 'Northern Line',
          route: 'Polgahawela → Kankesanthurai',
          highlights: 'Anuradhapura, Jaffna',
          color: AppColors.lineNorthern,
          onTap: open,
        ),
        LineCard(
          name: 'Batticaloa Line',
          route: 'Maho → Batticaloa',
          highlights: 'Polonnaruwa, east coast',
          color: AppColors.lineBatticaloa,
          onTap: open,
        ),
        LineCard(
          name: 'Trincomalee Line',
          route: 'Gal Oya → Trincomalee',
          highlights: 'Beaches, whale watching',
          color: AppColors.lineTrincomalee,
          onTap: open,
        ),
      ],
    );
  }
}

/// Dark summary card with a colour legend of the lines.
class LinesOverviewCard extends StatelessWidget {
  const LinesOverviewCard({
    super.key,
    required this.title,
    required this.body,
    required this.legend,
  });

  final String title;
  final String body;
  final List<(String, Color)> legend;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s18),
      decoration: BoxDecoration(
        color: palette.hero,
        borderRadius: AppRadii.heroAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconTile(
            icon: Icons.route_rounded,
            size: 44,
            background: AppColors.lime,
            foreground: AppColors.ink,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mutedOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (label, color) in legend)
                _LegendChip(label: label, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        color: AppColors.glass,
        borderRadius: AppRadii.tagAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.s6),
          Text(
            label,
            style: AppTextStyles.tag.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

/// Railway line row with its colour stripe.
class LineCard extends StatelessWidget {
  const LineCard({
    super.key,
    required this.name,
    required this.route,
    required this.highlights,
    required this.color,
    this.onTap,
  });

  final String name;
  final String route;
  final String highlights;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadii.pillAll,
            ),
          ),
          const SizedBox(width: AppSpacing.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  route,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  highlights,
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
