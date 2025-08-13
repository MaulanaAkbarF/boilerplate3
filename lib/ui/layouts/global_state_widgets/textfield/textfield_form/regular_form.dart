import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

class RegularTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final EdgeInsets? margin;
  final EdgeInsets? marginTextField;
  final BorderRadius? borderRadius;
  final double? borderSize;
  final TextAlign? textAlign;
  final String? labelText;
  final String? labelTextField;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final int? maxLinesLabel;
  final String? hintText;
  final Icon? prefixIcon;
  final Function()? prefixOnTap;
  final Icon? suffixIcon;
  final Function()? suffixOnTap;
  final Color? containerColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final double? containerOpacity;
  final double? borderOpacity;
  final bool? isOnlyBottomBorder;
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

  const RegularTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.keyboardType,
    this.labelText,
    this.labelTextField,
    this.labelStyle,
    this.inputStyle,
    this.maxLinesLabel,
    this.hintText,
    this.prefixIcon,
    this.prefixOnTap,
    this.suffixIcon,
    this.suffixOnTap,
    this.margin,
    this.marginTextField,
    this.borderRadius,
    this.borderSize,
    this.textAlign,
    this.containerColor,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.containerOpacity,
    this.borderOpacity,
    this.isOnlyBottomBorder,
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
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (labelText != null && labelText!.isNotEmpty) {
      widgets.add(cText(context, labelText!, maxLines: maxLinesLabel ?? 2, style: labelStyle));
      widgets.add(const SizedBox(height: 5));
    }

    List<TextInputFormatter> addInputFormatted = inputFormatters?.isNotEmpty ?? false ? List<TextInputFormatter>.from(inputFormatters!) : [];
    if (maxInput != null) addInputFormatted.add(LengthLimitingTextInputFormatter(maxInput));
    if (keyboardType == TextInputType.number) {
      addInputFormatted.add(FilteringTextInputFormatter.digitsOnly);
    } else {
      if (inputFormatters?.isEmpty ?? false) addInputFormatted.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.,-_\s]')));
    }

    widgets.add(
      Container(
        margin: margin,
        decoration: BoxDecoration(
          color: containerColor?.withValues(alpha: containerOpacity ?? 1.0) ?? ThemeColors.onSurface(context),
          borderRadius: borderRadius ?? BorderRadius.circular(radiusSquare),
          border: Border.all(
            color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent,
            width: borderSize ?? 1,
          ),
          boxShadow: shadowColor == null ? [] : [
            BoxShadow(
              color: shadowColor!.withValues(alpha: .1),
              offset: shadowOffset ?? const Offset(0, 1.5),
              blurRadius: shadowBlurRadius ?? shadowBlurLow,
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: Padding(
            padding: prefixIcon != null ? marginTextField ?? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: ThemeColors.surface(context),
              style: inputStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
              autocorrect: autocorrect ?? false,
              enableSuggestions: enableSuggestions ?? false,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              autofillHints: autoFillHint,
              inputFormatters: addInputFormatted,
              textAlign: textAlign ?? TextAlign.left,
              focusNode: focusNode,
              enabled: enabled,
              /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
              /// Global key dideklarasikan masing-masing pada setiap form
              validator: isRequired == false ? null : (value){
                if (value == null || value.trim().isEmpty) return '⚠️  Harap isi data berikut';
                if (minInput != null && value.trim().length < minInput!){
                  if (keyboardType == TextInputType.number) return '⚠️  Harap masukkan lebih dari ${minInput} angka';
                  else return '⚠️  Harap masukkan lebih dari ${minInput} karakter';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: labelTextField == null ? hintText : null,
                label: labelTextField != null ? Text(labelTextField ?? "", style: labelStyle ??
                    TextStyles.medium(context).copyWith(color: ThemeColors.greyHighContrast(context).withValues(alpha: 0.8))) : null,
                errorStyle: TextStyles.medium(context).copyWith(color: ThemeColors.red(context), fontWeight: FontWeight.bold),
                prefixIcon: prefixIcon != null ? GestureDetector(onTap: prefixOnTap, child: prefixIcon,) : null,
                suffixIcon: suffixIcon != null ? GestureDetector(onTap: suffixOnTap, child: suffixIcon,) : null,
                border: isOnlyBottomBorder != null && isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent, width: borderSize ?? 1),
                ) : InputBorder.none,
                enabledBorder: isOnlyBottomBorder != null && isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent, width: borderSize ?? 1),
                ) : InputBorder.none,
                focusedBorder: isOnlyBottomBorder != null && isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent, width: borderSize ?? 1),
                ) : InputBorder.none,
                disabledBorder: isOnlyBottomBorder != null && isOnlyBottomBorder! ? UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor?.withValues(alpha: borderOpacity ?? 1.0) ?? Colors.transparent, width: borderSize ?? 1),
                ) : InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets);
  }
}