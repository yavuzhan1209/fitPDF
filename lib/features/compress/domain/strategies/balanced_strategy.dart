import 'dart:typed_data';
import '../helpers/pdf_parser.dart';
import '../helpers/jpeg_resampler.dart';

/// ⚡ Balanced Strateji
/// Tüm görsel formatları sıkıştır — Ctrl+F ✅ | ~%40-70 küçülme
class BalancedStrategy {
  static const int _quality = 60;
  final void Function(double, String)? onProgress;
  BalancedStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.05, 'PDF yapısı okunuyor...');
    final parser = PdfParser(input);

    _emit(0.15, 'Metadata temizleniyor...');
    _cleanMetadata(parser);

    _emit(0.35, 'Görseller sıkıştırılıyor...');
    await _compressImages(parser);

    _emit(0.80, 'Fontlar optimize ediliyor...');
    _optimizeFonts(parser);

    _emit(0.93, 'Dosya yazılıyor...');
    final result = parser.build();

    _emit(1.00, 'Tamamlandı ✓');
    return result;
  }

  void _cleanMetadata(PdfParser parser) {
    parser.objects.removeWhere((o) => o.isMetadata);
    parser.objects.removeWhere((o) => o.hasEmptyStream);
    const fields = [
      r'/Author\s*\([^)]*\)', r'/Creator\s*\([^)]*\)',
      r'/Producer\s*\([^)]*\)', r'/Keywords\s*\([^)]*\)',
      r'/Subject\s*\([^)]*\)', r'/CreationDate\s*\([^)]*\)',
      r'/ModDate\s*\([^)]*\)', r'/Trapped\s*/\w+',
      r'/Author\s*<[^>]*>', r'/Creator\s*<[^>]*>',
      r'/Producer\s*<[^>]*>', r'/CreationDate\s*<[^>]*>',
      r'/ModDate\s*<[^>]*>',
    ];
    for (final obj in parser.objects) {
      if (!obj.content.contains('<<')) continue;
      for (final f in fields) {
        obj.content = obj.content.replaceAll(RegExp(f), '');
      }
    }
  }

  Future<void> _compressImages(PdfParser parser) async {
    final images = parser.objects.where((o) => o.isCompressibleImage).toList();
    for (int i = 0; i < images.length; i++) {
      final obj = images[i];
      _emit(0.35 + (0.45 * i / images.length.clamp(1, 9999)),
          'Görsel sıkıştırılıyor... ($i/${images.length})');

      final bytes = obj.extractStreamBytes();
      if (bytes == null || bytes.length < 100) continue;
      if (!JpegResampler.isImage(bytes)) continue;

      final compressed = JpegResampler.resample(bytes, quality: _quality);

      // Sadece küçüldüyse değiştir
      if (compressed.length < bytes.length) {
        obj.replaceStreamWithJpeg(compressed);
      }
    }
  }

  void _optimizeFonts(PdfParser parser) {
    for (final obj in parser.objects) {
      if (!obj.isFont) continue;
      obj.content = obj.content.replaceAll(
          RegExp(r'/ToUnicode\s+\d+\s+\d+\s+R'), '');
    }
  }

  void _emit(double p, String msg) => onProgress?.call(p, msg);
}
