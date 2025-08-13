import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../global_return_widgets/helper_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';
import '../divider/custom_divider.dart';
import 'expansion_tile.dart';

class CustomDropdown extends StatefulWidget {
  final String? initialText;
  final List<Expansion> expansionList;
  final void Function(Expansion) onSelected;
  final String? labelText;
  final TextStyle? labelStyle;
  final int? maxLinesLabel;
  final BorderRadius? borderRadius;
  final double? borderSize;
  final Color? containerColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final double? containerOpacity;
  final double? containerRadius;
  final double? borderOpacity;
  final bool? isOnlyBottomBorder;
  final bool? isRequired;
  final FormFieldValidator<bool>? validator;

  const CustomDropdown({
    super.key,
    this.initialText,
    required this.expansionList,
    required this.onSelected,
    this.labelText,
    this.labelStyle,
    this.maxLinesLabel,
    this.borderRadius,
    this.borderSize,
    this.containerColor,
    this.borderOpacity,
    this.isOnlyBottomBorder,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.containerOpacity,
    this.containerRadius,
    this.isRequired = true,
    this.validator,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late bool isSelected;
  String? _selectedValue;

  @override
  void initState() {
    isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: isSelected,
      /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
      /// Global key dideklarasikan masing-masing pada setiap form
      validator: widget.validator ?? ((widget.isRequired == false) ? null : (value){
        if (value == null || !value) return "Harap pilih salah satu opsi";
        return null;
      }),
      builder: (FormFieldState<bool> formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)...[
              cText(context, widget.labelText!, maxLines: widget.maxLinesLabel ?? 2, style: widget.labelStyle),
              ColumnDivider(space: 5)
            ],
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                value: _selectedValue,
                items: widget.expansionList.map((Expansion expansion) => DropdownMenuItem<String>(
                  value: expansion.text,
                  child: cText(context, expansion.text),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedValue = value;
                    });
                    formFieldState.didChange(_selectedValue != null);
                    formFieldState.validate();
                    widget.onSelected(Expansion(text: value));
                  }
                },
                customButton: Container(
                  constraints: BoxConstraints(minHeight: heightTall),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingNear),
                    child: Row(
                      children: [
                        Icon(Icons.menu_outlined, size: iconBtnSmall * 1.2, color: ThemeColors.blue(context)),
                        RowDivider(),
                        Expanded(child: cText(context, _selectedValue ?? widget.initialText ?? 'Pilih Salah Satu')),
                      ],
                    ),
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  height: heightTall,
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
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                  iconSize: iconBtnSmall,
                  iconEnabledColor: ThemeColors.green(context),
                  iconDisabledColor: ThemeColors.greenLowContrast(context),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: getMediaQueryHeight(context) * .4,
                  width: getMediaQueryWidth(context) * .933,
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
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all<double>(6),
                    thumbVisibility: WidgetStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: heightMid,
                  padding: EdgeInsets.symmetric(horizontal: paddingFar),
                ),
              ),
            ),
            if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap pilih salah satu opsi", paddingTop: 5),
          ],
        );
      }
    );
  }
}

class CustomDropdownMultiselect extends StatefulWidget {
  final String? initialText;
  final List<Expansion> expansionList;
  final void Function(List<Expansion>) onSelected;
  final String? labelText;
  final TextStyle? labelStyle;
  final int? maxLinesLabel;
  final BorderRadius? borderRadius;
  final double? borderSize;
  final Color? containerColor;
  final Color? borderColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? shadowBlurRadius;
  final double? containerOpacity;
  final double? containerRadius;
  final double? borderOpacity;
  final bool? isOnlyBottomBorder;
  final bool? isRequired;
  final int? minSelectedOption;
  final FormFieldValidator<List<String>>? validator;

  const CustomDropdownMultiselect({
    super.key,
    this.initialText,
    required this.expansionList,
    required this.onSelected,
    this.labelText,
    this.labelStyle,
    this.maxLinesLabel,
    this.borderRadius,
    this.borderSize,
    this.containerColor,
    this.borderOpacity,
    this.isOnlyBottomBorder,
    this.borderColor,
    this.shadowColor,
    this.shadowOffset,
    this.shadowBlurRadius,
    this.containerOpacity,
    this.containerRadius,
    this.isRequired = true,
    this.minSelectedOption,
    this.validator,
  });

  @override
  State<CustomDropdownMultiselect> createState() => _CustomDropdownMultiselectState();
}

class _CustomDropdownMultiselectState extends State<CustomDropdownMultiselect> {
  final List<String> _selectedValues = [];

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: _selectedValues,
      validator: widget.validator ?? (value) {
        if (widget.isRequired == false) return null;
        final minOptions = widget.minSelectedOption ?? 1;
        if (value == null || value.isEmpty) return "Harap pilih setidaknya $minOptions opsi";
        if (value.length < minOptions) return "Pilih minimal $minOptions opsi";
        return null;
      },
      builder: (FormFieldState<List<String>> formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)...[
              cText(context, widget.labelText!, maxLines: widget.maxLinesLabel ?? 2, style: widget.labelStyle),
              ColumnDivider(space: 5)
            ],
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                value: _selectedValues.isEmpty ? null : _selectedValues.last,
                items: widget.expansionList.map((Expansion expansion) {
                  return DropdownMenuItem<String>(
                    value: expansion.text,
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = _selectedValues.contains(expansion.text);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedValues.remove(expansion.text);
                              } else {
                                _selectedValues.add(expansion.text);
                              }
                              formFieldState.didChange(_selectedValues);
                              formFieldState.validate();
                            });
                            menuSetState(() {});
                            widget.onSelected(_selectedValues.map((text) => Expansion(text: text)).toList());
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: paddingFar),
                            child: Row(
                              children: [
                                if (isSelected) const Icon(Icons.check_box_outlined, color: Colors.green)
                                else const Icon(Icons.check_box_outline_blank, color: Colors.grey),
                                const SizedBox(width: 16),
                                Expanded(child: cText(context, expansion.text)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                onChanged: (value) {},
                customButton: Container(
                  constraints: BoxConstraints(minHeight: heightTall),
                  decoration: BoxDecoration(
                    color: widget.containerColor?.withValues(alpha: widget.containerOpacity ?? 1.0) ??
                        ThemeColors.onSurface(context),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingNear),
                    child: Row(
                      children: [
                        Icon(Icons.menu_outlined, size: iconBtnSmall * 1.2, color: ThemeColors.blue(context)),
                        RowDivider(),
                        Expanded(child: cText(context, _selectedValues.isEmpty ? widget.initialText != null
                            ? widget.initialText!
                            : widget.minSelectedOption != null
                              ? 'Pilih minimal ${widget.minSelectedOption} opsi' : 'Pilih Salah Satu'
                              : _selectedValues.join(', '))),
                      ],
                    ),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  iconSize: iconBtnSmall,
                  iconEnabledColor: ThemeColors.green(context),
                  iconDisabledColor: ThemeColors.greenLowContrast(context),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: getMediaQueryHeight(context) * .4,
                  width: getMediaQueryWidth(context) * .933,
                  decoration: BoxDecoration(
                    color: widget.containerColor?.withValues(alpha: widget.containerOpacity ?? 1.0) ??
                        ThemeColors.onSurface(context),
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
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all<double>(6),
                    thumbVisibility: WidgetStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: heightMid,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap pilih salah satu opsi", paddingTop: 5),
          ],
        );
      }
    );
  }
}