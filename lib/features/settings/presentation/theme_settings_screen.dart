import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/page_scroll.dart';
import '../../../core/widgets/settings_tiles.dart';

/// Light / Dark / System picker plus comfort toggles.
class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final palette = context.palette;
    final mode = ref.watch(themeModeProvider);
    final largerText = ref.watch(uiToggleProvider(UiToggles.largerText));
    final contrast = ref.watch(uiToggleProvider(UiToggles.highContrast));
    void toggle(String id, bool v) =>
        ref.read(uiToggleProvider(id).notifier).set(v);

    final options = <(ThemeMode, String, Color, Color)>[
      (ThemeMode.light, l10n.themeLight, AppColors.canvas, AppColors.white),
      (ThemeMode.dark, l10n.themeDark, AppColors.forestDeep, AppColors.forest),
      (ThemeMode.system, l10n.themeSystem, AppColors.canvas, AppColors.forest),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: l10n.theme),
            Expanded(
              child: PageScroll(
                children: [
                  Semantics(
                    label: l10n.theme,
                    child: Row(
                      children: [
                        for (var i = 0; i < options.length; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.s10),
                          Expanded(
                            child: ThemeOptionTile(
                              label: options[i].$2,
                              base: options[i].$3,
                              card: options[i].$4,
                              selected: mode == options[i].$1,
                              onTap: () => ref
                                  .read(themeModeProvider.notifier)
                                  .select(options[i].$1),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    l10n.themeNote,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: palette.textMuted,
                    ),
                  ),
                  SettingsSection(
                    title: l10n.sectionComfort,
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.format_size_rounded,
                        title: l10n.largerText,
                        subtitle: l10n.largerTextSub,
                        value: largerText,
                        onChanged: (v) => toggle(UiToggles.largerText, v),
                      ),
                      SettingsSwitchTile(
                        icon: Icons.contrast_rounded,
                        title: l10n.highContrast,
                        subtitle: l10n.highContrastSub,
                        value: contrast,
                        onChanged: (v) => toggle(UiToggles.highContrast, v),
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

/// Mini phone preview used as a theme radio option.
class ThemeOptionTile extends StatelessWidget {
  const ThemeOptionTile({
    super.key,
    required this.label,
    required this.base,
    required this.card,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color base;
  final Color card;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardLgAll,
          side: BorderSide(
            color: selected ? palette.primary : palette.border,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s10),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: base,
                      borderRadius: BorderRadius.circular(AppRadii.iconTile),
                      border: Border.all(color: palette.border),
                    ),
                    child: Column(
                      children: [
                        _Bar(color: card, height: 18),
                        const SizedBox(height: AppSpacing.s6),
                        _Bar(color: card, height: 10),
                        const SizedBox(height: AppSpacing.xs),
                        const _Bar(color: AppColors.lime, height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  style: AppTextStyles.chip.copyWith(
                    color: palette.textPrimary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
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

class _Bar extends StatelessWidget {
  const _Bar({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
    );
  }
}
