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
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';

/// Destination page: tags, description, nearest station, actions.
class DestinationDetailsScreen extends ConsumerWidget {
  const DestinationDetailsScreen({
    super.key,
    this.destinationId,
    this.viewState,
  });

  final String? destinationId;
  final UiViewState? viewState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = ref.watch(destinationIdProvider(destinationId));
    final dest = resolved(ref, id, (v) => ref.watch(destinationProvider(v)));
    final d = dest.value;
    final saved =
        d != null &&
        (ref
                .watch(favoritesProvider(FavoriteKind.destination))
                .value
                ?.contains(d.id) ??
            false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoHeader(
              imageAsset: d?.coverUrl == null ? AppAssets.nineArchBridge : null,
              imageUrl: d?.coverUrl,
              semanticLabel: d?.name.of(context) ?? l10n.welcomeImageAlt,
              height: 360,
              title: d?.name.of(context) ?? '',
              subtitle: d?.categoryName?.of(context),
              actions: [
                HeaderAction(
                  icon: saved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: l10n.savePlace,
                  onPressed: d == null
                      ? null
                      : () => toggleFavorite(
                          context,
                          ref,
                          FavoriteKind.destination,
                          d.id,
                        ),
                ),
              ],
              bottom: d == null || d.photos.isEmpty
                  ? null
                  : _GalleryButton(
                      label: '${l10n.gallery} · ${d.photos.length}',
                      onTap: () => context.push(
                        AppRoutes.withId(AppRoutes.destinationGallery, d.id),
                      ),
                    ),
            ),
            DetailBody(
              child: MaxWidth(
                child: AsyncView<Destination?>(
                  value: dest,
                  state: viewState,
                  isEmpty: (v) => v == null,
                  onRetry: () => ref.invalidate(destinationsProvider(null)),
                  content: (_, v) => _DestinationContent(destination: v!),
                  empty: (_) => EmptyState(
                    icon: Icons.place_outlined,
                    title: l10n.emptyDetailsTitle,
                    message: l10n.emptyDetailsBody,
                  ),
                  loading: (_) =>
                      const ShimmerList(itemCount: 3, padding: EdgeInsets.zero),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CompactPillButton(
      label: label,
      icon: Icons.photo_library_outlined,
      background: AppColors.scrimStrong,
      foreground: AppColors.white,
      onPressed: onTap,
    );
  }
}

class _DestinationContent extends ConsumerWidget {
  const _DestinationContent({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final d = destination;
    final nearest = d.nearest;
    final saved =
        ref
            .watch(favoritesProvider(FavoriteKind.destination))
            .value
            ?.contains(d.id) ??
        false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (d.tags.isNotEmpty)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < d.tags.length; i++)
                StatusChip(
                  label: d.tags[i],
                  tone: i == 0 ? StatusTone.lime : StatusTone.mint,
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
        if (d.description != null)
          Text(
            d.description!.of(context),
            style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary),
          ),
        if (d.coverCredit != null) ...[
          const SizedBox(height: AppSpacing.sm),
          PhotoCredit(d.coverCredit),
        ],
        if (nearest != null) ...[
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            onTap: () => context.push(
              AppRoutes.withId(AppRoutes.nearbyStations, d.id),
            ),
            padding: const EdgeInsets.all(AppSpacing.s14),
            child: Row(
              children: [
                const IconTile(icon: Icons.train_outlined, size: 42),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nearestStationLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                      Text(
                        [
                          nearest.station.name.of(context),
                          if (nearest.km != null)
                            l10n.approxKm(nearest.km!.toStringAsFixed(1)),
                        ].join(' · '),
                        style: AppTextStyles.cardTitle.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (d.nearestStations.length > 1)
                  StatusChip(
                    label: l10n.moreCount(d.nearestStations.length - 1),
                    tone: StatusTone.neutral,
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.save,
                icon: saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                onPressed: () => toggleFavorite(
                  context,
                  ref,
                  FavoriteKind.destination,
                  d.id,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: l10n.trainsTo(
                  nearest?.station.name.of(context) ?? d.name.of(context),
                ),
                icon: Icons.train_outlined,
                tone: PrimaryButtonTone.dark,
                onPressed: nearest == null
                    ? null
                    : () {
                        ref
                            .read(journeyProvider.notifier)
                            .setTo(nearest.station.code);
                        context.push(AppRoutes.searchResults);
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
