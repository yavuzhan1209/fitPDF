import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fitpdf/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coral_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main.dart';
import '../../compress/presentation/compress_screen.dart';
import '../../preview/presentation/pdf_preview_screen.dart';
import 'widgets/compression_level_selector.dart';
import 'widgets/recent_files_list.dart';
import 'widgets/logo_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _filePath;
  String? _fileName;
  int?    _fileSizeBytes;
  CompressionLevel _level = CompressionLevel.balanced;
  bool _picking = false;

  Future<void> _pickFile() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        final f = result.files.first;
        setState(() {
          _filePath = f.path;
          _fileName = f.name;
          _fileSizeBytes = f.size;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.of(context).errorPickingFile}: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _startCompress() {
    if (_filePath == null) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => CompressScreen(
          filePath: _filePath!,
          fileName: _fileName!,
          fileSizeBytes: _fileSizeBytes ?? 0,
          level: _level,
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _previewFile() {
    if (_filePath == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          filePath: _filePath!,
          title: _fileName ?? 'PDF',
          fileSizeBytes: _fileSizeBytes ?? 0,
        ),
      ),
    );
  }

  String _fmtSize(int b) => b < 1048576
      ? '${(b / 1024).toStringAsFixed(1)} KB'
      : '${(b / 1048576).toStringAsFixed(1)} MB';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasFile = _filePath != null;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              LogoHeader(onSettingsTap: () => _showLanguageSheet(context))
                  .animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

              const SizedBox(height: 32),

              // Upload zone
              GestureDetector(
                onTap: _pickFile,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: hasFile
                          ? AppTheme.primaryCoral.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.08),
                      width: hasFile ? 1.5 : 1,
                    ),
                    boxShadow: hasFile ? [BoxShadow(
                      color: AppTheme.primaryCoral.withValues(alpha: 0.12),
                      blurRadius: 24, spreadRadius: 2,
                    )] : null,
                  ),
                  child: _picking
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryCoral, strokeWidth: 2))
                      : hasFile ? _fileView(l) : _uploadPrompt(l),
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

              // Önizle butonu — sadece dosya seçilince görünür
              if (hasFile) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _previewFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_outlined, color: AppTheme.textSecondary, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'PDF\'i Önizle',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 200.ms),
              ],

              const SizedBox(height: 28),

              _sectionLabel(l.compressionLevel),
              const SizedBox(height: 12),

              CompressionLevelSelector(
                selected: _level,
                onSelect: (v) => setState(() => _level = v),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 28),

              CoralButton(
                label: hasFile ? '${l.compressPdf} ⚡' : l.selectFirst,
                onTap: hasFile ? _startCompress : _pickFile,
                icon: hasFile ? Icons.compress_rounded : Icons.upload_file_rounded,
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  l.privacyNote,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              _sectionLabel(l.recent),
              const SizedBox(height: 12),

              RecentFilesList().animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600),
  );

  Widget _uploadPrompt(AppLocalizations l) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          gradient: AppTheme.coralGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppTheme.primaryCoral.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: const Icon(Icons.upload_file_rounded, color: Colors.white, size: 34),
      ),
      const SizedBox(height: 16),
      Text(l.uploadPdf, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(l.tapToSelect, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
    ],
  );

  Widget _fileView(AppLocalizations l) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 52, height: 60,
              decoration: BoxDecoration(gradient: AppTheme.coralGradient, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_fileName ?? '', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(_fmtSize(_fileSizeBytes ?? 0), style: const TextStyle(color: AppTheme.primaryCoral, fontWeight: FontWeight.w500, fontSize: 13)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() { _filePath = null; _fileName = null; _fileSizeBytes = null; }),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.close_rounded, color: AppTheme.textMuted, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryCoral.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.primaryCoral.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.primaryCoral, size: 16),
              const SizedBox(width: 6),
              Text(l.readyToCompress, style: const TextStyle(color: AppTheme.primaryCoral, fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
        ),
      ],
    ),
  );

  void _showLanguageSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgSecondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.language, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _langTile(context, '🇬🇧  English', const Locale('en')),
            const SizedBox(height: 8),
            _langTile(context, '🇹🇷  Türkçe', const Locale('tr')),
          ],
        ),
      ),
    );
  }

  Widget _langTile(BuildContext context, String label, Locale locale) {
    return GestureDetector(
      onTap: () {
        FitPDFApp.setLocale(context, locale);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
