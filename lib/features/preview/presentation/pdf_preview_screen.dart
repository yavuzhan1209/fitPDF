import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../../../core/theme/app_theme.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String filePath;
  final String title;
  final int fileSizeBytes;

  const PdfPreviewScreen({
    super.key,
    required this.filePath,
    required this.title,
    required this.fileSizeBytes,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfControllerPinch? _controller;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _controller = PdfControllerPinch(
        document: PdfDocument.openFile(widget.filePath),
      );
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _fmt(int b) => b < 1048576
      ? '${(b / 1024).toStringAsFixed(1)} KB'
      : '${(b / 1048576).toStringAsFixed(1)} MB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.bgSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _fmt(widget.fileSizeBytes),
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          if (_totalPages > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Text(
                '$_currentPage / $_totalPages',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryCoral, strokeWidth: 2))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppTheme.textMuted, size: 48),
                      const SizedBox(height: 16),
                      Text('PDF açılamadı', style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                    ],
                  ),
                )
              : PdfViewPinch(
                  controller: _controller!,
                  onDocumentLoaded: (doc) => setState(() => _totalPages = doc.pagesCount),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryCoral, strokeWidth: 2),
                    ),
                    pageLoaderBuilder: (_) => const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryCoral, strokeWidth: 2),
                    ),
                  ),
                ),
    );
  }
}
