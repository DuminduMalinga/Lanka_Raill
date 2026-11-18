import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The three previewable states every data-driven screen exposes.
///
/// When real data is wired in, map the data source's status to this enum
/// (e.g. `AsyncValue.loading` → [loading], empty list → [empty]).
enum UiViewState { content, empty, loading }

/// Global preview switch for data-driven screens.
///
/// Screens read this unless a `viewState` is passed to their constructor.
/// In debug builds the floating preview chip cycles through the values.
final uiViewStateProvider = NotifierProvider<UiViewStateNotifier, UiViewState>(
  UiViewStateNotifier.new,
);

class UiViewStateNotifier extends Notifier<UiViewState> {
  @override
  UiViewState build() => UiViewState.content;

  void set(UiViewState value) => state = value;

  void cycle() {
    const values = UiViewState.values;
    state = values[(state.index + 1) % values.length];
  }
}
