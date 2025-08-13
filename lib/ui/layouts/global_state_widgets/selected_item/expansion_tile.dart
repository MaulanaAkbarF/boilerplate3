import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../global_return_widgets/helper_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';
import '../divider/custom_divider.dart';

class CustomExpansionTile extends StatefulWidget {
  final String? initialText;
  final List<Expansion> expansionList;
  final TextStyle? textStyle;
  final Widget? child;
  final Icon? iconList;
  final TextStyle? styleList;
  final double? maxHeight;
  final bool? canItemBeSelected;
  final bool? enabled;
  final bool? isRequired;
  final FormFieldValidator<bool>? validator;
  final void Function(Expansion) onSelected;

  const CustomExpansionTile({
    super.key,
    this.initialText,
    required this.expansionList,
    this.textStyle,
    this.child,
    this.iconList,
    this.styleList,
    this.maxHeight,
    this.canItemBeSelected = true,
    this.enabled,
    this.isRequired = true,
    this.validator,
    required this.onSelected
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool isSelected;
  String selectedItemText = 'Pilih Salah Satu';

  @override
  void initState() {
    isSelected = false;
    if (widget.initialText != null) selectedItemText = widget.initialText!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: isSelected,
      /// Pakai widget Form dan deklarasikan global key-nya untuk mengaktifkan validator.
      /// Global key dideklarasikan masing-masing pada setiap form
      validator: widget.validator ?? ((widget.isRequired == false) ? null : (value){
        if (value == null || !value) return "Harap pilih data berikut";
        return null;
      }),
      builder: (FormFieldState<bool> formFieldState) {
        return Opacity(
          opacity: widget.enabled != null && widget.enabled == false ? .5 : 1.0,
          child: Column(
            children: [
              ExpansionTile(
                expansionAnimationStyle: AnimationStyle(
                  curve: Curves.easeInOutCubic,
                  duration: Duration(milliseconds: 600),
                  reverseCurve: Curves.easeInOutCubic,
                  reverseDuration: Duration(milliseconds: 300),
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: paddingMid),
                enabled: widget.enabled ?? true,
                showTrailingIcon: widget.enabled ?? true,
                shape: InputBorder.none,
                title: Container(
                  padding: const EdgeInsets.only(bottom: paddingMid),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ThemeColors.grey(context),),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(radiusSquare)),
                    child: Padding(
                      padding: const EdgeInsets.all(paddingMid),
                      child: cText(context, selectedItemText, style: widget.textStyle != null ? widget.textStyle!
                        : TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.blueHighContrast(context))),
                    ),
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxHeight: getMediaQueryHeight(context, size: widget.maxHeight ?? .5)),
                    padding: EdgeInsets.all(paddingNear),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radiusSquare),
                      border: Border.all(
                        color: ThemeColors.greyVeryLowContrast(context),
                        width: 1,
                      )
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: widget.child != null ? widget.child! : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.expansionList.map((item){
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(radiusSquare * .5),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: (){
                                  if (widget.canItemBeSelected == true){
                                    widget.onSelected(item);
                                    setState(() {
                                      selectedItemText = item.text;
                                      isSelected = true;
                                      formFieldState.didChange(true);
                                      formFieldState.validate();
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(paddingMid),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (widget.iconList != null) ...[
                                        widget.iconList!,
                                        RowDivider(space: paddingMid)
                                      ],
                                      Expanded(child: cText(context, item.text, style: widget.styleList != null ? widget.styleList!
                                          : TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.blueHighContrast(context)))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                    ),
                  ))
                ],
              ),
              if (formFieldState.hasError) onValidationWarning(context, formFieldState, formFieldState.errorText ?? "Harap pilih data berikut"),
            ],
          ),
        );
      }
    );
  }
}

class Expansion {
  static int _counter = 0;
  int id;
  String text;

  Expansion({required this.text}) : id = _counter++;

  factory Expansion.fromJson(Map<String, dynamic> json) => Expansion(text: json['text'])..id = json['id'];
  Map<String, dynamic> toJson() => {'id': id, 'text': text};
}
