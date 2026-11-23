import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/status_chip.dart';

/// About CeylonGO: brand card, mission, legal links.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.aboutApp),
            Expanded(
              child: PageScroll(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      color: palette.hero,
                      borderRadius: AppRadii.heroAll,
                    ),
                    child: Column(
                      children: [
                        const AppLogoMark(size: 72),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.appName,
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.appTagline,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.mutedOnDark,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        StatusChip(
                          label: l10n.versionLabel(AppConstants.version),
                          tone: StatusTone.lime,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    l10n.aboutBody,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  SettingsSection(
                    children: [
                      SettingsTile(
                        icon: Icons.dataset_outlined,
                        title: l10n.dataSourceTitle,
                        subtitle: l10n.dataSourceBody,
                        showChevron: false,
                      ),
                      SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: l10n.privacyPolicy,
                        onTap: () {},
                      ),
                      SettingsTile(
                        icon: Icons.description_outlined,
                        title: l10n.termsOfUse,
                        onTap: () {},
                      ),
                      SettingsTile(
                        icon: Icons.star_outline_rounded,
                        title: l10n.rateApp,
                        onTap: () {},
                      ),
                    ],
                  ),
                  Text(
                    l10n.notOfficial,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
