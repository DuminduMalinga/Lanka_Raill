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
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_header.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../core/widgets/ui_state_view.dart';

/// Destination page: tags, description, nearest station, actions.
class DestinationDetailsScreen extends StatelessWidget {
  const DestinationDetailsScreen({super.key, this.viewState});

  final UiViewState? viewState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Design preview content.
            PhotoHeader(
              imageAsset: AppAssets.nineArchBridge,
              semanticLabel: l10n.welcomeImageAlt,
              height: 360,
              title: 'Nine Arch Bridge, Ella',
              actions: [
                HeaderAction(icon: Icons.ios_share_rounded, label: l10n.share),
                HeaderAction(
                  icon: Icons.bookmark_border_rounded,
                  label: l10n.savePlace,
                ),
              ],
              bottom: _GalleryButton(
                label: l10n.gallery,
                onTap: () => context.push(AppRoutes.destinationGallery),
              ),
            ),
            DetailBody(
              child: MaxWidth(
                child: UiStateView(
                  state: viewState,
                  content: (_) => const _DestinationContent(),
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

class _DestinationContent extends StatelessWidget {
  const _DestinationContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    // Design preview content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(label: 'Scenic view', tone: StatusTone.lime),
            StatusChip(label: 'Free entry'),
            StatusChip(label: 'Easy walk', tone: StatusTone.neutral),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'A colonial-era stone viaduct completed in 1921, curving through '
          'jungle and tea between Ella and Demodara. Arrive before a '
          'scheduled train to watch it cross.',
          style: AppTextStyles.bodyLarge.copyWith(color: palette.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          onTap: () => context.push(AppRoutes.nearbyStations),
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
                      'Ella · ≈2.5 km walk',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(label: l10n.moreCount(2), tone: StatusTone.neutral),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.save,
                icon: Icons.bookmark_border_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: l10n.trainsTo('Ella'),
                icon: Icons.train_outlined,
                tone: PrimaryButtonTone.dark,
                onPressed: () => context.push(AppRoutes.searchResults),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
