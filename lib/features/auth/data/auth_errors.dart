import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/l10n/l10n.dart';

/// Turns a sign-in / sign-up / password failure into a short message for the
/// user. Server text and exception names are never shown: they can reveal
/// internals and mean nothing to the person using the app.
String authErrorMessage(AppLocalizations l10n, Object error) {
  // Network trouble: the library wraps these in a "retryable" exception.
  if (error is AuthRetryableFetchException) return l10n.authErrOffline;
  if (error is AuthWeakPasswordException) return l10n.authErrWeakPassword;
  if (error is AuthException) {
    if (error.statusCode == '429') return l10n.authErrRateLimited;
    switch (error.code) {
      case 'invalid_credentials':
        return l10n.authErrInvalidCredentials;
      case 'email_not_confirmed':
        return l10n.authErrEmailNotConfirmed;
      case 'user_already_exists':
      case 'email_exists':
        return l10n.authErrAccountExists;
      case 'weak_password':
        return l10n.authErrWeakPassword;
      case 'over_request_rate_limit':
      case 'over_email_send_rate_limit':
        return l10n.authErrRateLimited;
      case 'email_address_invalid':
      case 'validation_failed':
        return l10n.authErrInvalidEmail;
      case 'same_password':
        return l10n.authErrSamePassword;
      case 'flow_state_expired':
      case 'flow_state_not_found':
      case 'otp_expired':
      case 'bad_oauth_state':
      case 'bad_oauth_callback':
      case 'bad_code_verifier':
        return l10n.authErrLinkExpired;
      case 'user_banned':
        return l10n.authErrBlocked;
    }
    // Older servers answer with a message and no code.
    if (error.message.toLowerCase().contains('invalid login credentials')) {
      return l10n.authErrInvalidCredentials;
    }
  }
  return l10n.authErrGeneric;
}
