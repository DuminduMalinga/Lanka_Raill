import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';

/// Thin wrapper over Supabase Auth for the social sign-in buttons.
class AuthService {
  AuthService._();

  static SupabaseClient get _client => Supabase.instance.client;

  static Session? get currentSession => _client.auth.currentSession;

  static Stream<AuthState> get onAuthStateChange =>
      _client.auth.onAuthStateChange;

  /// Opens the provider's login page in the browser; the session arrives
  /// through [onAuthStateChange] once the deep link brings the user back.
  static Future<bool> signInWith(OAuthProvider provider) {
    return _client.auth.signInWithOAuth(
      provider,
      redirectTo: SupabaseConfig.authRedirect,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  static Future<void> signOut() =>
      _client.auth.signOut(scope: SignOutScope.local);
}
