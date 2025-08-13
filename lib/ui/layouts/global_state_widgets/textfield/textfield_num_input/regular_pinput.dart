import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../global_return_widgets/helper_widgets_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';

class RegularPinput extends StatelessWidget {
  final TextEditingController controller;
  final int pinLength;
  final double? width;
  final double? height;
  final bool? isRequired;
  final FormFieldValidator<String>? validator;
  final void Function(String) onComplete;

  const RegularPinput({
    super.key,
    required this.controller,
    required this.pinLength,
    this.width,
    this.height,
    this.isRequired = true,
    this.validator,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: width ?? 60,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: ThemeColors.onSurface(context),
        borderRadius: BorderRadius.circular(radiusSquare),
        border: Border.all(color: ThemeColors.blueHighContrast(context), width: 2),
      ),
      textStyle: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: ThemeColors.blueVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare),
        border: Border.all(color: ThemeColors.blueHighContrast(context), width: 2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.circular(radiusSquare),
        border: Border.all(color: ThemeColors.blueHighContrast(context), width: 2),
      ),
    );

    return FormField<String>(
      initialValue: controller.text,
      /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
      /// Global key dideklarasikan masing-masing pada setiap form
      validator: validator ?? ((isRequired == false) ? null : (value) {
        if (value == null || value.length < pinLength) return "Harap masukkan PIN lengkap ($pinLength digit)";
        return null;
      }),
      builder: (FormFieldState<String> formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              controller: controller,
              defaultPinTheme: defaultPinTheme,
              submittedPinTheme: submittedPinTheme,
              focusedPinTheme: focusedPinTheme,
              length: pinLength,
              onChanged: (value) {
                formFieldState.didChange(value);
                formFieldState.validate();
              },
              onCompleted: (value) {
                formFieldState.didChange(value);
                formFieldState.validate();
                onComplete(value);
              },
            ),
            if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap masukkan PIN lengkap ($pinLength digit)"),
          ],
        );
      },
    );
  }
}