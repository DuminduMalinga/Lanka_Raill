import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../../data/models.dart';
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
              avatarUrl: profile?.avatarUrl,
              onEdit: () {
                if (!signedIn || profile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.profileSignInToEdit)),
                  );
                  context.push(AppRoutes.signIn);
                  return;
                }
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => _EditProfileSheet(profile: profile),
                );
              },
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
    required this.onEdit,
    this.avatarUrl,
  });

  final VoidCallback onEdit;
  final String? avatarUrl;
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
                      _Avatar(initials: initials, imageUrl: avatarUrl),
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
                        onPressed: onEdit,
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
  const _Avatar({required this.initials, this.imageUrl, this.size = 68});

  final String initials;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final fallback = Text(
      initials,
      style: AppTextStyles.h4.copyWith(fontSize: size / 2.8, color: AppColors.ink),
    );
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: AppColors.lime,
          shape: BoxShape.circle,
        ),
        child: url == null
            ? fallback
            : Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet({required this.profile});

  final Profile profile;

  @override
  ConsumerState<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late final _name = TextEditingController(text: widget.profile.displayName ?? '');
  Uint8List? _photo;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
    } catch (e) {
      // Permission denied, no camera, or the plugin isn't in this build.
      debugPrint('Image picker failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.photoPickFailed)),
        );
      }
      return;
    }
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _photo = bytes);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final failed = context.l10n.profileSaveFailed;
    try {
      final name = _name.text.trim();
      if (name != (widget.profile.displayName ?? '')) {
        await repo.updateProfile(displayName: name);
      }
      if (_photo != null) await repo.uploadAvatar(_photo!);
      ref.invalidate(profileProvider);
      navigator.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = widget.profile;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.md,
        AppSpacing.gutter,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.gutter,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.editProfile, style: AppTextStyles.h4),
          const SizedBox(height: AppSpacing.s18),
          Center(
            child: GestureDetector(
              onTap: _saving ? null : _pick,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (_photo != null)
                    ClipOval(
                      child: Image.memory(_photo!, width: 96, height: 96, fit: BoxFit.cover),
                    )
                  else
                    _Avatar(initials: p.initials, imageUrl: p.avatarUrl, size: 96),
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.ink,
                    child: Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: _saving ? null : _pick,
            child: Text(l10n.changePhoto),
          ),
          const SizedBox(height: AppSpacing.s14),
          TextField(
            controller: _name,
            enabled: !_saving,
            textCapitalization: TextCapitalization.words,
            maxLength: 60,
            decoration: InputDecoration(
              labelText: l10n.displayNameLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.s14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
