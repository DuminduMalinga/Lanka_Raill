import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/ui_view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Station page: facilities, next departures, nearby places.
class StationDetailsScreen extends ConsumerWidget {
  const StationDetailsScreen({super.key, this.stationId, this.viewState});

  final String? stationId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(stationIdProvider(stationId));
    final station = resolved(ref, id, (v) => ref.watch(stationProvider(v)));
    final s = station.value;
    final saved =
        s != null &&
        (ref
                .watch(favoritesProvider(FavoriteKind.station))
                .value
                ?.contains(s.id) ??
            false);
    final title = s == null
        ? ''
        : s.name.si == null
        ? s.name.en
        : '${s.name.en}  ${s.name.si}';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoHeader(
              imageAsset: s?.photoUrl == null ? AppAssets.nineArchBridge : null,
              imageUrl: s?.photoUrl,
              semanticLabel: s?.name.of(context) ?? l10n.welcomeImageAlt,
              height: 280,
              title: title,
              subtitle: s == null
                  ? null
                  : [
                      s.lineName?.of(context),
                      s.district,
                      if (s.elevationM != null) '≈${s.elevationM} m',
                    ].whereType<String>().join(' · '),
              bottom: s == null ? null : _CodeBadge(code: s.code),
              actions: [
                HeaderAction(
                  icon: saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: l10n.saveStation,
                  onPressed: s == null
                      ? null
                      : () => toggleFavorite(
                          context,
                          ref,
                          FavoriteKind.station,
                          s.id,
                        ),
                ),
              ],
            ),
            DetailBody(
              child: MaxWidth(
                child: AsyncView<Station?>(
                  value: station,
                  state: viewState,
                  isEmpty: (v) => v == null,
                  onRetry: () => ref.invalidate(stationsProvider),
                  content: (_, v) => _StationContent(station: v!),
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

class _StationContent extends ConsumerWidget {
  const _StationContent({required this.station});

  final Station station;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final s = station;
    final facilities = ref.watch(stationFacilitiesProvider(s.id)).value;
    final departures = ref.watch(departuresProvider(s.id));
    final nearby = ref.watch(destinationsNearStationProvider(s.id)).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (facilities != null && facilities.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final f in facilities)
                StatusChip(label: f, tone: StatusTone.neutral),
            ],
          )
        else
          Text(
            l10n.facilitiesNotListed,
            style: AppTextStyles.caption.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
        SectionLabel(l10n.nextDepartures),
        AsyncView<List<StationDeparture>>(
          value: departures,
          isEmpty: (d) => d.isEmpty,
          onRetry: () => ref.invalidate(departuresProvider(s.id)),
          content: (_, d) => _Departures(departures: d),
          empty: (_) => EmptyState(
            icon: Icons.train_outlined,
            title: l10n.noDeparturesTitle,
            message: l10n.noDeparturesBody,
          ),
          loading: (_) => const ShimmerList(
            itemCount: 2,
            itemHeight: 70,
            padding: EdgeInsets.zero,
          ),
        ),
        if (nearby != null && nearby.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          SectionLabel(l10n.nearbyPlaces),
          SettingsSection(
            children: [
              for (final n in nearby)
                SettingsTile(
                  icon: n.destination.categoryName == null
                      ? Icons.place_outlined
                      : Icons.landscape_outlined,
                  title: n.destination.name.of(context),
                  value: n.km == null
                      ? null
                      : l10n.approxKm(n.km!.toStringAsFixed(1)),
                  onTap: () => context.push(
                    AppRoutes.withId(
                      AppRoutes.destinationDetails,
                      n.destination.id,
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: l10n.timetable,
                icon: Icons.schedule_rounded,
                tone: PrimaryButtonTone.dark,
                onPressed: () {
                  ref.read(journeyProvider.notifier).setFrom(s.code);
                  context.go(AppRoutes.trains);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: SecondaryButton(
                label: l10n.directions,
                icon: Icons.directions_outlined,
                onPressed: !s.hasLocation
                    ? null
                    : () => launchUrl(
                        Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${s.lat},${s.lng}',
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
              ),
            ),
          ],
        ),
        if (s.photoCredit != null) ...[
          const SizedBox(height: AppSpacing.lg),
          PhotoCredit(s.photoCredit),
        ],
      ],
    );
  }
}

class _Departures extends StatelessWidget {
  const _Departures({required this.departures});

  final List<StationDeparture> departures;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    int mins(String t) =>
        int.parse(t.substring(0, 2)) * 60 + int.parse(t.substring(3, 5));
    final today = DateTime.now().weekday;
    final tomorrow = today % 7 + 1;
    final next = [
      ...departures.where(
        (d) => mins(d.time) >= nowMin && runsOnDay(d.train.runsOn, today),
      ),
      ...departures.where(
        (d) => mins(d.time) < nowMin && runsOnDay(d.train.runsOn, tomorrow),
      ),
    ].take(4).toList();
    final rows = <Widget>[];
    for (var i = 0; i < next.length; i += 2) {
      rows.add(
        EqualRow(
          children: [
            _DepartureBox(departure: next[i]),
            if (i + 1 < next.length)
              _DepartureBox(departure: next[i + 1])
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

class _DepartureBox extends StatelessWidget {
  const _DepartureBox({required this.departure});

  final StationDeparture departure;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final d = departure;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s14),
      onTap: () =>
          context.push(AppRoutes.withId(AppRoutes.trainDetails, d.train.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.toStation(d.train.destinationName.of(context)),
            style: AppTextStyles.caption.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            d.time,
            style: AppTextStyles.timeLarge.copyWith(color: palette.textPrimary),
          ),
          Text(
            '${d.train.name.of(context)} · #${d.train.number}',
            style: AppTextStyles.captionStrong.copyWith(color: palette.primary),
          ),
        ],
      ),
    );
  }
}
