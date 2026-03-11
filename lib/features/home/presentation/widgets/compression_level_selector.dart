import 'package:flutter/material.dart';
import 'package:fitpdf/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class CompressionLevelSelector extends StatelessWidget {
  final CompressionLevel selected;
  final ValueChanged<CompressionLevel> onSelect;

  const CompressionLevelSelector({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final levels = [
      (CompressionLevel.light,    l.levelLight,    l.levelLightDesc),
      (CompressionLevel.balanced, l.levelBalanced, l.levelBalancedDesc),
      (CompressionLevel.maximum,  l.levelMaximum,  l.levelMaximumDesc),
    ];
    return Row(
      children: levels.asMap().entries.map((entry) {
        final i = entry.key;
        final (lvl, name, desc) = entry.value;
        final sel = lvl == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(lvl),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: sel ? AppTheme.primaryCoral.withValues(alpha: 0.12) : AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: sel ? AppTheme.primaryCoral.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.06),
                  width: sel ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(lvl.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(name, style: TextStyle(color: sel ? AppTheme.primaryCoral : AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

