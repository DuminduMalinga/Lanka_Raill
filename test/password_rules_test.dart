import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/features/auth/data/password_rules.dart';

void main() {
  test('needs 10 characters, a letter and a number', () {
    expect(isAcceptablePassword('abcdefgh12'), isTrue);
    expect(isAcceptablePassword('Train2Ella!'), isTrue);
    expect(isAcceptablePassword('abcdefg12'), isFalse, reason: '9 characters');
    expect(isAcceptablePassword('abcdefghij'), isFalse, reason: 'no number');
    expect(isAcceptablePassword('1234567890'), isFalse, reason: 'no letter');
    expect(isAcceptablePassword(''), isFalse);
  });

  test('says what is missing, shortest problem first', () {
    expect(passwordGap('abc1'), PasswordGap.tooShort);
    expect(passwordGap('abcdefghij'), PasswordGap.needsDigit);
    expect(passwordGap('1234567890'), PasswordGap.needsLetter);
    expect(passwordGap('abcdefgh12'), PasswordGap.none);
  });
}
