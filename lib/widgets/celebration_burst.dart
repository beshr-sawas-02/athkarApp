import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class CelebrationBurst extends StatefulWidget {
  final Widget child;

  const CelebrationBurst({super.key, required this.child});

  @override
  State<CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(280, 280),
              painter: _ConfettiPainter(progress: _controller.value),
            ),
            ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0, 0.45, curve: Curves.easeOutBack),
                ),
              ),
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rnd = math.Random(7);
    final colors = [
      AppTheme.primaryGold,
      AppTheme.primaryGoldLight,
      AppTheme.success,
      Colors.white,
    ];

    for (int i = 0; i < 28; i++) {
      final angle = (i / 28) * math.pi * 2 + rnd.nextDouble();
      final dist = progress * (70 + rnd.nextDouble() * 90);
      final p = Offset(
        center.dx + math.cos(angle) * dist,
        center.dy + math.sin(angle) * dist,
      );
      final paint = Paint()
        ..color = colors[i % colors.length]
            .withValues(alpha: (1 - progress).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(angle + progress * 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: 6,
            height: 12,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class ProgressRingPulse extends StatefulWidget {
  final Widget child;
  final bool active;

  const ProgressRingPulse({
    super.key,
    required this.child,
    required this.active,
  });

  @override
  State<ProgressRingPulse> createState() => _ProgressRingPulseState();
}

class _ProgressRingPulseState extends State<ProgressRingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.active) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ProgressRingPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.03);
        return Transform.scale(scale: scale, child: child);
      },
      child: widget.child,
    );
  }
}
