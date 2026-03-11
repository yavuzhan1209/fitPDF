import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../preview/presentation/pdf_preview_screen.dart';

class PreviewComparison extends StatelessWidget {
  final String originalPath;
  final String compressedPath;
  final int originalSizeBytes;
  final int compressedSizeBytes;

  const PreviewComparison({
    super.key,
    required this.originalPath,
    required this.compressedPath,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
  });

  String _fmt(int b) => b < 1048576
      ? '${(b / 1024).toStringAsFixed(1)} KB'
      : '${(b / 1048576).toStringAsFixed(1)} MB';

  void _open(BuildContext context, {required bool compressed}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          filePath: compressed ? compressedPath : originalPath,
          title: compressed ? 'Sıkıştırılmış PDF' : 'Orijinal PDF',
          fileSizeBytes: compressed ? compressedSizeBytes : originalSizeBytes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PreviewBtn(
            label: 'Orijinal',
            size: _fmt(originalSizeBytes),
            icon: Icons.description_outlined,
            color: AppTheme.textSecondary,
            onTap: () => _open(context, compressed: false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PreviewBtn(
            label: 'Sıkıştırılmış',
            size: _fmt(compressedSizeBytes),
            icon: Icons.compress_rounded,
            color: AppTheme.primaryCoral,
            onTap: () => _open(context, compressed: true),
          ),
        ),
      ],
    );
  }
}

class _PreviewBtn extends StatelessWidget {
  final String label;
  final String size;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PreviewBtn({
    required this.label,
    required this.size,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(size, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.visibility_outlined, size: 13, color: color.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Text('Önizle', style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
            ],
          ),
        ],
      ),
    ),
  );
}
