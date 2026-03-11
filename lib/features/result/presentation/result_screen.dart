import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fitpdf/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/coral_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/constants/app_constants.dart';
import 'widgets/size_comparison_bar.dart';
import 'widgets/stat_card.dart';
import 'widgets/preview_comparison.dart';

class ResultScreen extends StatelessWidget {
  final String originalPath;
  final String compressedPath;
  final String fileName;
  final int originalSizeBytes;
  final int compressedSizeBytes;
  final CompressionLevel level;

  const ResultScreen({
    super.key,
    required this.originalPath,
    required this.compressedPath,
    required this.fileName,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
    required this.level,
  });

  int get _savedPct => originalSizeBytes == 0 ? 0
      : ((1 - compressedSizeBytes / originalSizeBytes) * 100).round();

  String _fmt(int b) => b < 1048576
      ? '${(b / 1024).toStringAsFixed(1)} KB'
      : '${(b / 1048576).toStringAsFixed(1)} MB';

  Future<void> _share(AppLocalizations l) async {
    await Share.shareXFiles(
      [XFile(compressedPath)],
      subject: 'Compressed: $fileName',
      text: '${l.shareText} — ${_fmt(originalSizeBytes)} → ${_fmt(compressedSizeBytes)} (−$_savedPct%)',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Success header
              Center(
                child: Column(children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentGreen.withValues(alpha: 0.12),
                      border: Border.all(color: AppTheme.accentGreen.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Icon(Icons.check_rounded, color: AppTheme.accentGreen, size: 42),
                  ).animate().scale(begin: const Offset(0, 0), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 700.ms),
                  const SizedBox(height: 16),
                  Text(l.resultTitle, style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center)
                      .animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 6),
                  Text(fileName, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)
                      .animate().fadeIn(delay: 300.ms),
                ]),
              ),

              const SizedBox(height: 28),

              // Stat cards
              Row(children: [
                Expanded(child: StatCard(label: l.original,   value: _fmt(originalSizeBytes),   color: AppTheme.textSecondary, icon: Icons.insert_drive_file_outlined)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(label: l.compressed, value: _fmt(compressedSizeBytes), color: AppTheme.accentGreen,   icon: Icons.compress_rounded)),
                const SizedBox(width: 10),
                Expanded(child: StatCard(label: l.saved,      value: '−$_savedPct%',            color: AppTheme.primaryCoral,  icon: Icons.trending_down_rounded)),
              ]).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 20),

              // Size bar
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: SizeComparisonBar(
                  beforeLabel: l.before,
                  afterLabel: l.after,
                  sectionTitle: l.sizeComparison,
                  originalSize: _fmt(originalSizeBytes),
                  compressedSize: _fmt(compressedSizeBytes),
                  ratio: originalSizeBytes > 0 ? compressedSizeBytes / originalSizeBytes : 0.5,
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 20),

              // ── Önizleme karşılaştırması ──────────────
              PreviewComparison(
                originalPath: originalPath,
                compressedPath: compressedPath,
                originalSizeBytes: originalSizeBytes,
                compressedSizeBytes: compressedSizeBytes,
              ).animate().fadeIn(delay: 430.ms),

              const SizedBox(height: 24),

              CoralButton(label: l.shareCompressed, icon: Icons.share_rounded, onTap: () => _share(l))
                  .animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 12),

              Row(children: [
                Expanded(child: _ActionTile(icon: Icons.chat_rounded,         label: l.whatsapp, color: const Color(0xFF25D366), onTap: () => _share(l))),
                const SizedBox(width: 10),
                Expanded(child: _ActionTile(icon: Icons.mail_outline_rounded, label: l.email,    color: AppTheme.accentBlue,    onTap: () => _share(l))),
                const SizedBox(width: 10),
                Expanded(child: _ActionTile(icon: Icons.folder_outlined,      label: l.files,    color: AppTheme.textSecondary, onTap: () => _share(l))),
              ]).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 20),

              CoralButton(
                label: l.compressAnother,
                isOutlined: true,
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
              ).animate().fadeIn(delay: 550.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}
