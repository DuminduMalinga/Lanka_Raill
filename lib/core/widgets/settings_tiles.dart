import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'section_header.dart';

/// Labelled group of rows inside a single rounded card.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) SectionLabel(title!),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: AppRadii.cardLgAll,
            border: Border.all(color: palette.border),
          ),
          child: ClipRRect(
            borderRadius: AppRadii.cardLgAll,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: palette.border),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Icon tile · title (+subtitle) · value · chevron.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.showChevron = true,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final titleColor = destructive ? AppColors.redChipFg : palette.textPrimary;
    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 66),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.s14,
            ),
            child: Row(
              children: [
                IconTile(
                  icon: icon,
                  background: destructive ? AppColors.redChipBg : null,
                  foreground: destructive ? AppColors.redChipFg : null,
                ),
                const SizedBox(width: AppSpacing.s14),
                Expanded(
                  child: _TitleBlock(
                    title: title,
                    subtitle: subtitle,
                    titleColor: titleColor,
                  ),
                ),
                if (value != null)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Text(
                        value!,
                        textAlign: TextAlign.end,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                    ),
                  ),
                if (showChevron && !destructive)
                  Icon(Icons.chevron_right_rounded, color: palette.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon tile · title + subtitle · [AppSwitch].
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.s14,
          ),
          child: Row(
            children: [
              IconTile(icon: icon),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: _TitleBlock(
                  title: title,
                  subtitle: subtitle,
                  titleColor: palette.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppSwitch(value: value, onChanged: onChanged, label: title),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.title,
    required this.titleColor,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppTextStyles.rowTitle.copyWith(color: titleColor)),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle!,
            style: AppTextStyles.caption.copyWith(
              color: context.palette.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// 48×28 pill switch from the design.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      toggled: value,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: AppSizes.tapTarget,
          child: Center(
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: 48,
              height: 28,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: value ? palette.primary : palette.segmentTrack,
                borderRadius: AppRadii.pillAll,
              ),
              child: AnimatedAlign(
                duration: AppDurations.fast,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.knob,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Radio-style option card (language / theme pickers on light screens).
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.titleStyle,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: AppCard(
          onTap: enabled ? onTap : null,
          radius: AppRadii.cardLg,
          borderColor: selected ? palette.primary : null,
          borderWidth: selected ? 2 : 1,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.s14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: (titleStyle ?? AppTextStyles.cardTitle).copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              trailing ?? _RadioDot(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: AppDurations.fast,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? palette.primary : Colors.transparent,
        border: Border.all(
          color: selected ? palette.primary : palette.border,
          width: 2,
        ),
      ),
      child: selected
          ? Icon(Icons.check_rounded, size: 14, color: palette.surface)
          : null,
    );
  }
}
