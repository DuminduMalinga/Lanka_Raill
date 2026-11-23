import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../../data/providers.dart';
import '../../auth/data/auth_service.dart';

/// Profile tab: identity header with stats, shortcuts, sign out.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final signedIn = ref.watch(isSignedInProvider);
    final profile = ref.watch(profileProvider).value;
    int count(FavoriteKind k) =>
        ref.watch(favoritesProvider(k)).value?.length ?? 0;
    final home = ref
        .watch(stationByCodeProvider(ref.watch(journeyProvider).fromCode))
        .value;
    final unread = (ref.watch(announcementsProvider).value ?? const [])
        .where((a) => a.severity.name != 'info')
        .length;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.navClearance),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(
              name: profile?.label ?? l10n.guest,
              initials: profile?.initials ?? 'G',
              subtitle: signedIn
                  ? (profile?.email ??
                        l10n.homeStationLabel(home?.name.of(context) ?? ''))
                  : l10n.signInForSaved,
              stats: [
                (
                  '${count(FavoriteKind.train)}',
                  l10n.statSavedTrains,
                  AppRoutes.favoriteTrains,
                ),
                (
                  '${count(FavoriteKind.destination)}',
                  l10n.statSavedPlaces,
                  AppRoutes.favoriteDestinations,
                ),
                (
                  '${count(FavoriteKind.station)}',
                  l10n.statStations,
                  AppRoutes.saved,
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
                        if (signedIn)
                          SettingsTile(
                            icon: Icons.logout_rounded,
                            title: l10n.signOut,
                            destructive: true,
                            onTap: () async {
                              try {
                                await AuthService.signOut();
                              } catch (_) {
                                // Local session is cleared regardless.
                              }
                              if (context.mounted) context.go(AppRoutes.signIn);
                            },
                          )
                        else
                          SettingsTile(
                            icon: Icons.login_rounded,
                            title: l10n.signIn,
                            onTap: () => context.push(AppRoutes.signIn),
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
