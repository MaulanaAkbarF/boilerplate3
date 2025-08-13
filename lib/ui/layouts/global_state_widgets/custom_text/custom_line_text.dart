import 'package:flutter/material.dart';

import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

// Tampilan Teks dengan garis di sisi kiri dan kanan
class LineText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double lineWidth;
  final double? lineHeight;
  final double lineSpacing;
  final Color? lineColor;
  final double lineOpacity;

  const LineText({
    super.key,
    required this.text,
    this.textStyle,
    this.lineWidth = 30,
    this.lineHeight,
    this.lineSpacing = 10,
    this.lineColor,
    this.lineOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 10, minHeight: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 10, maxWidth: 100, minHeight: 1,),
            width: lineWidth,
            height: lineHeight,
            alignment: Alignment.centerRight,
            color: lineColor ?? ThemeColors.surface(context).withValues(alpha: lineOpacity),
          ),
          SizedBox(width: lineSpacing),
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: cText(context, text, maxLines: 2, style: textStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
          ),
          SizedBox(width: lineSpacing),
          Container(
            constraints: const BoxConstraints(minWidth: 10, maxWidth: 100, minHeight: 1,),
            width: lineWidth,
            height: lineHeight,
            alignment: Alignment.centerLeft,
            color: lineColor ?? ThemeColors.surface(context).withValues(alpha: lineOpacity),
          ),
        ],
      ),
    );
  }
}