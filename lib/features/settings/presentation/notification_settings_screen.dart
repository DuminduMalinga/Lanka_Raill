import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';

/// Notification preferences (UI toggles only).
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    Widget toggle(String id, IconData icon, String title, String subtitle) {
      return SettingsSwitchTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        value: ref.watch(uiToggleProvider(id)),
        onChanged: (v) => ref.read(uiToggleProvider(id).notifier).set(v),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.notifications),
            Expanded(
              child: PageScroll(
                children: [
                  SettingsSection(
                    title: l10n.sectionRailwayUpdates,
                    children: [
                      toggle(
                        UiToggles.notifyVerified,
                        Icons.verified_outlined,
                        l10n.notifyVerified,
                        l10n.notifyVerifiedSub,
                      ),
                      toggle(
                        UiToggles.notifyDelays,
                        Icons.schedule_rounded,
                        l10n.notifyDelays,
                        l10n.notifyDelaysSub,
                      ),
                      toggle(
                        UiToggles.notifySchedule,
                        Icons.construction_outlined,
                        l10n.notifySchedule,
                        l10n.notifyScheduleSub,
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.sectionTrips,
                    children: [
                      toggle(
                        UiToggles.notifyReminders,
                        Icons.alarm_rounded,
                        l10n.notifyReminders,
                        l10n.notifyRemindersSub,
                      ),
                      toggle(
                        UiToggles.notifyInspiration,
                        Icons.explore_outlined,
                        l10n.notifyInspiration,
                        l10n.notifyInspirationSub,
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: l10n.sectionQuietHours,
                    children: [
                      toggle(
                        UiToggles.quietHours,
                        Icons.bedtime_outlined,
                        l10n.quietHoursRange,
                        l10n.quietHoursSub,
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
