import 'dart:typed_data';

/// PDF binary parser — saf Dart, sıfır bağımlılık.
class PdfParser {
  final Uint8List original;
  late String fullText;
  late String header;
  late List<PdfObject> objects;

  PdfParser(this.original) {
    fullText = String.fromCharCodes(original);
    header = _extractHeader();
    objects = _parseObjects();
  }

  String _extractHeader() {
    final nl = fullText.indexOf('\n');
    return nl > 0 ? fullText.substring(0, nl + 1) : '%PDF-1.4\n';
  }

  List<PdfObject> _parseObjects() {
    final result = <PdfObject>[];
    final regex = RegExp(
      r'(\d+)\s+(\d+)\s+obj\s*([\s\S]*?)\s*endobj',
      multiLine: true,
    );
    for (final m in regex.allMatches(fullText)) {
      result.add(PdfObject(
        id: int.parse(m.group(1)!),
        generation: int.parse(m.group(2)!),
        content: m.group(3)!.trim(),
      ));
    }
    return result;
  }

  Uint8List build() {
    final buf = StringBuffer();
    buf.write(header);

    final offsets = <int, int>{};
    var offset = header.length;

    for (final obj in objects) {
      offsets[obj.id] = offset;
      final str =
          '${obj.id} ${obj.generation} obj\n${obj.content}\nendobj\n\n';
      buf.write(str);
      offset += str.length;
    }

    final xrefOffset = offset;
    buf.write('xref\n0 ${objects.length + 1}\n');
    buf.write('0000000000 65535 f \n');
    final sorted = offsets.keys.toList()..sort();
    for (final id in sorted) {
      buf.write('${offsets[id]!.toString().padLeft(10, '0')} 00000 n \n');
    }

    buf.write('trailer\n${_trailer()}\n');
    buf.write('startxref\n$xrefOffset\n%%EOF\n');

    return Uint8List.fromList(buf.toString().codeUnits);
  }

  String _trailer() {
    final m =
        RegExp(r'trailer\s*(<<[\s\S]*?>>)', multiLine: true).firstMatch(fullText);
    if (m != null) {
      return m
          .group(1)!
          .replaceAll(RegExp(r'/Prev\s+\d+'), '')
          .replaceAll(RegExp(r'/Size\s+\d+'), '/Size ${objects.length + 1}');
    }
    return '<< /Size ${objects.length + 1} >>';
  }
}

class PdfObject {
  final int id;
  final int generation;
  String content;

  PdfObject({
    required this.id,
    required this.generation,
    required this.content,
  });

  bool get isMetadata =>
      content.contains('/Type /Metadata') ||
      content.contains('/Type/Metadata') ||
      content.contains('/Subtype /XML') ||
      content.contains('/Subtype/XML');

  bool get isImage =>
      content.contains('/Subtype /Image') ||
      content.contains('/Subtype/Image');

  /// JPEG — hem /DCTDecode hem [/DCTDecode] formatını yakala
  bool get isJpegImage =>
      isImage && _hasFilter('DCTDecode');

  /// PNG/ZIP — hem /FlateDecode hem [/FlateDecode]
  bool get isFlatImage =>
      isImage &&
      _hasFilter('FlateDecode') &&
      !content.contains('/ColorSpace /DeviceGray');

  /// JPEG2000
  bool get isJpx =>
      isImage && _hasFilter('JPXDecode');

  /// Sıkıştırılabilir tüm görseller
  bool get isCompressibleImage =>
      isJpegImage || isFlatImage || isJpx;

  bool get isFont =>
      content.contains('/Type /Font') || content.contains('/Type/Font');

  bool get hasEmptyStream {
    if (!content.contains('stream')) return false;
    final m =
        RegExp(r'stream\r?\n([\s\S]*?)\r?\nendstream').firstMatch(content);
    return m != null && (m.group(1)?.trim().isEmpty ?? true);
  }

  /// Hem /FILTER hem [/FILTER] array formatını kontrol eder
  bool _hasFilter(String filterName) {
    return content.contains('/Filter /$filterName') ||
        content.contains('/Filter/$filterName') ||
        content.contains('/Filter [/$filterName]') ||
        content.contains('/Filter[/$filterName]') ||
        RegExp('/Filter\\s*\\[\\s*/$filterName\\s*\\]').hasMatch(content) ||
        RegExp('/Filter\\s*/$filterName').hasMatch(content);
  }

  List<int>? extractStreamBytes() {
    final m =
        RegExp(r'stream\r?\n([\s\S]*?)\r?\nendstream').firstMatch(content);
    if (m == null) return null;
    return m.group(1)!.codeUnits;
  }

  void replaceStreamWithJpeg(List<int> jpegBytes) {
    // Array ve single format her ikisini de güncelle
    content = content
        .replaceAll(RegExp(r'/Filter\s*\[/FlateDecode\]'), '/Filter [/DCTDecode]')
        .replaceAll(RegExp(r'/Filter\s*/FlateDecode'), '/Filter /DCTDecode')
        .replaceAll(RegExp(r'/Filter\s*\[/JPXDecode\]'), '/Filter [/DCTDecode]')
        .replaceAll(RegExp(r'/Filter\s*/JPXDecode'), '/Filter /DCTDecode');

    // DecodeParms kaldır
    content = content
        .replaceAll(RegExp(r'/DecodeParms\s*\[null\]'), '')
        .replaceAll(RegExp(r'/DecodeParms\s*<<[^>]*>>'), '')
        .replaceAll(RegExp(r'/DecodeParms\s*\[[^\]]*\]'), '');

    // Length güncelle
    content = content.replaceAll(
        RegExp(r'/Length\s+\d+'), '/Length ${jpegBytes.length}');

    // Stream değiştir
    content = content.replaceAllMapped(
      RegExp(r'(stream\r?\n)([\s\S]*?)(\r?\nendstream)'),
      (m) =>
          m.group(1)! + String.fromCharCodes(jpegBytes) + m.group(3)!,
    );
  }
}
