import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../state/ui_view_state.dart';
import '../theme/app_spacing.dart';

/// Switches between the content / empty / loading widgets of a screen.
///
/// Pass [state] to force a state (tests, previews); otherwise the global
/// [uiViewStateProvider] preview switch is used.
class UiStateView extends ConsumerWidget {
  const UiStateView({
    super.key,
    this.state,
    required this.content,
    required this.empty,
    required this.loading,
  });

  final UiViewState? state;
  final WidgetBuilder content;
  final WidgetBuilder empty;
  final WidgetBuilder loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UiViewState resolved = state ?? ref.watch(uiViewStateProvider);
    return AnimatedSwitcher(
      duration: AppDurations.fast,
      child: KeyedSubtree(
        key: ValueKey(resolved),
        child: switch (resolved) {
          UiViewState.content => content(context),
          UiViewState.empty => empty(context),
          UiViewState.loading => loading(context),
        },
      ),
    );
  }
}
