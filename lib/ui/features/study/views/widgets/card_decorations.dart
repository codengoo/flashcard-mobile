import 'package:flutter/material.dart';

class CornerOrb extends StatelessWidget {
  const CornerOrb({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}

class CornerDots extends StatelessWidget {
  const CornerDots({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(painter: _DotsPainter()),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    const r = 3.0;
    const step = 14.0;
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawCircle(
          Offset(col * step + r, row * step + r),
          r,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotsPainter old) => false;
}
