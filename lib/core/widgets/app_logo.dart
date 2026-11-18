import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_assets.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Lime rounded square with the rail-track mark.
class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.lime,
          borderRadius: BorderRadius.circular(size * 0.29),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssets.logoMark,
          width: size * 0.6,
          height: size * 0.6,
        ),
      ),
    );
  }
}

/// Logo mark + "CeylonGO" wordmark.
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
