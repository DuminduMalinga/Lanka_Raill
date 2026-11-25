import 'dart:typed_data';

/// The largest profile photo the avatars bucket accepts (2 MB).
const int maxAvatarBytes = 2 * 1024 * 1024;

/// Works out whether [bytes] is a JPEG, PNG or WebP image by looking at the
/// file's first bytes, and returns its MIME type, or null for anything else.
///
/// The file name and the picker's reported type can be wrong or forged; this
/// looks at what the data really is.
String? detectImageType(Uint8List bytes) {
  bool startsWith(List<int> magic, [int offset = 0]) {
    if (bytes.length < offset + magic.length) return false;
    for (var i = 0; i < magic.length; i++) {
      if (bytes[offset + i] != magic[i]) return false;
    }
    return true;
  }

  if (startsWith(const [0xFF, 0xD8, 0xFF])) return 'image/jpeg';
  if (startsWith(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
    return 'image/png';
  }
  // WebP: "RIFF", 4 size bytes, then "WEBP".
  if (startsWith(const [0x52, 0x49, 0x46, 0x46]) &&
      startsWith(const [0x57, 0x45, 0x42, 0x50], 8)) {
    return 'image/webp';
  }
  return null;
}
