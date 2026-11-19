/// Supabase project settings. The publishable key is safe to ship in the app;
/// never put the service-role key here.
abstract final class SupabaseConfig {
  static const url = 'https://prcmausakhaswaidsamz.supabase.co';
  static const publishableKey =
      'sb_publishable_P8LoPwWGli64eCdJfLtWXA_OBC3YF5q';

  /// Deep link the OAuth flow returns to. Must be listed under
  /// Supabase → Authentication → URL Configuration → Redirect URLs.
  static const authRedirect = 'lk.hashtag.lankarail://login-callback/';
}
