import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../state/ui_view_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Debug-only floating chip that cycles content → empty → loading for every
/// data-driven screen. Hidden in profile/release builds.
class PreviewStateSwitcher extends ConsumerWidget {
  const PreviewStateSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return child;
    final state = ref.watch(uiViewStateProvider);
    final l10n = context.l10n;
    final label = switch (state) {
      UiViewState.content => l10n.previewContent,
      UiViewState.empty => l10n.previewEmpty,
      UiViewState.loading => l10n.previewLoading,
    };
    return Stack(
      children: [
        child,
        Positioned(
          right: AppSpacing.md,
          top: MediaQuery.paddingOf(context).top + AppSpacing.huge + 24,
          child: Material(
            color: AppColors.ink.withValues(alpha: 0.82),
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: ref.read(uiViewStateProvider.notifier).cycle,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s6,
                ),
                child: Text(
                  l10n.previewState(label),
                  style: AppTextStyles.label.copyWith(color: AppColors.lime),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
