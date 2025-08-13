import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/utilities/functions/logger_func.dart';
import '../../global_return_widgets/helper_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

enum RadioButtonLayout { horizontal, vertical }

class CustomRadioButtonGroup extends StatefulWidget {
  final List<String> listRadioItem;
  final void Function(String) onSelected;
  final int? selectedIndex;
  final bool enabled;
  final bool? isRequired;
  final FormFieldValidator<int?>? validator;
  final RadioButtonLayout radioButtonLayout;

  const CustomRadioButtonGroup({
    super.key,
    required this.listRadioItem,
    required this.onSelected,
    this.selectedIndex,
    this.enabled = true,
    this.isRequired = true,
    this.validator,
    this.radioButtonLayout = RadioButtonLayout.horizontal,
  });

  @override
  CustomRadioButtonGroupState createState() => CustomRadioButtonGroupState();
}

class CustomRadioButtonGroupState extends State<CustomRadioButtonGroup> {
  late int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? -1;
  }

  @override
  void didUpdateWidget(CustomRadioButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) setState(() => _selectedIndex = widget.selectedIndex != -1 ? widget.selectedIndex : null);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<int?>(
      initialValue: _selectedIndex,
      /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
      /// Global key dideklarasikan masing-masing pada setiap form
      validator: widget.validator ?? ((widget.isRequired == false) ? null : (value) {
        if (value == null || value == -1) return "Harap pilih salah satu opsi";
        return null;
      }),
      builder: (FormFieldState<int?> formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.radioButtonLayout == RadioButtonLayout.vertical ? _buildVerticalLayout(formFieldState) : _buildHorizontalLayout(formFieldState),
            if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap pilih salah satu opsi"),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalLayout(FormFieldState<int?> formFieldState) {
    return Column(children: _buildRows(formFieldState));
  }

  Widget _buildVerticalLayout(FormFieldState<int?> formFieldState) {
    return Column(
      children: List.generate(widget.listRadioItem.length, (index) {
        return RadioListTile<int>(
          contentPadding: EdgeInsets.zero,
          activeColor: ThemeColors.blueLowContrast(context),
          title: cText(context, widget.listRadioItem[index], maxLines: 5, style: TextStyles.semiMedium(context).copyWith(fontWeight: FontWeight.normal, color: ThemeColors.surface(context))),
          value: index,
          groupValue: _selectedIndex,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare * .75)),
          onChanged: (value) {
            if (widget.enabled) {
              setState(() {
                _selectedIndex = value;
                formFieldState.didChange(value);
                formFieldState.validate();
              });
              if (value != null) widget.onSelected(widget.listRadioItem[index]);
            } else {
              clog('Radio Button Disable');
            }
          },
        );
      }),
    );
  }

  List<Widget> _buildRows(FormFieldState<int?> formFieldState) {
    List<Widget> rows = [];
    for (int i = 0; i < widget.listRadioItem.length; i += 4) {
      rows.add(Row(children: _buildRadioButtons(i, min(i + 3, widget.listRadioItem.length), formFieldState)));
      if (i + 3 < widget.listRadioItem.length) {
        rows.add(Row(children: _buildRadioButtons(i + 3, min(i + 4, widget.listRadioItem.length), formFieldState)));
      }
    }
    return rows;
  }

  List<Widget> _buildRadioButtons(int start, int end, FormFieldState<int?> formFieldState) {
    return List.generate(end - start, (index) => Expanded(
        child: RadioListTile<int>(
          contentPadding: EdgeInsets.zero,
          activeColor: ThemeColors.blueLowContrast(context),
          title: cText(context, widget.listRadioItem[start + index], maxLines: 5, style: TextStyles.semiMedium(context).copyWith(fontWeight: FontWeight.normal, color: ThemeColors.surface(context))),
          value: start + index,
          groupValue: _selectedIndex,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare * .75)),
          onChanged: (value) {
            if (widget.enabled) {
              setState(() {
                _selectedIndex = value;
                formFieldState.didChange(value);
                formFieldState.validate();
              });
              if (value != null) widget.onSelected(widget.listRadioItem[start + index]);
            } else {
              clog('Radio Button Disable');
            }
          },
        )),
    );
  }
}