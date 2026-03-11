import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CoralButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isOutlined;

  const CoralButton({super.key, required this.label, this.onTap, this.icon, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          gradient: isOutlined ? null : AppTheme.coralGradient,
          borderRadius: BorderRadius.circular(18),
          border: isOutlined ? Border.all(color: AppTheme.primaryCoral, width: 1.5) : null,
          boxShadow: isOutlined ? null : [
            BoxShadow(color: AppTheme.primaryCoral.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isOutlined ? AppTheme.primaryCoral : Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: TextStyle(
                color: isOutlined ? AppTheme.primaryCoral : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

