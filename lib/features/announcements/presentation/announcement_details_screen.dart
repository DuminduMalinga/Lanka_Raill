import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';
import 'announcements_screen.dart';

/// Full notice: kind, title, date, body, actions.
class AnnouncementDetailsScreen extends ConsumerWidget {
  const AnnouncementDetailsScreen({
    super.key,
    this.announcementId,
    this.viewState,
  });

  final String? announcementId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(announcementIdProvider(announcementId));
    final all = ref.watch(announcementsProvider);
    final item = resolved<Announcement>(
      ref,
      id,
      (v) => all.whenData((list) {
        for (final a in list) {
          if (a.id == v) return a;
        }
        return null;
      }),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.announcement),
            Expanded(
              child: AsyncView<Announcement?>(
                value: item,
                state: viewState,
                isEmpty: (a) => a == null,
                onRetry: () => ref.invalidate(announcementsProvider),
                content: (_, a) => _DetailsContent(item: a!),
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
  const _DetailsContent({required this.item});

  final Announcement item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final (tagLabel, tagTone) = announcementTag(context, kindOf(item));
    return PageScroll(
      children: [
        Wrap(
          spacing: AppSpacing.s6,
          children: [StatusChip(label: tagLabel, tone: tagTone)],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                item.title.of(context),
                style: AppTextStyles.h4.copyWith(color: palette.textPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              DateLabels.dayMonth(item.startsAt, locale),
              style: AppTextStyles.caption.copyWith(color: palette.textMuted),
            ),
          ],
        ),
        if (item.endsAt != null)
          _FactsTable(
            rows: [
              (
                l10n.detailDates,
                '${DateLabels.dayMonth(item.startsAt, locale)} – ${DateLabels.dayMonth(item.endsAt!, locale)}',
              ),
            ],
          ),
        Text(
          item.body.of(context),
          style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary),
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
                label: l10n.searchTrains,
                tone: PrimaryButtonTone.dark,
                onPressed: () => context.push(AppRoutes.journeySearch),
              ),
            ),
          ],
        ),
      ],
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
