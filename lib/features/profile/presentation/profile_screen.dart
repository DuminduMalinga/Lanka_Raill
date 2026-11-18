import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/circle_icon_button.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';

/// Profile tab: identity header with stats, shortcuts, sign out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.name = 'Malinga',
    this.initials = 'MB',
    this.homeStation = 'Colombo Fort',
    this.savedTrains = 3,
    this.savedPlaces = 5,
    this.savedStations = 4,
    this.unread = 2,
  });

  // Design preview defaults — replace with the signed-in user's data.
  final String name;
  final String initials;
  final String homeStation;
  final int savedTrains;
  final int savedPlaces;
  final int savedStations;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.navClearance),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(
              name: name,
              initials: initials,
              subtitle: l10n.homeStationLabel(homeStation),
              stats: [
                (
                  '$savedTrains',
                  l10n.statSavedTrains,
                  AppRoutes.favoriteTrains,
                ),
                (
                  '$savedPlaces',
                  l10n.statSavedPlaces,
                  AppRoutes.favoriteDestinations,
                ),
                (
                  '$savedStations',
                  l10n.statStations,
                  AppRoutes.stationDirectory,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.s18,
                AppSpacing.gutter,
                0,
              ),
              child: MaxWidth(
                child: Column(
                  children: [
                    SettingsSection(
                      children: [
                        SettingsTile(
                          icon: Icons.bookmark_border_rounded,
                          title: l10n.savedTitle,
                          subtitle: l10n.savedRowSub,
                          onTap: () => context.go(AppRoutes.saved),
                        ),
                        SettingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: l10n.announcements,
                          subtitle: l10n.unreadCount(unread),
                          onTap: () => context.push(AppRoutes.announcements),
                        ),
                        SettingsTile(
                          icon: Icons.settings_outlined,
                          title: l10n.settings,
                          subtitle: l10n.settingsRowSub,
                          onTap: () => context.push(AppRoutes.settings),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s14),
                    SettingsSection(
                      children: [
                        SettingsTile(
                          icon: Icons.help_outline_rounded,
                          title: l10n.helpFeedback,
                          onTap: () => context.push(AppRoutes.helpFeedback),
                        ),
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: l10n.aboutApp,
                          onTap: () => context.push(AppRoutes.about),
                        ),
                        SettingsTile(
                          icon: Icons.logout_rounded,
                          title: l10n.signOut,
                          destructive: true,
                          onTap: () => context.go(AppRoutes.signIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.initials,
    required this.subtitle,
    required this.stats,
  });

  final String name;
  final String initials;
  final String subtitle;
  final List<(String, String, String)> stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: BoxDecoration(
          color: palette.hero,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppRadii.sheet),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.md,
              AppSpacing.gutter,
              AppSpacing.s22,
            ),
            child: MaxWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.profile,
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      CircleIconButton(
                        icon: Icons.settings_outlined,
                        tone: CircleIconTone.glass,
                        semanticLabel: l10n.settings,
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s18),
                  Row(
                    children: [
                      _Avatar(initials: initials),
                      const SizedBox(width: AppSpacing.s14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.h4.copyWith(
                                fontSize: 20,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.mutedOnDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleIconButton(
                        icon: Icons.edit_outlined,
                        tone: CircleIconTone.glass,
                        semanticLabel: l10n.editProfile,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s18),
                  EqualRow(
                    children: [
                      for (final (value, label, route) in stats)
                        StatTile(
                          value: value,
                          label: label,
                          onDark: true,
                          onTap: () => context.push(route),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 68,
        height: 68,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
        ),
        child: Text(
          initials,
          style: AppTextStyles.h4.copyWith(fontSize: 24, color: AppColors.ink),
        ),
      ),
    );
  }
}
