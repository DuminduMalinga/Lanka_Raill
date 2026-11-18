import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Rounded search field used on station, directory and help screens.
///
/// Named `AppSearchBar` to avoid clashing with Material's `SearchBar`.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: AppSizes.icon,
            color: palette.textMuted,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: (value) {
                setState(() {});
                widget.onChanged?.call(value);
              },
              textInputAction: TextInputAction.search,
              style: AppTextStyles.input.copyWith(color: palette.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.input.copyWith(
                  color: palette.textMuted,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              tooltip: context.l10n.clearSearch,
              onPressed: () {
                _controller.clear();
                setState(() {});
                widget.onChanged?.call('');
              },
              icon: Icon(
                Icons.close_rounded,
                size: AppSizes.icon,
                color: palette.textMuted,
              ),
            )
          else
            const SizedBox(width: AppSpacing.lg),
        ],
      ),
    );
  }
}
