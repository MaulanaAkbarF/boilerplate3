import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import 'animate_password.dart';

class RegularPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final double? borderSize;
  final EdgeInsets? margin;
  final EdgeInsets? marginTextField;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? labelTextField;
  final int? maxLinesLabel;
  final String? hintText;
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
  final double? containerOpacity;
  final double? borderOpacity;
  final BorderRadius? borderRadius;
  final double? containerRadius;
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

  const RegularPasswordField({
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
    this.labelTextField,
    this.maxLinesLabel,
    this.hintText,
    this.inputStyle,
    this.margin,
    this.marginTextField,
    this.containerRadius,
    this.borderRadius,
    this.borderSize,
    this.textAlign,
    this.containerColor,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.isOnlyBottomBorder,
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
  RegularPasswordFieldState createState() => RegularPasswordFieldState();
}

class RegularPasswordFieldState extends State<RegularPasswordField> with SingleTickerProviderStateMixin {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (widget.labelText != null && widget.labelText!.isNotEmpty) {
      widgets.add(cText(context, widget.labelText!, maxLines: widget.maxLinesLabel ?? 2, style: widget.labelStyle));
      widgets.add(const SizedBox(height: 5));
    }

    List<TextInputFormatter> addInputFormatted = widget.inputFormatters?.isNotEmpty ?? false ? List<TextInputFormatter>.from(widget.inputFormatters!) : [];
    if (widget.maxInput != null) addInputFormatted.add(LengthLimitingTextInputFormatter(widget.maxInput));
    if (widget.keyboardType == TextInputType.number) {
      addInputFormatted.add(FilteringTextInputFormatter.digitsOnly);
    }

    widgets.add(Container(
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
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: Padding(
          padding: widget.prefixIcon != null ? widget.marginTextField ?? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: widget.controller,
            obscureText: obscure,
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
            focusNode: widget.focusNode,
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
              hintText: widget.labelTextField == null ? widget.hintText : 'Lengkapi Data Berikut',
              label: widget.labelTextField != null ? Text(widget.labelTextField ?? "", style: widget.labelStyle ??
                  TextStyles.medium(context).copyWith(color: ThemeColors.greyHighContrast(context).withValues(alpha: 0.8))) : null,
              errorStyle: TextStyles.medium(context).copyWith(color: ThemeColors.red(context), fontWeight: FontWeight.bold),
              prefixIcon: widget.prefixIcon != null ? GestureDetector(onTap: widget.prefixOnTap, child: widget.prefixIcon,) : null,
              suffixIcon: SuffixIconButton(obscureText: obscure,  onPressed: () => setState(() { obscure = !obscure;})),
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
    ));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets);
  }
}