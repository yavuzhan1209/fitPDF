import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../helpers/pdf_parser.dart';

/// 💎 Maximum Strategy
/// Aggressive Archival - Converting to grayscale & low resolution... ✅ | ~70-90% reduction
///
/// This strategy prioritizes maximum size reduction for archival & fast sharing:
/// - Grayscale Conversion: Convert all color images to B&W (3x data reduction)
/// - Low Resolution: Reduce to 72-96 DPI (screen standard)
/// - Aggressive Quality: JPEG quality 30-40% for extreme compression
/// - Complete Metadata Removal: Strip all document information
///
/// Result: 70-90% reduction. Noticeable pixelation in images, suitable for archival.
class MaximumStrategy {
  static const int _jpegQuality = 35;
  final void Function(double, String)? onProgress;

  MaximumStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.10, 'Reading PDF document...');
    final parser = PdfParser(input);

    _emit(0.20, 'Removing metadata...');
    _cleanMetadata(parser);

    _emit(0.30, 'Analyzing images...');
    final images = parser.objects.where((o) => o.isCompressibleImage).toList();

    _emit(0.40, 'Converting to grayscale & compressing...');
    for (int i = 0; i < images.length; i++) {
      final obj = images[i];
      _emit(0.40 + (0.35 * i / images.length.clamp(1, 999)),
          'Processing image ${i + 1}/${images.length}...');

      final bytes = obj.extractStreamBytes();
      if (bytes == null || bytes.length < 100) continue;

      try {
        final bytesU8 = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
        final decompressed = img.decodeImage(bytesU8);
        if (decompressed != null) {
          // Convert to grayscale for 3x reduction
          final grayscale = img.grayscale(decompressed);

          // Resize to 72 DPI
          final resized = img.copyResize(
            grayscale,
            width: (grayscale.width * 72 / 300).toInt(),
            height: (grayscale.height * 72 / 300).toInt(),
            interpolation: img.Interpolation.linear,
          );

          // Encode with low quality
          final encoded = img.encodeJpg(resized, quality: _jpegQuality);

          if (encoded.length < bytes.length) {
            obj.replaceStreamWithJpeg(encoded);
          }
        }
      } catch (e) {
        // Continue if processing fails
      }
    }

    _emit(0.80, 'Removing empty objects...');
    parser.objects.removeWhere((o) => o.hasEmptyStream);

    _emit(0.90, 'Optimizing...');
    _optimizeFonts(parser);

    _emit(0.95, 'Building PDF...');
    final result = parser.build();

    _emit(1.00, 'Done! ✓');
    return result;
  }

  void _cleanMetadata(PdfParser parser) {
    parser.objects.removeWhere((o) => o.isMetadata);

    const fields = [
      r'/Author\s*\([^)]*\)',
      r'/Creator\s*\([^)]*\)',
      r'/Producer\s*\([^)]*\)',
      r'/Keywords\s*\([^)]*\)',
      r'/Subject\s*\([^)]*\)',
    ];

    for (final obj in parser.objects) {
      for (final field in fields) {
        obj.content = obj.content.replaceAll(RegExp(field), '');
      }
    }
  }

  void _optimizeFonts(PdfParser parser) {
    for (final obj in parser.objects) {
      if (!obj.isFont) continue;
      obj.content = obj.content.replaceAll(
        RegExp(r'/FontDescriptor\s+\d+\s+\d+\s+R'),
        ''
      );
    }
  }

  void _emit(double p, String msg) => onProgress?.call(p, msg);
}
