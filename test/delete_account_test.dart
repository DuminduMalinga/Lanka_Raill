import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/core/router/app_routes.dart';
import 'package:lankarail/data/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/fake_repository.dart';
import 'helpers/pump_app.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-key',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
        autoRefreshToken: false,
        detectSessionInUri: false,
      ),
      debug: false,
    );
  });

  final signedIn = [isSignedInProvider.overrideWithValue(true)];

  Future<void> openDeleteDialog(WidgetTester tester) async {
    final tile = find.text('Delete account');
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('asks first and does nothing when cancelled', (tester) async {
    final repo = FakeCeylonRepository();
    await pumpRoute(
      tester,
      AppRoutes.profile,
      repository: repo,
      overrides: signedIn,
    );

    await openDeleteDialog(tester);
    expect(find.text('Delete your account?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.deleteAccountCalls, 0);
    expect(find.text('Delete your account?'), findsNothing);
  });

  testWidgets('deletes the account once confirmed', (tester) async {
    final repo = FakeCeylonRepository();
    await pumpRoute(
      tester,
      AppRoutes.profile,
      repository: repo,
      overrides: signedIn,
    );

    await openDeleteDialog(tester);
    await tester.tap(find.text('Delete').last);
    // The local sign-out talks to the real Supabase client, which needs real
    // (not fake) time to finish.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(repo.deleteAccountCalls, 1);
    expect(find.text('Your account has been deleted.'), findsOneWidget);
  });

  testWidgets('says so and does not sign out when deletion fails', (
    tester,
  ) async {
    final repo = FakeCeylonRepository()
      ..deleteAccountError = Exception('network');
    await pumpRoute(
      tester,
      AppRoutes.profile,
      repository: repo,
      overrides: signedIn,
    );

    await openDeleteDialog(tester);
    await tester.tap(find.text('Delete').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(repo.deleteAccountCalls, 1);
    expect(find.textContaining("Couldn't delete your account"), findsOneWidget);
    expect(find.text('Your account has been deleted.'), findsNothing);
  });

  testWidgets('guests do not see the option', (tester) async {
    await pumpRoute(tester, AppRoutes.profile);
    expect(find.text('Delete account'), findsNothing);
  });
}
