import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Train overview: hero, times, stats, links.
class TrainDetailsScreen extends ConsumerWidget {
  const TrainDetailsScreen({super.key, this.trainId, this.viewState});

  final String? trainId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(trainIdProvider(trainId));
    final train = resolved(ref, id, (v) => ref.watch(trainProvider(v)));
    final t = train.value;
    final saved =
        t != null &&
        (ref.watch(favoritesProvider(FavoriteKind.train)).value?.contains(t.id) ??
            false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoHeader(
              imageAsset: t?.photoUrl == null ? AppAssets.nineArchBridge : null,
              imageUrl: t?.photoUrl,
              semanticLabel: t?.name.of(context) ?? l10n.welcomeImageAlt,
              title: t?.name.of(context) ?? '',
              subtitle: t == null
                  ? null
                  : '${l10n.trainNumber(t.number)} · ${t.runsOn}',
              tags: [
                if (t != null)
                  StatusChip(
                    label: t.type,
                    tone: t.type == 'Night Mail'
                        ? StatusTone.blue
                        : StatusTone.lime,
                  ),
              ],
              actions: [
                HeaderAction(
                  icon: saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: l10n.saveTrain,
                  onPressed: t == null
                      ? null
                      : () => toggleFavorite(
                          context,
                          ref,
                          FavoriteKind.train,
                          t.id,
                        ),
                ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: AsyncView<TrainSummary?>(
                  value: train,
                  state: viewState,
                  isEmpty: (v) => v == null,
                  onRetry: () => ref.invalidate(trainsProvider),
                  content: (_, v) => _TrainContent(train: v!),
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

class _TrainContent extends ConsumerWidget {
  const _TrainContent({required this.train});

  final TrainSummary train;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final t = train;
    final classes = ref.watch(trainClassesProvider(t.id)).value ?? const [];
    final stops = ref.watch(trainStopsProvider(t.id)).value ?? const [];
    String link(String route) => AppRoutes.withId(route, t.id);
    final classSummary = classes.isEmpty
        ? l10n.classesNotListed
        : classes.map((c) => c.name).join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TimesStrip(
          departTime: t.departTime,
          from: t.originName.of(context),
          arriveTime: t.arriveDay > 0
              ? '${t.arriveTime} (${l10n.nextDayShort})'
              : t.arriveTime,
          to: t.destinationName.of(context),
        ),
        const SizedBox(height: AppSpacing.md),
        EqualRow(
          children: [
            StatTile(
              value: formatDuration(t.durationMinutes),
              label: l10n.duration,
            ),
            StatTile(value: '${t.stopCount}', label: l10n.majorStops),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        EqualRow(
          children: [
            StatTile(value: t.runsOn, label: l10n.runsOn('').trim()),
            StatTile(
              value: '${classes.map((c) => c.name.split(' ').first).toSet().length}',
              label: l10n.classes,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SettingsSection(
          children: [
            SettingsTile(
              icon: Icons.timeline_rounded,
              title: l10n.stopTimeline,
              subtitle: l10n.stopTimelineSub,
              onTap: () => context.push(link(AppRoutes.stopTimeline)),
            ),
            SettingsTile(
              icon: Icons.map_outlined,
              title: l10n.routeMap,
              subtitle: stops.isEmpty
                  ? null
                  : stops.map((s) => s.station.name.of(context)).join(' · '),
              onTap: () => context.push(link(AppRoutes.routeMap)),
            ),
            SettingsTile(
              icon: Icons.event_seat_outlined,
              title: l10n.classesFacilities,
              subtitle: classSummary,
              onTap: () => context.push(link(AppRoutes.classesFacilities)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (t.photoCredit != null) ...[
          PhotoCredit(t.photoCredit),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          l10n.timetableSourceNote(t.source ?? 'seat61.com'),
          style: AppTextStyles.caption.copyWith(color: context.palette.textMuted),
        ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.majorStops),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final s in stops)
              StatusChip(label: '${s.displayTime} ${s.station.name.of(context)}'),
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
                FittedBox(child: Text(departTime, style: time)),
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
                FittedBox(child: Text(arriveTime, style: time)),
                Text(to, style: place, textAlign: TextAlign.end),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
