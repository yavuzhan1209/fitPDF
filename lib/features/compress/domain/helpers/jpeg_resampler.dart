import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Evrensel görsel sıkıştırıcı.
///
/// Desteklenen formatlar:
///   JPEG (DCTDecode), PNG (FlateDecode), JPEG2000 (JPXDecode),
///   GIF, BMP, TIFF, WebP — image paketi ne decode edebiliyorsa
///
/// Tüm formatlar → JPEG olarak çıkar (her zaman daha küçük)
class JpegResampler {
  /// [quality] 0-100. 85=hafif, 60=dengeli, 30=maksimum
  static List<int> resample(List<int> rawBytes, {required int quality}) {
    try {
      final bytes = rawBytes is Uint8List
          ? rawBytes
          : Uint8List.fromList(rawBytes);

      final decoded = img.decodeImage(bytes);
      if (decoded == null) return rawBytes; // decode edilemedi → orijinal

      return img.encodeJpg(decoded, quality: quality);
    } catch (_) {
      return rawBytes; // hata → orijinal
    }
  }

  /// Sadece JPEG mi kontrol et (FFD8FF magic bytes)
  static bool isJpeg(List<int> bytes) =>
      bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF;

  /// PNG mi kontrol et (89504E47 magic bytes)
  static bool isPng(List<int> bytes) =>
      bytes.length >= 4 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47;

  /// Herhangi bir görsel mi (en az bir magic bytes eşleşmesi)
  static bool isImage(List<int> bytes) =>
      isJpeg(bytes) || isPng(bytes) || _isJpeg2000(bytes) || _isGif(bytes);

  static bool _isJpeg2000(List<int> b) =>
      b.length >= 4 && b[0] == 0x00 && b[1] == 0x00 && b[2] == 0x00 && b[3] == 0x0C;

  static bool _isGif(List<int> b) =>
      b.length >= 3 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46;
}
