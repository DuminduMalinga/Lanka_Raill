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
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/ui_state_view.dart';
import 'announcements_screen.dart';

/// Full notice: verification banner, facts table, body, actions.
class AnnouncementDetailsScreen extends StatelessWidget {
  const AnnouncementDetailsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.announcement,
              trailing: CircleIconButton(
                icon: Icons.ios_share_rounded,
                semanticLabel: l10n.share,
                onPressed: () {},
              ),
            ),
            Expanded(
              child: UiStateView(
                state: viewState,
                content: (_) => const _DetailsContent(),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 3, itemHeight: 120),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final (tagLabel, tagTone) = announcementTag(
      context,
      AnnouncementKind.scheduleChange,
    );
    // Design preview content.
    return PageScroll(
      children: [
        _VerifiedBanner(text: l10n.verifiedFromOfficial),
        Wrap(
          spacing: AppSpacing.s6,
          children: [
            StatusChip(label: tagLabel, tone: tagTone),
            const StatusChip(label: 'Main Line', tone: StatusTone.neutral),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Weekend track maintenance between Nanu Oya and Ohiya',
                style: AppTextStyles.h4.copyWith(color: palette.textPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              'Published 15 Nov 2026, 14:10 · Updated 15:02',
              style: AppTextStyles.caption.copyWith(color: palette.textMuted),
            ),
          ],
        ),
        _FactsTable(
          rows: [
            (l10n.detailDates, 'Sat 21 – Sun 22 Nov'),
            (l10n.detailSection, 'Nanu Oya → Ohiya'),
            (l10n.detailAffectedTrains, '1005, 1015, 1045'),
            (l10n.detailExpectedDelay, 'Up to 45 min'),
          ],
        ),
        Text(
          'Trains will run at reduced speed through the work zone. Passengers '
          'travelling to Ella and Badulla should allow extra time for '
          'connections. Reserved tickets remain valid.',
          style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: palette.primary,
              minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
              textStyle: AppTextStyles.chip,
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: AppSizes.iconSm),
            label: Text(l10n.viewOriginalNotice),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.savedTrains,
                onPressed: () => context.push(AppRoutes.favoriteTrains),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: PrimaryButton(
                label: l10n.notifyMe,
                icon: Icons.notifications_active_outlined,
                tone: PrimaryButtonTone.dark,
                onPressed: () => context.push(AppRoutes.notificationSettings),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerifiedBanner extends StatelessWidget {
  const _VerifiedBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.tint,
        borderRadius: AppRadii.cardAll,
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            size: AppSizes.icon,
            color: palette.onTint,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: palette.onTint,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactsTable extends StatelessWidget {
  const _FactsTable({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: palette.border),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
