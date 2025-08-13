import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/media_query_func.dart';
import 'package:flutter/material.dart';

import '../../../../../core/state_management/providers/features/face_detector_provider.dart';

class CameraOverlayWidget extends StatelessWidget {
  final FaceDetectorProvider provider;
  final circleRadius = .8;
  const CameraOverlayWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: getMediaQueryWidth(context) * circleRadius,
                height: getMediaQueryWidth(context) * circleRadius,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: provider.validatorColor.withValues(alpha: .8), width: 6)),
              ),
            ],
          ),
        ),
        ClipPath(clipper: CircleHoleClipper(holeRadius: getMediaQueryWidth(context) * (circleRadius * .5)), child: Container(color: provider.validatorColor.withValues(alpha: .2)))
      ],
    );
  }
}

class CircleHoleClipper extends CustomClipper<Path> {
  final double holeRadius;

  CircleHoleClipper({super.reclip, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: holeRadius))
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CircleHoleClipper oldClipper) => holeRadius != oldClipper.holeRadius;
}