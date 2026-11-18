import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_assets.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// App icon tile: a white speeding train on a charcoal-to-mint gradient.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.size = 32, this.glow = false});

  final double size;

  /// Adds the soft mint halo used on the splash screen.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.24);
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.logoTile,
              AppColors.logoTileMid,
              AppColors.logoTileGreen,
              AppColors.logoTileMint,
            ],
            stops: [0, 0.38, 0.72, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              blurRadius: size * 0.12,
              offset: Offset(0, size * 0.04),
            ),
            if (glow)
              BoxShadow(
                color: AppColors.signal.withValues(alpha: 0.28),
                blurRadius: size * 0.5,
                offset: Offset(0, size * 0.1),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dark core that keeps the glyph readable over the gradient.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.24),
                      radius: 0.72,
                      colors: [
                        AppColors.logoTile,
                        AppColors.logoTile,
                        AppColors.logoTile.withValues(alpha: 0),
                      ],
                      stops: const [0, 0.5, 1],
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                AppAssets.logoMark,
                width: size * 0.74,
                height: size * 0.74,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo mark + app-name wordmark.
class AppBrand extends StatelessWidget {
  const AppBrand({
    super.key,
    this.markSize = 32,
    this.fontSize = 17,
    this.color = AppColors.white,
  });

  final double markSize;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.appName,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLogoMark(size: markSize),
          SizedBox(width: markSize * 0.28),
          Flexible(
            child: Text(
              context.l10n.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.brand.copyWith(
                fontSize: fontSize,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
