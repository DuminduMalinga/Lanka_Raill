import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Glass text field with the label inside, used on dark auth screens.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.onChanged,
    this.errorText,
    this.obscurable = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.showMatchBadge = false,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool obscurable;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  /// Shows a lime check badge (e.g. when confirm-password matches).
  final bool showMatchBadge;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: AppSizes.fieldHeight),
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: hasError
                  ? AppColors.errorOnDark.withValues(alpha: 0.8)
                  : AppColors.glassBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: AppSizes.icon,
                color: AppColors.mutedOnDark,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _field()),
              if (widget.showMatchBadge) const _MatchBadge(),
              if (widget.obscurable)
                IconButton(
                  tooltip: context.l10n.showHidePassword,
                  onPressed: () => setState(() => _obscured = !_obscured),
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: AppSizes.icon,
                    color: AppColors.mutedOnDark,
                  ),
                )
              else
                const SizedBox(width: AppSpacing.lg),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              top: AppSpacing.xs,
            ),
            child: Text(
              widget.errorText!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.errorOnDark,
              ),
            ),
          ),
      ],
    );
  }

  Widget _field() {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscurable && _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      style: AppTextStyles.input.copyWith(color: AppColors.white),
      cursorColor: AppColors.lime,
      decoration: InputDecoration(
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: AppTextStyles.caption.copyWith(
          color: AppColors.mutedOnDark,
          fontSize: 13,
        ),
        floatingLabelStyle: AppTextStyles.label.copyWith(
          color: AppColors.mutedOnDark,
        ),
        isDense: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: AppColors.lime,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_rounded, size: 14, color: AppColors.ink),
    );
  }
}

/// Multiline light text area (Help & feedback).
class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.minLines = 3,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.captionStrong.copyWith(color: palette.textMuted),
        ),
        const SizedBox(height: AppSpacing.s6),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: minLines + 3,
          style: AppTextStyles.body.copyWith(color: palette.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body.copyWith(color: palette.textMuted),
            filled: true,
            fillColor: palette.surface,
            contentPadding: const EdgeInsets.all(AppSpacing.s14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.cardLg),
              borderSide: BorderSide(color: palette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.cardLg),
              borderSide: BorderSide(color: palette.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
