import 'package:flutter/material.dart';

import '../../styleconfig/textstyle.dart';

// Tampilan Judul dengan Gradasi Warna
class GradientText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextStyle? textStyle;
  final List<Color> gradientColors;

  const GradientText({
    super.key,
    required this.text,
    this.maxLines,
    this.textStyle,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
        ).createShader(bounds);
      },
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 2,
        text: TextSpan(
          text: text,
          style: textStyle ?? TextStyles.giant(context).copyWith(
              fontWeight: FontWeight.w900
          ),
        ),
      ),
    );
  }
}