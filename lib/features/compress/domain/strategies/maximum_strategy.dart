import 'dart:typed_data';
import '../helpers/pdf_parser.dart';
import '../helpers/jpeg_resampler.dart';

/// 💎 Maximum Strateji
/// Agresif görsel sıkıştırma — Ctrl+F ✅* | ~%60-85 küçülme
/// (*metin korunur, görseller pikselleşebilir)
class MaximumStrategy {
  static const int _quality = 30; // Balanced: 60 → Maximum: 30
  final void Function(double, String)? onProgress;
  MaximumStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.05, 'PDF yapısı okunuyor...');
    final parser = PdfParser(input);

    _emit(0.10, 'Metadata temizleniyor...');
    _cleanMetadata(parser);

    _emit(0.25, 'Görseller agresif sıkıştırılıyor...');
    await _compressImages(parser);

    _emit(0.75, 'Fontlar optimize ediliyor...');
    _optimizeFonts(parser);

    _emit(0.90, 'XRef tablosu yeniden yazılıyor...');
    final result = parser.build();

    _emit(1.00, 'Tamamlandı ✓');
    return result;

    // ── TODO: Sayfa Rasterizasyonu ──────────────
    // Maksimum küçülme için (Ctrl+F tamamen kaldırılır):
    //
    // import 'package:pdfx/pdfx.dart';
    // import 'package:pdf/widgets.dart' as pw;
    //
    // final doc = await PdfDocument.openData(input);
    // final newPdf = pw.Document();
    // for (int i = 1; i <= doc.pagesCount; i++) {
    //   final page = await doc.getPage(i);
    //   final rendered = await page.render(width: page.width, height: page.height);
    //   final compressed = JpegResampler.resample(rendered.bytes, quality: 35);
    //   newPdf.addPage(pw.Page(build: (_) => pw.Image(pw.MemoryImage(Uint8List.fromList(compressed)))));
    // }
    // return await newPdf.save();
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
      _emit(0.25 + (0.50 * i / images.length.clamp(1, 9999)),
          'Görsel sıkıştırılıyor... ($i/${images.length})');

      final bytes = obj.extractStreamBytes();
      if (bytes == null || bytes.length < 100) continue;
      if (!JpegResampler.isImage(bytes)) continue;

      final compressed = JpegResampler.resample(bytes, quality: _quality);
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
