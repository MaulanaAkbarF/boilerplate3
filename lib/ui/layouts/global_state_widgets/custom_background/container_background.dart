import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../styleconfig/themecolors.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Color? containerColor;
  final double? containerOpacity;
  final double? containerRadius;
  final BorderRadius? borderRadius;
  final double? borderSize;
  final double? borderOpacity;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;

  const CustomContainer({
    super.key,
    required this.child,
    this.isExpanded = false,
    this.width,
    this.height,
    this.padding,
    this.containerColor,
    this.containerOpacity,
    this.containerRadius,
    this.borderRadius,
    this.borderSize,
    this.borderOpacity,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded == true) {
      return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: width,
            height: height,
            padding: padding ?? EdgeInsets.all(paddingNear),
            decoration: BoxDecoration(
              color: containerColor?.withValues(alpha: containerOpacity ?? 1.0) ?? ThemeColors.onSurface(context),
              borderRadius: borderRadius ?? BorderRadius.circular(containerRadius ?? radiusSquare),
              border: borderColor != null ? Border.all(
                color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent,
                width: borderSize ?? 1,
              ) : null,
              boxShadow: shadowColor == null ? [] : [
                BoxShadow(
                  color: shadowColor!.withValues(alpha: .1),
                  offset: shadowOffset ?? const Offset(0, 1.5),
                  blurRadius: shadowBlurRadius ?? shadowBlurLow,
                ),
              ],
            ),
            child: child,
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(paddingNear),
      decoration: BoxDecoration(
        color: containerColor?.withValues(alpha: containerOpacity ?? 1.0) ?? ThemeColors.onSurface(context),
        borderRadius: borderRadius ?? BorderRadius.circular(containerRadius ?? radiusSquare),
        border: borderColor != null ? Border.all(
          color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent,
          width: borderSize ?? 1,
        ) : null,
        boxShadow: shadowColor == null ? [] : [
          BoxShadow(
            color: shadowColor!.withValues(alpha: .1),
            offset: shadowOffset ?? const Offset(0, 1.5),
            blurRadius: shadowBlurRadius ?? shadowBlurLow,
          ),
        ],
      ),
      child: child,
    );
  }
}
