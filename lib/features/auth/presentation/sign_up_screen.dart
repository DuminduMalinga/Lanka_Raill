import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/state/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../data/auth_service.dart';
import '../data/auth_errors.dart';
import '../data/password_rules.dart';
import 'widgets/auth_scaffold.dart';

/// Account creation form with inline UI validation (no auth calls).
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final _email = TextEditingController();
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitted = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _user.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _emailOk => _emailPattern.hasMatch(_email.text.trim());
  bool get _userOk => _user.text.trim().length >= 3;
  bool get _passwordOk => isAcceptablePassword(_password.text);
  bool get _matches =>
      _confirm.text.isNotEmpty && _confirm.text == _password.text;

  String? _strengthHint(AppLocalizations l10n) {
    final pw = _password.text;
    if (pw.isEmpty || (_submitted && !_passwordOk)) return null;
    return switch (passwordGap(pw)) {
      PasswordGap.tooShort => l10n.pwTooShort,
      PasswordGap.needsDigit => l10n.pwAddNumber,
      PasswordGap.needsLetter => l10n.pwAddLetter,
      PasswordGap.none => l10n.pwStrong,
    };
  }

  Future<void> _submit(bool agreed) async {
    setState(() => _submitted = true);
    if (!(_emailOk && _userOk && _passwordOk && _matches && agreed) || _busy) {
      return;
    }
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final started = await AuthService.signUp(
        email: _email.text.trim(),
        password: _password.text,
        displayName: _user.text.trim(),
      );
      if (!mounted) return;
      if (started) {
        context.go(AppRoutes.home);
      } else {
        messenger.showSnackBar(SnackBar(content: Text(l10n.checkEmailConfirm)));
        context.go(AppRoutes.signIn);
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(authErrorMessage(l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final agreed = ref.watch(uiToggleProvider(UiToggles.agreeTerms));
    final hint = _strengthHint(l10n);
    final showMismatch = (_submitted || _confirm.text.isNotEmpty) && !_matches;
    void refresh(String _) => setState(() {});

    return AuthScaffold(
      onBack: authBack(context, AppRoutes.signIn),
      backLabel: l10n.backToSignIn,
      topSpacing: 0.04,
      children: [
        AuthHeading(title: l10n.signUpTitle, body: l10n.signUpBody),
        const SizedBox(height: AppSpacing.s10),
        const SocialSignInRow(),
        const SizedBox(height: AppSpacing.s10),
        OrDivider(text: l10n.signUpDivider),
        const SizedBox(height: AppSpacing.s10),
        AppTextField(
          label: l10n.email,
          icon: Icons.mail_outline_rounded,
          controller: _email,
          onChanged: refresh,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: _submitted && !_emailOk ? l10n.errEmail : null,
        ),
        const SizedBox(height: AppSpacing.s10),
        AppTextField(
          label: l10n.username,
          icon: Icons.person_outline_rounded,
          controller: _user,
          onChanged: refresh,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newUsername],
          errorText: _submitted && !_userOk ? l10n.errUsername : null,
        ),
        const SizedBox(height: AppSpacing.s10),
        AppTextField(
          label: l10n.password,
          icon: Icons.lock_outline_rounded,
          controller: _password,
          obscurable: true,
          onChanged: refresh,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          errorText: _submitted && !_passwordOk ? l10n.errPasswordLength : null,
        ),
        if (hint != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              top: AppSpacing.xs,
            ),
            child: Text(
              hint,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.mutedOnDark,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.s10),
        AppTextField(
          label: l10n.confirmPassword,
          icon: Icons.lock_outline_rounded,
          controller: _confirm,
          obscurable: true,
          onChanged: refresh,
          textInputAction: TextInputAction.done,
          showMatchBadge: _matches,
          errorText: showMismatch ? l10n.errPasswordMatch : null,
        ),
        const SizedBox(height: AppSpacing.xs),
        _AgreeCheckbox(
          label: l10n.agreeTerms,
          value: agreed,
          onChanged: () => ref
              .read(uiToggleProvider(UiToggles.agreeTerms).notifier)
              .toggle(),
        ),
        if (_submitted && !agreed)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xxxl),
            child: Text(
              l10n.errAgree,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.errorOnDark,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.s10),
        PrimaryButton(
          label: l10n.createAccount,
          onPressed: _busy ? null : () => _submit(agreed),
        ),
        AuthSwitchPrompt(
          prompt: l10n.haveAccount,
          action: l10n.signIn,
          onTap: authBack(context, AppRoutes.signIn),
        ),
      ],
    );
  }
}

class _AgreeCheckbox extends StatelessWidget {
  const _AgreeCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onChanged,
        borderRadius: AppRadii.cardAll,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.tapTarget),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppDurations.fast,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: value ? AppColors.lime : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: value
                        ? AppColors.lime
                        : AppColors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: value
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppColors.ink,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softOnDark,
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
