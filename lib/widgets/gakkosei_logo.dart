import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

/// The Gakkosei mark: an open book with a play button.
class GakkoseiLogo extends StatelessWidget {
  const GakkoseiLogo({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _LogoPainter(AppPalette.of(context))),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.p);
  final AppPalette p;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset pt(double x, double y) => Offset(x * s, y * s);

    // 1. Rounded tile with a gradient and a soft shadow
    final tile = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(0.28 * s));
    canvas.drawShadow(Path()..addRRect(tile), Colors.black, 0.08 * s, false);
    canvas.drawRRect(
      tile,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.primary, p.primaryDark],
        ).createShader(Offset.zero & size),
    );
    canvas.drawRRect(
      tile.deflate(0.01 * s),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.02 * s
        ..color = Colors.white.withValues(alpha: 0.25),
    );

    // 2. Open book: two pages meeting at the spine
    Path page(double outerX, double ctrlX) => Path()
      ..moveTo(pt(0.5, 0.40).dx, pt(0.5, 0.40).dy)
      ..quadraticBezierTo(pt(ctrlX, 0.30).dx, pt(ctrlX, 0.30).dy,
          pt(outerX, 0.34).dx, pt(outerX, 0.34).dy)
      ..lineTo(pt(outerX, 0.70).dx, pt(outerX, 0.70).dy)
      ..quadraticBezierTo(pt(ctrlX, 0.66).dx, pt(ctrlX, 0.66).dy,
          pt(0.5, 0.76).dx, pt(0.5, 0.76).dy)
      ..close();

    canvas.drawPath(page(0.18, 0.34), Paint()..color = Colors.white.withValues(alpha: 0.96));
    canvas.drawPath(page(0.82, 0.66), Paint()..color = Colors.white.withValues(alpha: 0.82));

    // 3. Play button, with softly rounded corners
    final play = Path()
      ..moveTo(pt(0.43, 0.44).dx, pt(0.43, 0.44).dy)
      ..lineTo(pt(0.43, 0.66).dx, pt(0.43, 0.66).dy)
      ..lineTo(pt(0.62, 0.55).dx, pt(0.62, 0.55).dy)
      ..close();
    canvas.drawPath(
      play,
      Paint()
        ..color = p.accent
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      play,
      Paint()
        ..color = p.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.03 * s
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.p != p;
}

/// "Gakko" + "sei" (school + student), with "sei" in the accent color.
class GakkoseiWordmark extends StatelessWidget {
  const GakkoseiWordmark({super.key, this.color, this.fontSize = 32});
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final style = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: color ?? p.textPrimary,
    );
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Gakko'),
        TextSpan(text: 'sei', style: TextStyle(color: p.accent)),
      ]),
      style: style,
    );
  }
}