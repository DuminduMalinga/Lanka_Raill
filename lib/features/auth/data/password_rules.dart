/// The password rules, kept in one place. The Supabase project enforces the
/// same rules on the server (Authentication > Providers > Email), so a
/// modified app cannot get around them.
const int minPasswordLength = 10;

bool _hasLetter(String s) => RegExp('[A-Za-z]').hasMatch(s);
bool _hasDigit(String s) => RegExp('[0-9]').hasMatch(s);

/// At least [minPasswordLength] characters, with a letter and a number.
bool isAcceptablePassword(String password) =>
    password.length >= minPasswordLength &&
    _hasLetter(password) &&
    _hasDigit(password);

/// What is still missing from [password], for a live hint while typing.
enum PasswordGap { tooShort, needsLetter, needsDigit, none }

PasswordGap passwordGap(String password) {
  if (password.length < minPasswordLength) return PasswordGap.tooShort;
  if (!_hasDigit(password)) return PasswordGap.needsDigit;
  if (!_hasLetter(password)) return PasswordGap.needsLetter;
  return PasswordGap.none;
}
