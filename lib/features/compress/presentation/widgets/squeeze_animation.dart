import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SqueezeAnimation extends StatelessWidget {
  final bool isCompressing;
  const SqueezeAnimation({super.key, required this.isCompressing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppTheme.primaryCoral.withValues(alpha: 0.15), Colors.transparent],
              ),
            ),
          ),
          CustomPaint(size: const Size(80, 96), painter: _DocPainter()),
        ],
      ),
    );
  }
}

class _DocPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()
      ..color = AppTheme.primaryCoral.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 8, size.width - 8, size.height - 4), const Radius.circular(10)),
      shadow,
    );
    final body = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [AppTheme.primaryCoralLight, AppTheme.primaryCoral, AppTheme.primaryCoralDark],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final doc = Path()
      ..moveTo(0, 0)..lineTo(size.width - 20, 0)..lineTo(size.width, 20)
      ..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(doc, body);
    final fold = Paint()..color = AppTheme.primaryCoralDark..style = PaintingStyle.fill;
    final foldPath = Path()
      ..moveTo(size.width - 20, 0)..lineTo(size.width, 20)..lineTo(size.width - 20, 20)..close();
    canvas.drawPath(foldPath, fold);
    final line = Paint()..color = Colors.white.withValues(alpha: 0.3)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final w = [0.7, 0.5, 0.8, 0.4, 0.65][i];
      final y = 36.0 + i * 11;
      canvas.drawLine(Offset(12, y), Offset(12 + (size.width - 24) * w, y), line);
    }
    final tp = TextPainter(
      text: const TextSpan(text: 'PDF', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height - 26));
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

