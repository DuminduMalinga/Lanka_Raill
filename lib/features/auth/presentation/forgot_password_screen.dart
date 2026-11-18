import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/buttons.dart';
import 'widgets/auth_scaffold.dart';

/// Reset-password form and its success state (UI only).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.showSuccess = false});

  /// Start on the "Password updated" state (previews / tests).
  final bool showSuccess;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitted = false;
  late bool _done = widget.showSuccess;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _userOk => _user.text.trim().length >= 3;
  bool get _passwordOk => _password.text.length >= 8;
  bool get _matches =>
      _confirm.text.isNotEmpty && _confirm.text == _password.text;

  void _reset() {
    setState(() {
      _submitted = true;
      _done = _userOk && _passwordOk && _matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    final back = authBack(context, AppRoutes.signIn);
    return AuthScaffold(
      onBack: back,
      backLabel: context.l10n.backToSignIn,
      topSpacing: _done ? 0.3 : 0.2,
      children: _done ? _success(back) : _form(back),
    );
  }

  List<Widget> _form(VoidCallback back) {
    final l10n = context.l10n;
    void refresh(String _) => setState(() {});
    return [
      AuthHeading(title: l10n.resetTitle, body: l10n.resetBody),
      const SizedBox(height: AppSpacing.lg),
      AppTextField(
        label: l10n.usernameOrEmail,
        icon: Icons.person_outline_rounded,
        controller: _user,
        onChanged: refresh,
        autofillHints: const [AutofillHints.username],
        errorText: _submitted && !_userOk ? l10n.errUsernameOrEmail : null,
      ),
      const SizedBox(height: AppSpacing.md),
      AppTextField(
        label: l10n.newPassword,
        icon: Icons.lock_outline_rounded,
        controller: _password,
        obscurable: true,
        onChanged: refresh,
        autofillHints: const [AutofillHints.newPassword],
        errorText: _submitted && !_passwordOk ? l10n.errPasswordLength : null,
      ),
      const SizedBox(height: AppSpacing.md),
      AppTextField(
        label: l10n.confirmNewPassword,
        icon: Icons.lock_outline_rounded,
        controller: _confirm,
        obscurable: true,
        onChanged: refresh,
        showMatchBadge: _matches,
        errorText: (_submitted || _confirm.text.isNotEmpty) && !_matches
            ? l10n.errPasswordMatch
            : null,
      ),
      const SizedBox(height: AppSpacing.lg),
      PrimaryButton(label: l10n.resetPassword, onPressed: _reset),
      AuthSwitchPrompt(
        prompt: l10n.remembered,
        action: l10n.signIn,
        onTap: back,
      ),
    ];
  }

  List<Widget> _success(VoidCallback back) {
    final l10n = context.l10n;
    return [
      Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.lime,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 36,
            color: AppColors.ink,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
      Semantics(
        header: true,
        liveRegion: true,
        child: Text(
          l10n.passwordUpdated,
          textAlign: TextAlign.center,
          style: AppTextStyles.h2.copyWith(color: AppColors.white),
        ),
      ),
      const SizedBox(height: AppSpacing.s14),
      Text(
        l10n.passwordUpdatedBody,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(color: AppColors.softOnDark),
      ),
      const SizedBox(height: AppSpacing.xxl),
      PrimaryButton(label: l10n.backToSignIn, onPressed: back),
      const Spacer(),
    ];
  }
}
