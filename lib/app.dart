import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

import 'core/l10n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/state/app_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_service.dart';

/// Root widget: theme, localisation and routing.
class CeylonGoApp extends ConsumerStatefulWidget {
  const CeylonGoApp({super.key, this.initialLocation = AppRoutes.splash});

  /// First route shown (tests/previews start on a specific screen).
  final String initialLocation;

  @override
  ConsumerState<CeylonGoApp> createState() => _CeylonGoAppState();
}

class _CeylonGoAppState extends ConsumerState<CeylonGoApp> {
  late final GoRouter _router = createAppRouter(
    initialLocation: widget.initialLocation,
  );

  StreamSubscription<void>? _authSub;

  @override
  void initState() {
    super.initState();
    // Coming back from the Google/Facebook browser login → go to Home.
    _authSub = AuthService.onAuthStateChange.listen(
      (state) {
        if (state.event == AuthChangeEvent.signedIn && state.session != null) {
          _router.go(AppRoutes.home);
        }
      },
      onError: (Object _) {}, // shown by the sign-in screen
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final largerText = ref.watch(uiToggleProvider(UiToggles.largerText));

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      routerConfig: _router,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final scaled = largerText
            ? media.copyWith(
                textScaler: TextScaler.linear(
                  (media.textScaler.scale(1) * 1.15).clamp(1.0, 2.0),
                ),
              )
            : media;
        return MediaQuery(
          data: scaled,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
