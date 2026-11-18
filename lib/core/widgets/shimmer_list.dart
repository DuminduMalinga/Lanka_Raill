import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Wraps [child] in the app's shimmer gradient.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child, this.onDark = false});

  final Widget child;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      label: context.l10n.loading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Shimmer.fromColors(
          baseColor: onDark ? AppColors.forestRaised : palette.neutralChip,
          highlightColor: onDark
              ? AppColors.forest
              : palette.surface.withValues(alpha: 0.9),
          child: child,
        ),
      ),
    );
  }
}

/// Solid placeholder block used inside [AppShimmer].
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = AppRadii.iconTile,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Loading skeleton for list screens: [itemCount] card-shaped rows.
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 76,
    this.radius = AppRadii.card,
    this.padding = AppSpacing.page,
    this.header = false,
    this.onDark = false,
  });

  final int itemCount;
  final double itemHeight;
  final double radius;
  final EdgeInsets padding;
  final bool header;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      onDark: onDark,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header) ...[
              const ShimmerBox(width: 160, height: 18, radius: 6),
              const SizedBox(height: AppSpacing.md),
            ],
            for (var i = 0; i < itemCount; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              ShimmerBox(height: itemHeight, radius: radius),
            ],
          ],
        ),
      ),
    );
  }
}
