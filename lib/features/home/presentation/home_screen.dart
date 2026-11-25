import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/async_view.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

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
import 'widgets/journey_hero_card.dart';
import 'widgets/quick_actions.dart';

/// Home tab: greeting, journey planner card, alert, shortcuts, departures.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.viewState});

  /// Forces the departures list state (previews/tests).
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final journey = ref.watch(journeyProvider);
    final from = ref.watch(stationByCodeProvider(journey.fromCode)).value;
    final to = ref.watch(stationByCodeProvider(journey.toCode)).value;
    final profile = ref.watch(profileProvider).value;
    final announcements = ref.watch(announcementsProvider).value ?? const [];
    final alert = announcements.isEmpty ? null : announcements.first;
    final isToday = DateUtils.isSameDay(journey.date, DateTime.now());
    final dateText = DateLabels.dayMonth(journey.date, locale);
    final fromName = from?.name.of(context) ?? journey.fromCode;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(announcementsProvider);
            if (from != null) ref.invalidate(departuresProvider(from.id));
          },
          child: PageScroll(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.navClearance,
            ),
            children: [
              _Header(
                userName: profile?.label ?? l10n.guest,
                initials: profile?.initials ?? 'G',
                avatarUrl: profile?.avatarUrl,
              ),
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
                from: fromName,
                to: to?.name.of(context) ?? journey.toCode,
                dateLabel: isToday ? '${l10n.today}, $dateText' : dateText,
                onFromTap: () => context.push(AppRoutes.departureStation),
                onToTap: () => context.push(AppRoutes.arrivalStation),
                onSwap: () => ref.read(journeyProvider.notifier).swap(),
                onDateTap: () => context.push(AppRoutes.journeySearch),
                onFindTrains: () {
                  ref
                      .read(recentSearchesProvider.notifier)
                      .add(journey.fromCode, journey.toCode);
                  context.push(AppRoutes.searchResults);
                },
              ),
              if (alert != null)
                AlertBanner(
                  lead: alert.title.of(context),
                  message: _firstSentence(alert.body.of(context)),
                  onTap: () => context.push(
                    AppRoutes.withId(AppRoutes.announcementDetails, alert.id),
                  ),
                ),
              const QuickActions(),
              SectionHeader(
                title: l10n.departingFrom(fromName),
                actionLabel: l10n.seeAll,
                onAction: from == null
                    ? () => context.go(AppRoutes.trains)
                    : () => context.push(
                        AppRoutes.withId(AppRoutes.stationDetails, from.id),
                      ),
              ),
              _Departures(stationId: from?.id, viewState: viewState),
            ],
          ),
        ),
      ),
    );
  }

  static String _firstSentence(String text) {
    final i = text.indexOf('. ');
    final s = i > 0 ? text.substring(0, i + 1) : text;
    return s.length > 110 ? '${s.substring(0, 107)}…' : s;
  }
}

class _Departures extends ConsumerWidget {
  const _Departures({required this.stationId, this.viewState});

  final String? stationId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = stationId;
    final AsyncValue<List<StationDeparture>> value = id == null
        ? const AsyncLoading()
        : ref.watch(departuresProvider(id));
    return AsyncView<List<StationDeparture>>(
      value: value,
      state: viewState,
      isEmpty: (d) => d.isEmpty,
      onRetry: id == null ? null : () => ref.invalidate(departuresProvider(id)),
      content: (_, deps) => _DeparturesContent(departures: deps),
      empty: (_) => const _DeparturesEmpty(),
      loading: (_) => const _DeparturesLoading(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.userName,
    required this.initials,
    this.avatarUrl,
  });

  final String userName;
  final String initials;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final initialsText = Text(
      initials,
      style: AppTextStyles.bodyStrong.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
    );
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
          child: avatarUrl == null
              ? initialsText
              : Image.network(
                  avatarUrl!,
                  width: AppSizes.tapTarget,
                  height: AppSizes.tapTarget,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => initialsText,
                ),
        ),
      ],
    );
  }
}

class _DeparturesContent extends StatelessWidget {
  const _DeparturesContent({required this.departures});

  final List<StationDeparture> departures;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    int mins(String t) =>
        int.parse(t.substring(0, 2)) * 60 + int.parse(t.substring(3, 5));
    // Next three departures from now, wrapping to tomorrow's first trains.
    final today = DateTime.now().weekday;
    final tomorrow = today % 7 + 1;
    final upcoming = [
      ...departures.where(
        (d) => mins(d.time) >= nowMin && runsOnDay(d.train.runsOn, today),
      ),
      ...departures.where(
        (d) => mins(d.time) < nowMin && runsOnDay(d.train.runsOn, tomorrow),
      ),
    ].take(3).toList();
    return Column(
      children: [
        for (var i = 0; i < upcoming.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s10),
          TrainDepartureTile(
            time: upcoming[i].time,
            trainName: upcoming[i].train.name.of(context),
            subtitle:
                '#${upcoming[i].train.number} · ${l10n.toStation(upcoming[i].train.destinationName.of(context))}',
            tag: upcoming[i].train.type == 'Express'
                ? TrainTag(upcoming[i].train.type, tone: StatusTone.lime)
                : upcoming[i].train.type == 'Night Mail'
                ? TrainTag(upcoming[i].train.type, tone: StatusTone.blue)
                : null,
            onTap: () => context.push(
              AppRoutes.withId(AppRoutes.trainDetails, upcoming[i].train.id),
            ),
          ),
        ],
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
