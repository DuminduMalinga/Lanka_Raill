import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/data/ceylon_repository.dart';
import 'package:lankarail/core/router/app_routes.dart';
import 'package:material_ui/material_ui.dart';
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

  testWidgets('feedback needs a message, then is sent', (tester) async {
    final repo = FakeCeylonRepository();
    await pumpRoute(tester, AppRoutes.helpFeedback, repository: repo);

    final send = find.text('Send feedback').last;
    await tester.ensureVisible(send);
    await tester.tap(send);
    await tester.pump();
    expect(find.text('Write a message first.'), findsOneWidget);
    expect(repo.sentFeedback, isEmpty);

    await tester.enterText(find.byType(TextField).last, 'Great app');
    await tester.tap(send);
    await tester.pump();
    expect(repo.sentFeedback, ['Great app']);
  });

  testWidgets('says so when feedback is rate limited', (tester) async {
    final repo = FakeCeylonRepository()
      ..feedbackError = const FeedbackRateLimitedException();
    await pumpRoute(tester, AppRoutes.helpFeedback, repository: repo);

    await tester.enterText(find.byType(TextField).last, 'Another one');
    final send = find.text('Send feedback').last;
    await tester.ensureVisible(send);
    await tester.tap(send);
    await tester.pump();
    expect(find.textContaining('sent a lot of feedback'), findsOneWidget);
    expect(repo.sentFeedback, isEmpty);
  });
}
