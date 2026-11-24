import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/core/l10n/gen/app_localizations_en.dart';
import 'package:lankarail/features/auth/data/auth_errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final l10n = AppLocalizationsEn();
  String msg(Object e) => authErrorMessage(l10n, e);

  test('known codes become plain messages', () {
    expect(
      msg(const AuthApiException('x', statusCode: '400', code: 'invalid_credentials')),
      l10n.authErrInvalidCredentials,
    );
    expect(
      msg(const AuthApiException('x', statusCode: '400', code: 'email_not_confirmed')),
      l10n.authErrEmailNotConfirmed,
    );
    expect(
      msg(const AuthApiException('x', statusCode: '422', code: 'user_already_exists')),
      l10n.authErrAccountExists,
    );
    expect(
      msg(const AuthApiException('x', statusCode: '400', code: 'flow_state_expired')),
      l10n.authErrLinkExpired,
    );
  });

  test('rate limits and network failures are recognised', () {
    expect(
      msg(const AuthApiException('x', statusCode: '429')),
      l10n.authErrRateLimited,
    );
    expect(
      msg(AuthRetryableFetchException(message: 'SocketException: no route')),
      l10n.authErrOffline,
    );
  });

  test('older servers without a code still map wrong passwords', () {
    expect(
      msg(const AuthApiException('Invalid login credentials', statusCode: '400')),
      l10n.authErrInvalidCredentials,
    );
  });

  test('server text and exception details are never shown', () {
    const secret = 'duplicate key value violates constraint users_pkey';
    final shown = msg(const AuthApiException(secret, statusCode: '500', code: 'unexpected_failure'));
    expect(shown, l10n.authErrGeneric);
    expect(shown, isNot(contains('constraint')));
    expect(msg(StateError('internal detail')), l10n.authErrGeneric);
  });
}
