import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LogoHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  const LogoHeader({super.key, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.coralGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: AppTheme.primaryCoral.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: const Center(child: _LogoIcon()),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FitPDF', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            const Text('Sıkıştır ve Paylaş', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSettingsTap,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: const Icon(Icons.language_rounded, color: AppTheme.textMuted, size: 20),
          ),
        ),
      ],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon();
  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(28, 28), painter: _LogoPainter());
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    final fill = Paint()..color = Colors.white.withValues(alpha: 0.15)..style = PaintingStyle.fill;
    final doc = Path()
      ..moveTo(4, 2)..lineTo(18, 2)..lineTo(24, 8)..lineTo(24, 26)..lineTo(4, 26)..close();
    canvas.drawPath(doc, fill);
    canvas.drawPath(doc, stroke);
    canvas.drawLine(const Offset(18, 2), const Offset(18, 8), stroke);
    canvas.drawLine(const Offset(18, 8), const Offset(24, 8), stroke);
    final a = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.8..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(2, 14), const Offset(8, 14), a);
    canvas.drawLine(const Offset(6, 11), const Offset(8, 14), a);
    canvas.drawLine(const Offset(6, 17), const Offset(8, 14), a);
    canvas.drawLine(const Offset(26, 14), const Offset(20, 14), a);
    canvas.drawLine(const Offset(22, 11), const Offset(20, 14), a);
    canvas.drawLine(const Offset(22, 17), const Offset(20, 14), a);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

