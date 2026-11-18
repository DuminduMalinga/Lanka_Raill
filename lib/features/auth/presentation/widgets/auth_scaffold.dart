import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/page_scroll.dart';
import '../../../../core/widgets/photo_backdrop.dart';

/// Misty-railway backdrop + back/brand bar + bottom-weighted scroll body.
/// Shared by language select, sign in, sign up and forgot password.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.onBack,
    required this.children,
    this.backLabel,
    this.topSpacing = 0.22,
  });

  final VoidCallback onBack;
  final String? backLabel;
  final List<Widget> children;

  /// Fraction of the viewport height left clear above the form so the photo
  /// shows through (the design pins forms at ~28–35% from the top).
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gap = MediaQuery.sizeOf(context).height * topSpacing;
    return Scaffold(
      backgroundColor: AppColors.forestDeep,
      resizeToAvoidBottomInset: true,
      body: PhotoBackdrop(
        semanticLabel: l10n.mistyImageAlt,
        child: SafeArea(
          child: Column(
            children: [
              HeroTopBar(
                onBack: onBack,
                backLabel: backLabel,
                center: const AppBrand(),
              ),
              Expanded(
                child: FillScroll(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.heroGutter,
                    0,
                    AppSpacing.heroGutter,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: gap),
                      const Spacer(),
                      ...children,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large white heading + soft body copy used at the top of auth forms.
class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
  });

  final String title;
  final String body;

  /// Optional lime secondary line (language screen's Sinhala title).
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: AppTextStyles.h1.copyWith(color: AppColors.white),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s6),
          Text(
            subtitle!,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.lime,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.s6),
        Text(
          body,
          style: AppTextStyles.body.copyWith(color: AppColors.softOnDark),
        ),
      ],
    );
  }
}

/// Google / Facebook buttons side by side.
class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: l10n.google,
            semanticLabel: l10n.continueWithGoogle,
            badge: 'G',
            badgeColor: AppColors.white,
            badgeForeground: AppColors.google,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(width: AppSpacing.s10),
        Expanded(
          child: _SocialButton(
            label: l10n.facebook,
            semanticLabel: l10n.continueWithFacebook,
            badge: 'f',
            badgeColor: AppColors.facebook,
            badgeForeground: AppColors.white,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.semanticLabel,
    required this.badge,
    required this.badgeColor,
    required this.badgeForeground,
    required this.onPressed,
  });

  final String label;
  final String semanticLabel;
  final String badge;
  final Color badgeColor;
  final Color badgeForeground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: AppColors.glass,
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.glassStrong),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: badgeForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.white,
                    ),
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

/// "—— or sign in with username ——"
class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(
      child: Divider(color: AppColors.hairlineOnDark, height: 1),
    );
    return Row(
      children: [
        line,
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.mutedOnDark,
              ),
            ),
          ),
        ),
        line,
      ],
    );
  }
}

/// "New to CeylonGO? Create account" style prompt with a lime link.
class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: AppTextStyles.body.copyWith(color: AppColors.softOnDark),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.lime,
            minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
            textStyle: AppTextStyles.buttonSmall,
          ),
          child: Text(action),
        ),
      ],
    );
  }
}

/// Default back behaviour for auth screens.
VoidCallback authBack(BuildContext context, String fallback) =>
    popOrGo(context, fallback);
