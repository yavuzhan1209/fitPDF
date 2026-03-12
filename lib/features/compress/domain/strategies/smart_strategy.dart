import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:image/image.dart' as img;
import '../helpers/pdf_parser.dart';

/// ⚡ Smart Strategy — Structural + Image Compression
///
/// Hybrid approach:
/// - Syncfusion: metadata removal, full xref rewrite, flate compression
/// - pdf_parser + image package: binary-safe image extraction and resampling
///
/// Expected reduction: 40-60%. Imperceptible quality loss on screen.
class SmartStrategy {
  static const int _jpegQuality = 65;
  static const double _dpiScale = 144 / 300;

  final void Function(double, String)? onProgress;

  SmartStrategy({this.onProgress});

  Future<Uint8List> run(Uint8List input) async {
    _emit(0.10, 'Reading PDF document...');

    // Step 1: Syncfusion pass — metadata + structural compression
    final PdfDocument doc = PdfDocument(inputBytes: input);

    _emit(0.20, 'Cleaning metadata...');
    _removeMetadata(doc);
    doc.fileStructure.incrementalUpdate = false;
    doc.compressionLevel = PdfCompressionLevel.best;

    _emit(0.35, 'Building intermediate PDF...');
    final List<int> intermediate = await doc.save();
    doc.dispose();

    // Step 2: image package pass — binary-safe image resampling via pdf_parser
    _emit(0.40, 'Analyzing images...');
    final parser = PdfParser(Uint8List.fromList(intermediate));
    final images = parser.objects.where((o) => o.isCompressibleImage).toList();

    for (int i = 0; i < images.length; i++) {
      final obj = images[i];
      _emit(
        0.40 + (0.45 * i / images.length.clamp(1, 9999)),
        'Compressing image ${i + 1}/${images.length}...',
      );

      final bytes = obj.extractStreamBytes();
      if (bytes == null || bytes.length < 10240) continue;

      try {
        final u8 = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
        final decoded = img.decodeImage(u8);
        if (decoded == null) continue;

        final resized = img.copyResize(
          decoded,
          width: (decoded.width * _dpiScale).toInt().clamp(1, decoded.width),
          height: (decoded.height * _dpiScale).toInt().clamp(1, decoded.height),
          interpolation: img.Interpolation.linear,
        );

        final encoded = img.encodeJpg(resized, quality: _jpegQuality);
        if (encoded.length < bytes.length) {
          obj.replaceStreamWithJpeg(encoded);
        }
      } catch (_) {
        continue;
      }
    }

    _emit(0.88, 'Building PDF...');
    final result = parser.build();

    _emit(1.00, 'Done! ✓');
    return result;
  }

  void _removeMetadata(PdfDocument doc) {
    try {
      doc.documentInformation.title = '';
      doc.documentInformation.author = '';
      doc.documentInformation.subject = '';
      doc.documentInformation.keywords = '';
      doc.documentInformation.creator = '';
      doc.documentInformation.producer = '';
    } catch (_) {}
  }

  void _emit(double p, String msg) => onProgress?.call(p, msg);
}
