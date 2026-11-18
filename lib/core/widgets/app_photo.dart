import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'shimmer_list.dart';

/// Photo slot from the design.
///
/// * [asset] – bundled image (design photos).
/// * [imageUrl] – remote photo, loaded with `cached_network_image` and a
///   shimmer placeholder.
/// * neither – the design's tinted "Photo" placeholder.
class AppPhoto extends StatelessWidget {
  const AppPhoto({
    super.key,
    this.asset,
    this.imageUrl,
    this.semanticLabel,
    this.placeholderColor = AppColors.photoEarth,
    this.radius = AppRadii.iconTileLg,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.showPlaceholderLabel = true,
  });

  final String? asset;
  final String? imageUrl;
  final String? semanticLabel;
  final Color placeholderColor;
  final double radius;
  final double? width;
  final double? height;
  final Alignment alignment;
  final bool showPlaceholderLabel;

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (asset != null) {
      image = Image.asset(
        asset!,
        fit: BoxFit.cover,
        alignment: alignment,
        width: width,
        height: height,
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
      );
    } else if (imageUrl != null) {
      image = Semantics(
        image: true,
        label: semanticLabel,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          alignment: alignment,
          width: width,
          height: height,
          placeholder: (_, _) => AppShimmer(
            child: ShimmerBox(width: width, height: height ?? 80),
          ),
          errorWidget: (_, _, _) => _Placeholder(
            color: placeholderColor,
            showLabel: showPlaceholderLabel,
          ),
        ),
      );
    } else {
      image = _Placeholder(
        color: placeholderColor,
        showLabel: showPlaceholderLabel,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: image),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color, required this.showLabel});

  final Color color;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.white.withValues(alpha: 0.78);
    return ColoredBox(
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: AppSizes.icon, color: fg),
            if (showLabel) ...[
              const SizedBox(height: AppSpacing.s6),
              Text(
                context.l10n.photo,
                style: AppTextStyles.label.copyWith(color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
