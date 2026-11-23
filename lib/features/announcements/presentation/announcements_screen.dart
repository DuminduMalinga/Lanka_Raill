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
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/choice_pills.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Kind of railway notice; drives the tag colour.
enum AnnouncementKind { scheduleChange, delay, service }

/// Verified railway notices with type filters.
class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(
      uiSelectionProvider(UiSelections.announcementFilter),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: l10n.announcements,
              trailing: CircleIconButton(
                icon: Icons.tune_rounded,
                semanticLabel: l10n.notificationSettings,
                onPressed: () => context.push(AppRoutes.notificationSettings),
              ),
            ),
            ChoicePillRow(
              labels: [
                l10n.filterAll,
                l10n.filterDelays,
                l10n.filterSchedule,
                l10n.filterService,
              ],
              selectedIndex: filter,
              onSelected: (i) => ref
                  .read(
                    uiSelectionProvider(UiSelections.announcementFilter)
                        .notifier,
                  )
                  .select(i),
            ),
            Expanded(
              child: AsyncView<List<Announcement>>(
                value: ref.watch(announcementsProvider).whenData(
                  (all) => all
                      .where(
                        (a) => switch (filter) {
                          1 => kindOf(a) == AnnouncementKind.delay,
                          2 => kindOf(a) == AnnouncementKind.scheduleChange,
                          3 => kindOf(a) == AnnouncementKind.service,
                          _ => true,
                        },
                      )
                      .toList(),
                ),
                state: viewState,
                isEmpty: (a) => a.isEmpty,
                onRetry: () => ref.invalidate(announcementsProvider),
                content: (_, a) => _AnnouncementsContent(items: a),
                empty: (_) => SingleChildScrollView(
                  child: EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.emptyAnnouncementsTitle,
                    message: l10n.emptyAnnouncementsBody,
                  ),
                ),
                loading: (_) => const SingleChildScrollView(
                  child: ShimmerList(itemCount: 4, itemHeight: 120),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Maps a notice's severity to the design's notice kinds.
AnnouncementKind kindOf(Announcement a) => switch (a.severity) {
  AnnouncementSeverity.critical => AnnouncementKind.delay,
  AnnouncementSeverity.warning => AnnouncementKind.scheduleChange,
  AnnouncementSeverity.info => AnnouncementKind.service,
};

class _AnnouncementsContent extends StatelessWidget {
  const _AnnouncementsContent({required this.items});

  final List<Announcement> items;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return PageScroll(
      spacing: AppSpacing.md,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.sm,
        AppSpacing.gutter,
        AppSpacing.xxl,
      ),
      children: [
        for (final a in items)
          AnnouncementCard(
            kind: kindOf(a),
            line: context.l10n.announcement,
            time: DateLabels.dayMonth(a.startsAt, locale),
            title: a.title.of(context),
            unread: a.severity != AnnouncementSeverity.info,
            onTap: () => context.push(
              AppRoutes.withId(AppRoutes.announcementDetails, a.id),
            ),
          ),
      ],
    );
  }
}

(String, StatusTone) announcementTag(BuildContext context, AnnouncementKind k) {
  final l10n = context.l10n;
  return switch (k) {
    AnnouncementKind.scheduleChange => (
      l10n.typeScheduleChange,
      StatusTone.amber,
    ),
    AnnouncementKind.delay => (l10n.typeDelay, StatusTone.red),
    AnnouncementKind.service => (l10n.typeService, StatusTone.blue),
  };
}

/// Notice card: type + line tags, time, title, verified source.
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.kind,
    required this.line,
    required this.time,
    required this.title,
    this.unread = false,
    this.onTap,
  });

  final AnnouncementKind kind;
  final String line;
  final String time;
  final String title;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final (tagLabel, tagTone) = announcementTag(context, kind);
    return AppCard(
      onTap: onTap,
      radius: AppRadii.cardLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.s6,
                  runSpacing: AppSpacing.s6,
                  children: [
                    StatusChip(label: tagLabel, tone: tagTone),
                    StatusChip(label: line, tone: StatusTone.neutral),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                time,
                style: AppTextStyles.caption.copyWith(color: palette.textMuted),
              ),
              if (unread) ...[
                const SizedBox(width: AppSpacing.s6),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s10),
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              color: palette.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          Row(
            children: [
              Icon(Icons.verified_rounded, size: 14, color: palette.primary),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  l10n.verifiedSource,
                  style: AppTextStyles.captionStrong.copyWith(
                    color: palette.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
