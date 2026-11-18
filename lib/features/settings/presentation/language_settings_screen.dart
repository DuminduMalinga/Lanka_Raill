import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/settings_tiles.dart';
import '../../../core/widgets/status_chip.dart';

/// App language picker plus bilingual display options.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final language = ref.watch(appLanguageProvider);
    final bilingual = ref.watch(uiToggleProvider(UiToggles.bilingualNames));
    final translate = ref.watch(
      uiToggleProvider(UiToggles.translateAnnouncements),
    );
    void pick(AppLanguage l) =>
        ref.read(appLanguageProvider.notifier).select(l);
    void toggle(String id, bool v) =>
        ref.read(uiToggleProvider(id).notifier).set(v);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.language),
            Expanded(
              child: PageScroll(
                spacing: AppSpacing.md,
                children: [
                  SectionLabel(l10n.appLanguage),
                  OptionCard(
                    title: l10n.languageEnglish,
                    subtitle: l10n.languageEnglishSub,
                    selected: language == AppLanguage.english,
                    onTap: () => pick(AppLanguage.english),
                    titleStyle: AppTextStyles.optionTitle,
                  ),
                  OptionCard(
                    title: l10n.languageSinhala,
                    subtitle: l10n.languageSinhalaSub,
                    selected: language == AppLanguage.sinhala,
                    onTap: () => pick(AppLanguage.sinhala),
                    titleStyle: AppTextStyles.optionTitle,
                  ),
                  OptionCard(
                    title: l10n.languageTamil,
                    subtitle: l10n.languageTamilSub,
                    selected: false,
                    enabled: false,
                    onTap: () {},
                    titleStyle: AppTextStyles.optionTitle,
                    trailing: StatusChip(
                      label: l10n.comingSoon,
                      tone: StatusTone.neutral,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsSection(
                    title: l10n.sectionDisplay,
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.translate_rounded,
                        title: l10n.bilingualNames,
                        subtitle: l10n.bilingualNamesSub,
                        value: bilingual,
                        onChanged: (v) => toggle(UiToggles.bilingualNames, v),
                      ),
                      SettingsSwitchTile(
                        icon: Icons.campaign_outlined,
                        title: l10n.translateAnnouncements,
                        subtitle: l10n.translateAnnouncementsSub,
                        value: translate,
                        onChanged: (v) =>
                            toggle(UiToggles.translateAnnouncements, v),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: AppSizes.iconSm,
                        color: palette.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.s6),
                      Expanded(
                        child: Text(
                          l10n.officialNamesNote,
                          style: AppTextStyles.caption.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                    ],
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
