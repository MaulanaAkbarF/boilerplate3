import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../_animation_config/custom_animate_border.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

class AnimateTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final double? borderSize;
  final EdgeInsets? margin;
  final EdgeInsets? marginTextField;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? prefixOnTap;
  final Function()? suffixOnTap;
  final Color? containerColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final bool? isOnlyBottomBorder;
  final Color? borderAnimationColor;
  final double? containerOpacity;
  final double? borderOpacity;
  final BorderRadius? borderRadius;
  final double? containerRadius;
  final double? borderAnimationRadius;
  final int? animateDuration;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final bool? enabled;
  final bool? isRequired;
  final int? minInput;
  final int? maxInput;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final List<String>? autoFillHint;
  final List<TextInputFormatter>? inputFormatters;

  const AnimateTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.keyboardType,
    this.prefixIcon,
    this.prefixOnTap,
    this.suffixIcon,
    this.suffixOnTap,
    this.labelText,
    this.labelStyle,
    this.inputStyle,
    this.margin,
    this.marginTextField,
    this.containerRadius,
    this.borderRadius,
    this.borderAnimationRadius,
    this.animateDuration,
    this.borderSize,
    this.textAlign,
    this.containerColor,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.isOnlyBottomBorder,
    this.borderAnimationColor,
    this.containerOpacity,
    this.borderOpacity,
    this.autocorrect,
    this.enableSuggestions,
    this.enabled,
    this.isRequired = true,
    this.minInput,
    this.maxInput,
    this.onChanged,
    this.onFieldSubmitted,
    this.autoFillHint,
    this.inputFormatters,
  });

  @override
  AnimateTextFieldState createState() => AnimateTextFieldState();
}

class AnimateTextFieldState extends State<AnimateTextField> with SingleTickerProviderStateMixin {
  late AnimationController? controller;
  late Animation<double> alpha;
  final focusNodeDefault = FocusNode();

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.animateDuration ?? 500),);
    final Animation<double> curve = CurvedAnimation(parent: controller!, curve: Curves.easeInOut);
    alpha = Tween(begin: 0.0, end: 1.0).animate(curve);

    controller?.addListener(() {
      setState(() {});
    });

    widget.focusNode != null ? widget.focusNode!.addListener(() {
      if (widget.focusNode != null){
        if (widget.focusNode!.hasFocus) controller?.forward();
        else controller?.reverse();
      }
    }) : focusNodeDefault.addListener(() {
      if (focusNodeDefault.hasFocus) controller?.forward();
      else controller?.reverse();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> addInputFormatted = widget.inputFormatters?.isNotEmpty ?? false ? List<TextInputFormatter>.from(widget.inputFormatters!) : [];
    if (widget.maxInput != null) addInputFormatted.add(LengthLimitingTextInputFormatter(widget.maxInput));
    if (widget.keyboardType == TextInputType.number) {
      addInputFormatted.add(FilteringTextInputFormatter.digitsOnly);
    } else {
      if (widget.inputFormatters?.isEmpty ?? false) addInputFormatted.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.,-_\s]')));
    }

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.containerColor?.withValues(alpha: widget.containerOpacity ?? 1.0) ?? ThemeColors.onSurface(context),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(widget.containerRadius ?? radiusSquare),
        border: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? null : Border.all(
          color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent,
          width: widget.borderSize ?? 1,
        ),
        boxShadow: widget.shadowColor == null ? [] : [
          BoxShadow(
            color: widget.shadowColor!.withValues(alpha: .1),
            offset: widget.shadowOffset ?? const Offset(0, 1.5),
            blurRadius: widget.shadowBlurRadius ?? shadowBlurLow,
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: widget.borderAnimationColor),
        ),
        child: CustomPaint(
          painter: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? null :
            CustomAnimateBorder(alpha.value, widget.borderAnimationColor ?? Colors.transparent, widget.borderAnimationRadius ?? radiusSquare),
          child: Padding(
            padding: widget.prefixIcon != null ? widget.marginTextField ?? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              cursorColor: ThemeColors.surface(context),
              style: widget.inputStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
              autocorrect: widget.autocorrect ?? false,
              enableSuggestions: widget.enableSuggestions ?? false,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              autofillHints: widget.autoFillHint,
              inputFormatters: addInputFormatted,
              textAlign: widget.textAlign ?? TextAlign.left,
              focusNode: widget.focusNode ?? focusNodeDefault,
              enabled: widget.enabled,
              /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
              /// Global key dideklarasikan masing-masing pada setiap form
              validator: widget.isRequired == false ? null : (value){
                if (value == null || value.trim().isEmpty) return '⚠️  Harap isi data berikut';
                if (widget.minInput != null && value.trim().length < widget.minInput!){
                  if (widget.keyboardType == TextInputType.number) return '⚠️  Harap masukkan lebih dari ${widget.minInput} angka';
                  else return '⚠️  Harap masukkan lebih dari ${widget.minInput} karakter';
                }
                return null;
              },
              decoration: InputDecoration(
                label: cText(context, widget.labelText ?? "", style: widget.labelStyle),
                errorStyle: TextStyles.medium(context).copyWith(color: ThemeColors.red(context), fontWeight: FontWeight.bold),
                prefixIcon: widget.prefixIcon != null ? GestureDetector(onTap: widget.prefixOnTap, child: widget.prefixIcon,) : null,
                suffixIcon: widget.suffixIcon != null ? GestureDetector(onTap: widget.suffixOnTap, child: widget.suffixIcon,) : null,
                border: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent, width: widget.borderSize ?? 1),
                ) : InputBorder.none,
                enabledBorder: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent, width: widget.borderSize ?? 1),
                ) : InputBorder.none,
                focusedBorder: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent, width: widget.borderSize ?? 1),
                ) : InputBorder.none,
                disabledBorder: widget.isOnlyBottomBorder != null && widget.isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor?.withValues(alpha: widget.borderOpacity ?? 1.0) ?? Colors.transparent, width: widget.borderSize ?? 1),
                ) : InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}