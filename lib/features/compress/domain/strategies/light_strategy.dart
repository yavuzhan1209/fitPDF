import 'dart:typed_data';
import '../helpers/pdf_parser.dart';

/// 🪶 Light Strateji
/// Metadata temizleme — Ctrl+F ✅ | ~%5-15 küçülme
class LightStrategy {
  final void Function(double, String)? onProgress;
  LightStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.10, 'PDF yapısı okunuyor...');
    final parser = PdfParser(input);

    _emit(0.30, 'Metadata temizleniyor...');
    parser.objects.removeWhere((o) => o.isMetadata);

    _emit(0.55, 'Info dictionary temizleniyor...');
    _cleanInfo(parser);

    _emit(0.75, 'Boş streamler kaldırılıyor...');
    parser.objects.removeWhere((o) => o.hasEmptyStream);

    _emit(0.92, 'Dosya yazılıyor...');
    final result = parser.build();

    _emit(1.00, 'Tamamlandı ✓');
    return result;
  }

  void _cleanInfo(PdfParser parser) {
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

  void _emit(double p, String msg) => onProgress?.call(p, msg);
}
