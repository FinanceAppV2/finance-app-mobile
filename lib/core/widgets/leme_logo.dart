import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Assinatura Leme (símbolo + nome) para fundo escuro.
class LemeLogo extends StatelessWidget {
  final double markSize;
  final double fontSize;
  final double spacing;

  const LemeLogo({
    super.key,
    this.markSize = 36,
    this.fontSize = 22,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Leme',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LemeMark(size: markSize),
            SizedBox(width: spacing),
            Text(
              'Leme',
              style: TextStyle(
                color: AppColors.marfim,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.04 * fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Símbolo Leme: o mostrador (grafite) com o ponteiro de latão.
class LemeMark extends StatelessWidget {
  final double size;

  const LemeMark({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _LemeMarkPainter(),
    );
  }
}

class _LemeMarkPainter extends CustomPainter {
  const _LemeMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhado na grade 64×64 do símbolo original.
    canvas.scale(size.width / 64, size.height / 64);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 64, 64),
        const Radius.circular(16),
      ),
      Paint()..color = AppColors.marfim,
    );
    canvas.drawCircle(
      const Offset(32, 35),
      13.5,
      Paint()
        ..color = AppColors.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawCircle(
      const Offset(32, 35),
      4,
      Paint()..color = AppColors.background,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(29, 11, 6, 13),
        const Radius.circular(3),
      ),
      Paint()..color = AppColors.latao,
    );
  }

  @override
  bool shouldRepaint(covariant _LemeMarkPainter oldDelegate) => false;
}
