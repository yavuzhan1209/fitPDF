import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:fitpdf/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../result/presentation/result_screen.dart';
import 'widgets/squeeze_animation.dart';
import '../domain/pdf_compressor.dart';

class CompressScreen extends StatefulWidget {
  final String filePath;
  final String fileName;
  final int fileSizeBytes;
  final CompressionLevel level;

  const CompressScreen({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.level,
  });

  @override
  State<CompressScreen> createState() => _CompressScreenState();
}

class _CompressScreenState extends State<CompressScreen> {
  double _progress = 0;
  String _status = '';
  bool _done = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  void _updateProgress(double progress, String status) {
    if (!mounted) return;
    setState(() {
      _progress = progress;
      _status = status;
    });
  }

  Future<void> _run() async {
    final outPath = await _compress();
    final outSize = File(outPath).lengthSync();
    if (!mounted) return;
    setState(() { _progress = 1.0; _done = true; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => ResultScreen(
          originalPath: widget.filePath,
          compressedPath: outPath,
          fileName: widget.fileName,
          originalSizeBytes: widget.fileSizeBytes,
          compressedSizeBytes: outSize,
          level: widget.level,
        ),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<String> _compress() async {
    final input = await File(widget.filePath).readAsBytes();
    final dir = await getApplicationDocumentsDirectory();
    final base = p.basenameWithoutExtension(widget.fileName);
    final outPath = p.join(dir.path, '${base}_compressed.pdf');

    Uint8List output;

    switch (widget.level) {
      case CompressionLevel.light:
        output = await PdfCompressor.compressLight(input, onProgress: _updateProgress);

      case CompressionLevel.balanced:
        output = await PdfCompressor.compressBalanced(input, onProgress: _updateProgress);

      case CompressionLevel.maximum:
        final confirmed = await _showMaximumWarning();
        output = confirmed
            ? await PdfCompressor.compressMaximum(input, onProgress: _updateProgress)
            : await PdfCompressor.compressBalanced(input, onProgress: _updateProgress);
    }

    await File(outPath).writeAsBytes(output);
    return outPath;
  }

  Future<bool> _showMaximumWarning() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Text('⚠️ ', style: TextStyle(fontSize: 20)),
          Text('Maksimum Sıkıştırma',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w600)),
        ]),
        content: const Text(
          'Bu modda metin aranabilirliği (Ctrl+F) kaybolabilir.\n\nDevam etmek istiyor musunuz?',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Devam Et',
                style: TextStyle(color: AppTheme.primaryCoral, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SqueezeAnimation(isCompressing: !_done)
                  .animate(onPlay: (c) => c.repeat())
                  .scale(begin: const Offset(1,1), end: const Offset(0.85,1.15), duration: 800.ms, curve: Curves.easeInOut)
                  .then()
                  .scale(begin: const Offset(0.85,1.15), end: const Offset(1,1), duration: 800.ms, curve: Curves.easeInOut),
              const SizedBox(height: 48),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _done ? l.compressionDone : l.compressing,
                  key: ValueKey(_done),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: 12),
              Text(widget.fileName, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
              const SizedBox(height: 48),
              Container(
                height: 6,
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(3)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.coralGradient,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [BoxShadow(color: AppTheme.primaryCoral.withValues(alpha: 0.5), blurRadius: 8)],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(_status, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  Text('${(_progress * 100).toInt()}%',
                      style: const TextStyle(color: AppTheme.primaryCoral, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(widget.level.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text('${_levelName(context, widget.level)} ${l.compression}',
                      style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500, fontSize: 14)),
                ]),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _levelName(BuildContext ctx, CompressionLevel lvl) {
    final l = AppLocalizations.of(ctx);
    switch (lvl) {
      case CompressionLevel.light:    return l.levelLight;
      case CompressionLevel.balanced: return l.levelBalanced;
      case CompressionLevel.maximum:  return l.levelMaximum;
    }
  }
}
