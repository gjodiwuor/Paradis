import 'package:flutter/material.dart';

import '../theme.dart';

const logoAsset = 'assets/logo/wings_of_freedom_transparent.png';

/// The Wings of Freedom logo with the PARADIS name beside it.
class LogoTitle extends StatelessWidget {
  const LogoTitle({super.key, this.onPhoto = true});

  /// White text on photos, dark text on the light background.
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(logoAsset, width: onPhoto ? 60 : 44, height: onPhoto ? 60 : 44),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PARADIS',
              style: TextStyle(
                fontSize: onPhoto ? 22 : 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: onPhoto ? Colors.white : AppColors.ink,
              ),
            ),
            if (onPhoto)
              const Text(
                'Car hire',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.offerText,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// A photo with a dark fade over it so white text stays readable.
class PhotoWithShade extends StatelessWidget {
  const PhotoWithShade({
    super.key,
    required this.photo,
    this.alignment = Alignment.center,
    required this.shades,
    required this.stops,
  });

  final String photo;
  final Alignment alignment;

  /// How dark the fade is (0 to 1) at each of the [stops], top to bottom.
  final List<double> shades;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(photo, fit: BoxFit.cover, alignment: alignment),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [for (final s in shades) AppColors.ink.withValues(alpha: s)],
              stops: stops,
            ),
          ),
        ),
      ],
    );
  }
}

/// A white rounded card with a soft shadow.
class WhiteCard extends StatelessWidget {
  const WhiteCard({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.radius = 20});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// A horizontal dashed line, like the tear line on a ticket.
class DashedLine extends StatelessWidget {
  const DashedLine({super.key, this.color = AppColors.fieldBorder});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashPainter(color)),
    );
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}

/// A small text label above a value, used on the ticket and profile.
class LabelValue extends StatelessWidget {
  const LabelValue({super.key, required this.label, required this.value, this.big = false});

  final String label;
  final String value;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: big ? 24 : 15,
            fontWeight: big ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
