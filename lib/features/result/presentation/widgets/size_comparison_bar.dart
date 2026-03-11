import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SizeComparisonBar extends StatelessWidget {
  final String originalSize, compressedSize, sectionTitle, beforeLabel, afterLabel;
  final double ratio;
  const SizeComparisonBar({
    super.key,
    required this.originalSize, required this.compressedSize,
    required this.ratio, required this.sectionTitle,
    required this.beforeLabel, required this.afterLabel,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(sectionTitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600)),
      const SizedBox(height: 16),
      _Bar(label: beforeLabel, size: originalSize,    fraction: 1.0,                      color: Colors.white.withValues(alpha: 0.15)),
      const SizedBox(height: 10),
      _Bar(label: afterLabel,  size: compressedSize,  fraction: ratio.clamp(0.05, 1.0),   color: AppTheme.accentGreen),
    ],
  );
}

class _Bar extends StatelessWidget {
  final String label, size;
  final double fraction;
  final Color color;
  const _Bar({required this.label, required this.size, required this.fraction, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(width: 44, child: Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))),
      Expanded(
        child: LayoutBuilder(
          builder: (_, c) => Container(
            height: 10,
            decoration: BoxDecoration(color: AppTheme.bgSecondary, borderRadius: BorderRadius.circular(5)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: c.maxWidth * fraction,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: color == AppTheme.accentGreen ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)] : null,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      SizedBox(
        width: 60,
        child: Text(size,
          style: TextStyle(color: color == AppTheme.accentGreen ? AppTheme.accentGreen : AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

