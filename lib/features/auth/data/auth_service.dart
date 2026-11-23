import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';

/// Thin wrapper over Supabase Auth (email/password and social sign-in).
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

  static Future<void> signInWithPassword(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);

  /// Returns true when a session started immediately (email confirmation
  /// off); false when the user must confirm their email first.
  static Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: SupabaseConfig.authRedirect,
      data: {
        if (displayName != null && displayName.isNotEmpty)
          'display_name': displayName,
      },
    );
    return res.session != null;
  }

  /// Emails a reset link that opens the app on the "new password" form.
  static Future<void> sendPasswordReset(String email) =>
      _client.auth.resetPasswordForEmail(
        email,
        redirectTo: SupabaseConfig.authRedirect,
      );

  /// Sets a new password for the signed-in (or recovering) user.
  static Future<void> updatePassword(String password) =>
      _client.auth.updateUser(UserAttributes(password: password));

  static Future<void> signOut() =>
      _client.auth.signOut(scope: SignOutScope.local);
}
