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
import '../../../data/providers.dart';

/// Settings hub: preferences, travel, data, support.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(appLanguageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final offline = ref.watch(uiToggleProvider(UiToggles.offlineTimetables));
    final homeCode = ref.watch(homeStationProvider);
    final homeName =
        ref.watch(stationByCodeProvider(homeCode)).value?.name.of(context) ??
        homeCode;
    final classLabels = [
      l10n.classAll,
      l10n.class1stObservation,
      l10n.class2nd,
      l10n.class3rd,
    ];
    final travelClass = ref.watch(
      uiSelectionProvider(UiSelections.travelClass),
    );
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
                    children: [
                      SettingsTile(
                        icon: Icons.home_outlined,
                        title: l10n.homeStation,
                        value: homeName,
                        onTap: () => context.push(AppRoutes.homeStationPicker),
                      ),
                      SettingsTile(
                        icon: Icons.event_seat_outlined,
                        title: l10n.preferredClass,
                        value: classLabels[travelClass.clamp(0, 3)],
                        onTap: () => _pickClass(
                          context,
                          ref,
                          classLabels,
                          travelClass,
                        ),
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
                        onTap: () async {
                          await ref
                              .read(recentSearchesProvider.notifier)
                              .clear();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.searchHistoryCleared)),
                          );
                        },
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

Future<void> _pickClass(
  BuildContext context,
  WidgetRef ref,
  List<String> labels,
  int selected,
) async {
  final picked = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: RadioGroup<int>(
        groupValue: selected,
        onChanged: (v) => Navigator.of(sheet).pop(v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              RadioListTile<int>(value: i, title: Text(labels[i])),
          ],
        ),
      ),
    ),
  );
  if (picked != null) {
    ref.read(uiSelectionProvider(UiSelections.travelClass).notifier).select(picked);
  }
}

/// Localised label for a [ThemeMode].
String themeLabel(AppLocalizations l10n, ThemeMode mode) => switch (mode) {
  ThemeMode.light => l10n.themeLight,
  ThemeMode.dark => l10n.themeDark,
  ThemeMode.system => l10n.themeSystem,
};
