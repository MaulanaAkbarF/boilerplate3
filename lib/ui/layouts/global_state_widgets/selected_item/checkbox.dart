import 'dart:core';

import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../global_return_widgets/helper_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

class CustomCheckbox extends StatefulWidget {
  final String value;
  final ValueChanged<bool?> onChanged;
  final bool? initialValue;
  final bool? isRequired;
  final Color? onCheckedColor;
  final Color? backgroundColor;
  final FormFieldValidator<bool>? validator;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.initialValue = false,
    this.isRequired = true,
    this.onCheckedColor,
    this.backgroundColor,
    this.validator,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialValue!;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: isSelected,
      /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
      /// Global key dideklarasikan masing-masing pada setiap form
      validator: widget.validator ?? ((widget.isRequired == false) ? null : (value){
        if (value == null || !value) return "Harap centang data berikut";
        return null;
      }),
      builder: (FormFieldState<bool> formFieldState) {
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: isSelected,
                contentPadding: EdgeInsets.zero,
                onChanged: (newValue) {
                  setState(() {
                    isSelected = newValue ?? false;
                    widget.onChanged(newValue);
                    formFieldState.didChange(newValue);
                    formFieldState.validate();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: cText(context, widget.value),
                activeColor: widget.onCheckedColor ?? ThemeColors.blueHighContrast(context),
                tileColor: widget.backgroundColor ?? Colors.transparent,
                dense: true,
                visualDensity: VisualDensity.compact,
                checkboxScaleFactor: 1.2,
                checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare * .33)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare * .75)),
              ),
              if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap centang data berikut"),
            ],
          ),
        );
      },
    );
  }
}