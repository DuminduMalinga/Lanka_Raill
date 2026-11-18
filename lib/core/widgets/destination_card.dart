import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_photo.dart';
import 'buttons.dart';
import 'status_chip.dart';

/// Horizontal destination row: photo, title, description, station link.
class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.title,
    required this.description,
    this.stationLabel,
    this.imageAsset,
    this.imageUrl,
    this.placeholderColor = AppColors.photoEarth,
    this.onTap,
  });

  final String title;
  final String description;
  final String? stationLabel;
  final String? imageAsset;
  final String? imageUrl;
  final Color placeholderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s10),
      child: Row(
        children: [
          AppPhoto(
            asset: imageAsset,
            imageUrl: imageUrl,
            placeholderColor: placeholderColor,
            width: 84,
            height: 64,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textMuted,
                  ),
                ),
                if (stationLabel != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.train_outlined,
                        size: 14,
                        color: palette.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          stationLabel!,
                          style: AppTextStyles.captionStrong.copyWith(
                            color: palette.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}

/// Large featured photo card with gradient, tag, title and CTA.
class FeaturedDestinationCard extends StatelessWidget {
  const FeaturedDestinationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tagLabel,
    required this.ctaLabel,
    this.imageAsset,
    this.imageUrl,
    this.semanticLabel,
    this.height = 290,
    this.onTap,
    this.onCta,
  });

  final String title;
  final String subtitle;
  final String tagLabel;
  final String ctaLabel;
  final String? imageAsset;
  final String? imageUrl;
  final String? semanticLabel;
  final double height;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: title,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: AppRadii.heroAll,
          child: SizedBox(
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppPhoto(
                  asset: imageAsset,
                  imageUrl: imageUrl,
                  semanticLabel: semanticLabel,
                  radius: 0,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.45, 1],
                      colors: [Color(0x000B1912), Color(0xD90B1912)],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.s14,
                  top: AppSpacing.s14,
                  child: StatusChip(label: tagLabel, tone: StatusTone.lime),
                ),
                Positioned(
                  left: AppSpacing.s18,
                  right: AppSpacing.s18,
                  bottom: AppSpacing.lg,
                  child: _Footer(
                    title: title,
                    subtitle: subtitle,
                    ctaLabel: ctaLabel,
                    onCta: onCta ?? onTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    this.onCta,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.h4.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.captionOnDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        CompactPillButton(label: ctaLabel, onPressed: onCta),
      ],
    );
  }
}

/// Square-ish photo tile with title + subtitle (saved places grid).
class DestinationGridTile extends StatelessWidget {
  const DestinationGridTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.imageUrl,
    this.placeholderColor = AppColors.photoEarth,
    this.saved = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? imageUrl;
  final Color placeholderColor;
  final bool saved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.25,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppPhoto(
                  asset: imageAsset,
                  imageUrl: imageUrl,
                  placeholderColor: placeholderColor,
                  radius: AppRadii.iconTileLg,
                ),
                if (saved)
                  Positioned(
                    right: AppSpacing.sm,
                    top: AppSpacing.sm,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark_rounded,
                        size: 16,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyStrong.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.xxs,
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: palette.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
