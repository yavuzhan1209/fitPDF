import 'package:flutter/material.dart';
import 'package:fitpdf/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class RecentFilesList extends StatelessWidget {
  const RecentFilesList({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final files = [
      ('Q4_Report_2024.pdf',     '12.4 MB', '3.1 MB', 75),
      ('Design_Assets_v3.pdf',   '8.7 MB',  '3.0 MB', 65),
      ('Contract_Template.pdf',  '2.1 MB',  '0.8 MB', 62),
    ];
    return Column(
      children: files.map((f) {
        final (name, orig, comp, pct) = f;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [AppTheme.primaryCoral.withValues(alpha: 0.8), AppTheme.primaryCoralDark.withValues(alpha: 0.8)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('PDF', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('$orig → $comp', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.accentGreen.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text('−$pct%', style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

