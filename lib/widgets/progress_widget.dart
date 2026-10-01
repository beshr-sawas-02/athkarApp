import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/app_theme.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final String progressText;
  final bool isDark;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.progressText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppTheme.darkSurfaceVariant
                  : AppTheme.lightDivider.withValues(alpha: 0.5),
            ),
          ),
          // Progress arc
          SizedBox(
            width: 280,
            height: 280,
            child: CustomPaint(
              painter: ProgressArcPainter(
                progress: progress,
                isDark: isDark,
              ),
            ),
          ),
          // Inner content area
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressArcPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  ProgressArcPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background arc
    final backgroundPaint = Paint()
      ..color = isDark
          ? AppTheme.darkDivider
          : AppTheme.lightDivider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      const gradient = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
        colors: [
          AppTheme.primaryGoldLight,
          AppTheme.primaryGold,
          AppTheme.primaryGoldDark,
        ],
        stops: [0.0, 0.5, 1.0],
        transform: GradientRotation(-math.pi / 2),
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // Glow effect at the end of progress
      if (progress > 0.01) {
        final endAngle = -math.pi / 2 + sweepAngle;
        final endX = center.dx + radius * math.cos(endAngle);
        final endY = center.dy + radius * math.sin(endAngle);

        final glowPaint = Paint()
          ..color = AppTheme.primaryGold.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawCircle(Offset(endX, endY), 8, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}