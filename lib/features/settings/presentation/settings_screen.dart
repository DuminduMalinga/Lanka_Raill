import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';

/// Settings hub: preferences, travel, data, support.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(appLanguageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final offline = ref.watch(uiToggleProvider(UiToggles.offlineTimetables));
    final notificationsOn = [
      UiToggles.notifyVerified,
      UiToggles.notifyDelays,
      UiToggles.notifySchedule,
      UiToggles.notifyReminders,
      UiToggles.notifyInspiration,
    ].where((id) => ref.watch(uiToggleProvider(id))).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.settings),
            Expanded(
              child: PageScroll(
                children: [
                  SettingsSection(
                    title: l10n.sectionPreferences,
                    children: [
                      SettingsTile(
                        icon: Icons.translate_rounded,
                        title: l10n.language,
                        value: language == AppLanguage.english
                            ? l10n.languageEnglish
                            : l10n.languageSinhala,
                        onTap: () => context.push(AppRoutes.languageSettings),
                      ),
                      SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        title: l10n.theme,
                        value: themeLabel(l10n, themeMode),
                        onTap: () => context.push(AppRoutes.themeSettings),
                      ),
                      SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: l10n.notifications,
                        value: l10n.notificationsOnCount(notificationsOn),
                        onTap: () =>
                            context.push(AppRoutes.notificationSettings),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.sectionTravel,
                    // Design preview values — replace with saved preferences.
                    children: [
                      SettingsTile(
                        icon: Icons.home_outlined,
                        title: l10n.homeStation,
                        value: 'Colombo Fort',
                        onTap: () => context.push(AppRoutes.departureStation),
                      ),
                      SettingsTile(
                        icon: Icons.event_seat_outlined,
                        title: l10n.preferredClass,
                        value: l10n.class2nd,
                        onTap: () => context.push(AppRoutes.classesFacilities),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.sectionData,
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.offline_pin_outlined,
                        title: l10n.offlineTimetables,
                        subtitle: l10n.offlineTimetablesSub,
                        value: offline,
                        onChanged: (v) => ref
                            .read(
                              uiToggleProvider(UiToggles.offlineTimetables)
                                  .notifier,
                            )
                            .set(v),
                      ),
                      SettingsTile(
                        icon: Icons.history_rounded,
                        title: l10n.clearSearchHistory,
                        showChevron: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.sectionSupport,
                    children: [
                      SettingsTile(
                        icon: Icons.help_outline_rounded,
                        title: l10n.helpFeedback,
                        onTap: () => context.push(AppRoutes.helpFeedback),
                      ),
                      SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: l10n.aboutApp,
                        value: l10n.versionShort(AppConstants.version),
                        onTap: () => context.push(AppRoutes.about),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Localised label for a [ThemeMode].
String themeLabel(AppLocalizations l10n, ThemeMode mode) => switch (mode) {
  ThemeMode.light => l10n.themeLight,
  ThemeMode.dark => l10n.themeDark,
  ThemeMode.system => l10n.themeSystem,
};
