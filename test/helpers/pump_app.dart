import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/app.dart';
import 'package:lankarail/core/state/app_preferences.dart';
import 'package:lankarail/core/state/ui_view_state.dart';
import 'package:lankarail/core/widgets/app_map.dart';
import 'package:material_ui/material_ui.dart';

/// Pins the global preview state for a test.
class FixedViewState extends UiViewStateNotifier {
  FixedViewState(this.value);
  final UiViewState value;

  @override
  UiViewState build() => value;
}

/// Pins the app language for a test.
class FixedLanguage extends AppLanguageNotifier {
  FixedLanguage(this.value);
  final AppLanguage value;

  @override
  AppLanguage build() => value;
}

/// Pumps the full app (router, theme, l10n) starting at [location].
Future<void> pumpRoute(
  WidgetTester tester,
  String location, {
  UiViewState state = UiViewState.content,
  AppLanguage language = AppLanguage.english,
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // No network tiles in tests.
        mapTileUrlProvider.overrideWithValue(null),
        uiViewStateProvider.overrideWith(() => FixedViewState(state)),
        appLanguageProvider.overrideWith(() => FixedLanguage(language)),
      ],
      child: CeylonGoApp(initialLocation: location),
    ),
  );
  // Let localizations load and the first route build.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
