import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/state/prefs.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import '../data/auth_service.dart';
import 'widgets/auth_scaffold.dart';

/// Email + password sign in (Supabase Auth), plus Google / Facebook.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _submitted = false;
  bool _busy = false;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _userInvalid => _submitted && _user.text.trim().isEmpty;
  bool get _passwordInvalid => _submitted && _password.text.isEmpty;

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_user.text.trim().isEmpty || _password.text.isEmpty || _busy) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await AuthService.signInWithPassword(_user.text.trim(), _password.text);
      if (mounted) context.go(AppRoutes.home);
    } on AuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authFailed(e.message))));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.loadErrorBody)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      onBack: authBack(context, AppRoutes.languageSelect),
      children: [
        AuthHeading(title: l10n.signInTitle, body: l10n.signInBody),
        const SizedBox(height: AppSpacing.s14),
        const SocialSignInRow(),
        const SizedBox(height: AppSpacing.s14),
        OrDivider(text: l10n.signInDivider),
        const SizedBox(height: AppSpacing.s14),
        AutofillGroup(
          child: Column(
            children: [
              AppTextField(
                label: l10n.usernameOrEmail,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.person_outline_rounded,
                controller: _user,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                errorText: _userInvalid ? l10n.errUsernameOrEmail : null,
              ),
              const SizedBox(height: AppSpacing.s14),
              AppTextField(
                label: l10n.password,
                icon: Icons.lock_outline_rounded,
                controller: _password,
                obscurable: true,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                errorText: _passwordInvalid ? l10n.errPassword : null,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.forgotPassword),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lime,
              minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
              textStyle: AppTextStyles.chip,
            ),
            child: Text(l10n.forgotPassword),
          ),
        ),
        PrimaryButton(
          label: l10n.signIn,
          onPressed: _busy ? null : _submit,
        ),
        const SizedBox(height: AppSpacing.xs),
        AuthSwitchPrompt(
          prompt: l10n.newToApp,
          action: l10n.createAccount,
          onTap: () => context.push(AppRoutes.signUp),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Prefs.markOnboarded();
              context.go(AppRoutes.home);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.softOnDark,
              minimumSize: const Size(AppSizes.tapTarget, AppSizes.tapTarget),
            ),
            child: Text('${l10n.skip} · ${l10n.guest}'),
          ),
        ),
      ],
    );
  }
}
