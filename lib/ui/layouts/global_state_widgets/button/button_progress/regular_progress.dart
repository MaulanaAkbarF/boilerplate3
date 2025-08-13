import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../divider/custom_divider.dart';

class RegularProgressButton extends StatefulWidget {
  final Function onTap;
  final String? semantics;
  final String? labelButton;
  final String? labelProgress;
  final EdgeInsets? margin;
  final EdgeInsets? marginButtonLabel;
  final MainAxisAlignment? mainAxisAlignment;
  final double? width;
  final double? height;
  final Color? progressColor;
  final Color? containerColor;
  final Color? containerColorStart;
  final Color? containerColorEnd;
  final double? containerOpacity;
  final double? containerRadius;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final Color? borderColor;
  final double? borderOpacity;
  final double? borderRadius;
  final double? borderSize;
  final double? xPosition;
  final double? yPosition;
  final TextAlign? textAlign;
  final TextStyle? labelButtonStyle;
  final Icon? icon;
  final Image? image;
  final bool? fitButton;
  final bool? useArrow;
  final bool? useInkWell;
  final Color? splashColorInkWell;
  final Color? highlightColorInkWell;

  const RegularProgressButton({
    super.key,
    required this.onTap,
    this.semantics,
    this.labelButton,
    this.labelProgress,
    this.margin,
    this.marginButtonLabel,
    this.mainAxisAlignment,
    this.width,
    this.height,
    this.progressColor,
    this.containerColor,
    this.containerColorStart,
    this.containerColorEnd,
    this.containerOpacity,
    this.containerRadius,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.borderColor,
    this.borderOpacity,
    this.borderRadius,
    this.borderSize,
    this.xPosition,
    this.yPosition,
    this.textAlign,
    this.labelButtonStyle,
    this.icon,
    this.image,
    this.fitButton,
    this.useArrow,
    this.useInkWell = true,
    this.splashColorInkWell,
    this.highlightColorInkWell,
  });

  @override
  RegularProgressButtonState createState() => RegularProgressButtonState();
}

class RegularProgressButtonState extends State<RegularProgressButton> with SingleTickerProviderStateMixin {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semantics ?? widget.labelButton,
      child: Container(
        margin: widget.margin,
        width: widget.fitButton != null && widget.fitButton! ? widget.width : null,
        height: widget.height ?? heightTall,
        constraints: const BoxConstraints(minHeight: 20),
        decoration: BoxDecoration(
          gradient: (widget.containerColorStart != null && widget.containerColorEnd != null)
              ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [widget.containerColorStart ?? Colors.transparent, widget.containerColorEnd ?? Colors.transparent]) : null,
          color: (widget.containerColorStart != null && widget.containerColorEnd != null) ? null
              : widget.containerColor != null ? widget.containerColor?.withValues(alpha: widget.containerOpacity
              ?? (widget.containerColor! == Colors.transparent ? 0.0 : 1.0)) : ThemeColors.surface(context),
          borderRadius: BorderRadius.circular(widget.containerRadius ?? radiusSquare),
          border: Border.all(color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent, width: widget.borderSize ?? 1),
          boxShadow: widget.shadowColor == null ? [] : [
            BoxShadow(
              color: widget.shadowColor!.withValues(alpha: .15),
              offset: widget.shadowOffset ?? const Offset(0, 1),
              blurRadius: widget.shadowBlurRadius ?? shadowBlurLow,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.containerRadius ?? radiusSquare),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashColor: widget.useInkWell != null && widget.useInkWell!
                  ? widget.splashColorInkWell != null ? widget.splashColorInkWell! : ThemeColors.surface(context).withValues(alpha: 0.2) : Colors.transparent,
              highlightColor: widget.useInkWell != null && widget.useInkWell!
                  ? widget.highlightColorInkWell != null ? widget.highlightColorInkWell! : ThemeColors.surface(context).withValues(alpha: 0.4) : Colors.transparent,
              onTap: () async {
                if (!_loading) {
                  setState(() => _loading = true);
                  await widget.onTap();
                  setState(() => _loading = false);
                }
              },
              child: Padding(
                padding: widget.marginButtonLabel ?? EdgeInsets.symmetric(horizontal: paddingMid),
                child: Row(
                  mainAxisSize: widget.fitButton != null && widget.fitButton! ? MainAxisSize.min : MainAxisSize.max,
                  mainAxisAlignment: widget.mainAxisAlignment != null ? widget.mainAxisAlignment!
                      : widget.useArrow != null && widget.useArrow! ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    if (_loading) SizedBox(
                      width: widget.height != null ? widget.height! * 0.5 : 20,
                      height: widget.height != null ? widget.height! * 0.5 : 20,
                      child: LoadingAnimationWidget.discreteCircle(
                        color: widget.progressColor ?? ThemeColors.surface(context),
                        size: widget.height != null ? widget.height! * 0.5 : 20,
                        secondRingColor: ThemeColors.blue(context),
                        thirdRingColor: ThemeColors.green(context)
                      ),
                    ),
                    if (_loading) RowDivider(),
                    if (!_loading) widget.image ?? (widget.icon ?? SizedBox()),
                    if (!_loading && widget.icon != null || !_loading && widget.image != null) RowDivider(),

                    if (widget.useArrow != null && widget.useArrow!)
                      Expanded(
                        child: cText(
                          context,
                          _loading ? widget.labelProgress ?? 'Memproses' : widget.labelButton ?? 'Konfirmasi',
                          align: widget.textAlign,
                          maxLines: 2,
                          style: widget.labelButtonStyle ?? TextStyles.large(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      cText(
                        context,
                        _loading ? widget.labelProgress ?? 'Memproses' : widget.labelButton ?? 'Konfirmasi',
                        align: widget.textAlign,
                        maxLines: 2,
                        style: widget.labelButtonStyle ?? TextStyles.large(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),

                    if (widget.useArrow != null && widget.useArrow!) Icon(Icons.arrow_forward_ios_rounded, size: iconBtnSmall, color: ThemeColors.surface(context))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}