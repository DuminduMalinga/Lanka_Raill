import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lankarail/data/image_type.dart';

Uint8List b(List<int> v) => Uint8List.fromList(v);

void main() {
  test('recognises JPEG, PNG and WebP by their bytes', () {
    expect(detectImageType(b([0xFF, 0xD8, 0xFF, 0xE0, 0, 0x10])), 'image/jpeg');
    expect(
      detectImageType(b([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0])),
      'image/png',
    );
    expect(
      detectImageType(b([0x52, 0x49, 0x46, 0x46, 1, 2, 3, 4, 0x57, 0x45, 0x42, 0x50])),
      'image/webp',
    );
  });

  test('rejects anything else, whatever it is called', () {
    expect(detectImageType(b('<html><script>alert(1)</script>'.codeUnits)), isNull);
    expect(detectImageType(b('GIF89a'.codeUnits)), isNull);
    expect(detectImageType(Uint8List(0)), isNull);
    // RIFF but not WebP (for example a WAV file).
    expect(
      detectImageType(b([0x52, 0x49, 0x46, 0x46, 1, 2, 3, 4, 0x57, 0x41, 0x56, 0x45])),
      isNull,
    );
    // Too short to be a PNG.
    expect(detectImageType(b([0x89, 0x50, 0x4E])), isNull);
  });
}
