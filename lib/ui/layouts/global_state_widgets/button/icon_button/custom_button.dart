import 'package:flutter/material.dart';

class PointedBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  PointedBorderPainter({
    required this.borderColor,
    required this.clipper,
    this.borderWidth = 2.5,
    this.radius = 5,
    this.shadow = const Shadow(blurRadius: 5, color: Colors.black),
  });

  Path getPath(Size size) {
    final path = Path();
    path.moveTo(0, 20 + radius);
    path.quadraticBezierTo(0, 20, radius, 20);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width - radius, 20);
    path.quadraticBezierTo(size.width, 20, size.width, 20 + radius);
    path.lineTo(size.width, size.height - 20 - radius);
    path.quadraticBezierTo(size.width, size.height - 20, size.width - radius, size.height - 20);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(radius, size.height - 20);
    path.quadraticBezierTo(0, size.height - 20, 0, size.height - 20 - radius);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, shadow.toPaint());

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    final path = getPath(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ClippedContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Shadow shadow;

  const ClippedContainer({
    super.key,
    required this.child,
    required this.borderColor,
    required this.backgroundColor,
    this.borderWidth = 2.5,
    this.radius = 20,
    this.padding,
    this.shadow = const Shadow(blurRadius: 5, color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    var clipper = ContainerClipper(radius: radius);
    return CustomPaint(
      painter: PointedBorderPainter(
        borderColor: borderColor,
        borderWidth: borderWidth,
        radius: radius,
        clipper: clipper,
      ),
      child: ClipPath(
        clipper: clipper,
        child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class ContainerClipper extends CustomClipper<Path> {
  final double radius;

  ContainerClipper({super.reclip, this.radius = 10});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 20 + radius);
    path.quadraticBezierTo(0, 20, radius, 20);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width - radius, 20);
    path.quadraticBezierTo(size.width, 20, size.width, 20 + radius);
    path.lineTo(size.width, size.height - 20 - radius);
    path.quadraticBezierTo(size.width, size.height - 20, size.width - radius, size.height - 20);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(radius, size.height - 20);
    path.quadraticBezierTo(0, size.height - 20, 0, size.height - 20 - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}