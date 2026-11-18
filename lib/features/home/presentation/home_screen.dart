import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_labels.dart';
import '../../../core/widgets/alert_banner.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/train_card.dart';
import '../../../core/widgets/ui_state_view.dart';
import 'widgets/journey_hero_card.dart';
import 'widgets/quick_actions.dart';

/// Home tab: greeting, journey planner card, alert, shortcuts, departures.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.viewState});

  /// Forces the departures list state (previews/tests).
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = DateLabels.dayMonth(DateTime.now(), locale);
    // Design preview content — replace with the user's real journey/alerts.
    const from = 'Colombo Fort';
    const to = 'Ella';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: PageScroll(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.navClearance,
          ),
          children: [
            const _Header(userName: 'Malinga', initials: 'MB'),
            Semantics(
              header: true,
              child: Text(
                l10n.homeTitle,
                style: AppTextStyles.h2.copyWith(
                  color: context.palette.textPrimary,
                ),
              ),
            ),
            JourneyHeroCard(
              from: from,
              to: to,
              dateLabel: '${l10n.today}, $today',
              onFromTap: () => context.push(AppRoutes.departureStation),
              onToTap: () => context.push(AppRoutes.arrivalStation),
              onDateTap: () => context.push(AppRoutes.journeySearch),
              onFindTrains: () => context.push(AppRoutes.searchResults),
            ),
            AlertBanner(
              lead: 'Main Line',
              message: 'weekend track work between Nanu Oya and Ohiya',
              badgeLabel: l10n.verified,
              onTap: () => context.push(AppRoutes.announcementDetails),
            ),
            const QuickActions(),
            SectionHeader(
              title: l10n.departingFrom(from),
              actionLabel: l10n.seeAll,
              onAction: () => context.go(AppRoutes.trains),
            ),
            UiStateView(
              state: viewState,
              content: (_) => const _DeparturesContent(),
              empty: (_) => const _DeparturesEmpty(),
              loading: (_) => const _DeparturesLoading(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.userName, required this.initials});

  final String userName;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Row(
      children: [
        const AppLogoMark(size: 40),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.greeting,
                style: AppTextStyles.caption.copyWith(color: palette.textMuted),
              ),
              Text(
                userName,
                style: AppTextStyles.brand.copyWith(color: palette.textPrimary),
              ),
            ],
          ),
        ),
        CircleIconButton(
          icon: Icons.notifications_none_rounded,
          semanticLabel: l10n.announcements,
          onPressed: () => context.push(AppRoutes.announcements),
        ),
        const SizedBox(width: AppSpacing.sm),
        CircleIconButton(
          icon: Icons.person_rounded,
          tone: CircleIconTone.primary,
          semanticLabel: l10n.profile,
          onPressed: () => context.go(AppRoutes.profile),
          child: Text(
            initials,
            style: AppTextStyles.bodyStrong.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeparturesContent extends StatelessWidget {
  const _DeparturesContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void open() => context.push(AppRoutes.trainDetails);
    // Design preview content.
    return Column(
      children: [
        TrainDepartureTile(
          time: '05:55',
          platform: l10n.platformShort('6'),
          trainName: 'Podi Menike',
          subtitle: '#1005 · to Badulla',
          tag: TrainTag(l10n.scenic, tone: StatusTone.lime),
          onTap: open,
        ),
        const SizedBox(height: AppSpacing.s10),
        TrainDepartureTile(
          time: '08:30',
          platform: l10n.platformShort('5'),
          trainName: 'Udarata Menike',
          subtitle: '#1015 · to Badulla',
          tag: const TrainTag('Obs.'),
          onTap: open,
        ),
      ],
    );
  }
}

class _DeparturesEmpty extends StatelessWidget {
  const _DeparturesEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyState(
      icon: Icons.train_outlined,
      title: l10n.emptyTrainsTitle,
      message: l10n.emptyTrainsBody,
    );
  }
}

class _DeparturesLoading extends StatelessWidget {
  const _DeparturesLoading();

  @override
  Widget build(BuildContext context) {
    return const ShimmerList(itemCount: 2, padding: EdgeInsets.zero);
  }
}
