import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons.dart';
import '../../auth/presentation/widgets/auth_scaffold.dart';

/// First-run language picker (English / Sinhala).
class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(appLanguageProvider);
    void pick(AppLanguage language) =>
        ref.read(appLanguageProvider.notifier).select(language);

    return AuthScaffold(
      onBack: authBack(context, AppRoutes.onboarding),
      topSpacing: 0.18,
      children: [
        AuthHeading(
          title: l10n.languageTitle,
          subtitle: l10n.languageTitleAlt,
          body: l10n.languageBody,
        ),
        const SizedBox(height: AppSpacing.s14),
        Semantics(
          label: l10n.appLanguage,
          child: Column(
            children: [
              DarkLanguageOption(
                glyph: 'Aa',
                title: l10n.languageEnglish,
                subtitle: l10n.languageEnglishSub,
                selected: selected == AppLanguage.english,
                onTap: () => pick(AppLanguage.english),
              ),
              const SizedBox(height: AppSpacing.md),
              DarkLanguageOption(
                glyph: 'අ',
                title: l10n.languageSinhala,
                subtitle: l10n.languageSinhalaSub,
                selected: selected == AppLanguage.sinhala,
                onTap: () => pick(AppLanguage.sinhala),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _TamilNote(text: l10n.languageTamilNote),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: l10n.continueLabel,
          onPressed: () => context.push(AppRoutes.signIn),
        ),
      ],
    );
  }
}

/// Glass radio card used on the dark language screen.
class DarkLanguageOption extends StatelessWidget {
  const DarkLanguageOption({
    super.key,
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String glyph;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: selected
            ? AppColors.lime.withValues(alpha: 0.12)
            : AppColors.white.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.cardXl),
          side: BorderSide(
            color: selected
                ? AppColors.lime
                : AppColors.white.withValues(alpha: 0.16),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                _Glyph(glyph: glyph),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.optionTitle.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.softOnDark,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.ink,
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

class _Glyph extends StatelessWidget {
  const _Glyph({required this.glyph});

  final String glyph;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 54,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.lime.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(AppSpacing.lg),
        ),
        child: Text(
          glyph,
          style: AppTextStyles.h4.copyWith(
            color: AppColors.lime,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TamilNote extends StatelessWidget {
  const _TamilNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 15,
          color: AppColors.mutedOnDark,
        ),
        const SizedBox(width: AppSpacing.s6),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.mutedOnDark),
          ),
        ),
      ],
    );
  }
}
