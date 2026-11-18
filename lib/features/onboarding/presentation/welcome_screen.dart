import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/photo_backdrop.dart';
import '../../../core/widgets/status_chip.dart';

/// Full-bleed Nine Arch Bridge hero with the "Get started" call to action.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.forestDeep,
      body: PhotoBackdrop(
        asset: AppAssets.nineArchBridge,
        semanticLabel: l10n.welcomeImageAlt,
        alignment: const Alignment(-0.2, 0),
        fade: BackdropFade.welcome,
        child: SafeArea(
          child: FillScroll(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TopRow(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                  ),
                  child: _HeroCopy(
                    onGetStarted: () => context.push(AppRoutes.onboarding),
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

class _TopRow extends StatelessWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppBrand(markSize: 36, fontSize: 19),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Semantics(
            button: true,
            label: l10n.welcomeChangeLanguage,
            excludeSemantics: true,
            child: Material(
              color: AppColors.scrim,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push(AppRoutes.languageSelect),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSizes.tapTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s14,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.language_rounded,
                          size: AppSizes.iconSm,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: AppSpacing.s6),
                        Text(
                          l10n.welcomeLanguageChip,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusChip(label: l10n.welcomePhotoPlace, tone: StatusTone.glass),
            StatusChip(label: l10n.welcomePhotoLine, tone: StatusTone.lime),
          ],
        ),
        const SizedBox(height: AppSpacing.s14),
        Semantics(
          header: true,
          child: Text(
            l10n.appTagline,
            style: AppTextStyles.hero.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.s14),
        Text(
          l10n.welcomeBody,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.softOnDark),
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(label: l10n.getStarted, onPressed: onGetStarted),
      ],
    );
  }
}
