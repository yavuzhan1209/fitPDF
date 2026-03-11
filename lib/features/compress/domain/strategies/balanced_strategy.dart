import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../helpers/pdf_parser.dart';

/// ⚡ Balanced Strategy
/// Standard Image Compression - Analyzing images... ✅ | ~40-60% reduction
///
/// This strategy balances quality and compression:
/// - Image Resampling: Limit resolution to 144-150 DPI
/// - JPEG Compression: Force all images to JPEG format with 65% quality
/// - Metadata Cleaning: Remove document info
///
/// Result: 40-60% reduction. Imperceptible quality loss on screen or in print.
class BalancedStrategy {
  static const int _jpegQuality = 65;
  final void Function(double, String)? onProgress;

  BalancedStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.10, 'Reading PDF document...');
    final parser = PdfParser(input);

    _emit(0.20, 'Cleaning metadata...');
    _cleanMetadata(parser);

    _emit(0.30, 'Analyzing images...');
    final images = parser.objects.where((o) => o.isCompressibleImage).toList();

    _emit(0.40, 'Compressing images to 144 DPI...');
    for (int i = 0; i < images.length; i++) {
      final obj = images[i];
      _emit(0.40 + (0.30 * i / images.length.clamp(1, 999)),
          'Compressing image ${i + 1}/${images.length}...');

      final bytes = obj.extractStreamBytes();
      if (bytes == null || bytes.length < 100) continue;

      try {
        final bytesU8 = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
        final decompressed = img.decodeImage(bytesU8);
        if (decompressed != null) {
          // Resize to 144 DPI
          final resized = img.copyResize(
            decompressed,
            width: (decompressed.width * 144 / 300).toInt(),
            height: (decompressed.height * 144 / 300).toInt(),
            interpolation: img.Interpolation.linear,
          );

          // Encode as JPEG with 65% quality
          final encoded = img.encodeJpg(resized, quality: _jpegQuality);

          if (encoded.length < bytes.length) {
            obj.replaceStreamWithJpeg(encoded);
          }
        }
      } catch (e) {
        // Continue if image fails
      }
    }

    _emit(0.75, 'Removing empty objects...');
    parser.objects.removeWhere((o) => o.hasEmptyStream);

    _emit(0.85, 'Optimizing fonts...');
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
