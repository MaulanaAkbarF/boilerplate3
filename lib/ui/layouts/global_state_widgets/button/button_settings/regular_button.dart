import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../divider/custom_divider.dart';

class SettingMenuDropdown extends StatefulWidget {
  final String? semantics;
  final String? labelButton;
  final String? labelDescription;
  final EdgeInsets? margin;
  final EdgeInsets? marginButtonLabel;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? width;
  final double? height;
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
  final TextAlign? textAlign;
  final TextStyle? labelButtonStyle;
  final Icon? prefixIcon;
  final bool? fitButton;
  final bool? useSwitch;
  final bool? valueSwitch;
  final ValueChanged<bool?>? onChangedSwitch;
  final List<String> items;
  final String value;
  final ValueChanged<String?>? onChanged;
  final Function(PointerHoverEvent)? onHover;
  final Function(PointerExitEvent)? onExit;

  const SettingMenuDropdown({
    super.key,
    this.semantics,
    this.labelButton,
    this.labelDescription,
    this.margin,
    this.marginButtonLabel,
    this.crossAxisAlignment,
    this.width,
    this.height,
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
    this.textAlign,
    this.labelButtonStyle,
    this.prefixIcon,
    this.fitButton,
    this.useSwitch,
    this.valueSwitch,
    this.onChangedSwitch,
    this.items = const [],
    this.value = '',
    this.onChanged,
    this.onHover,
    this.onExit
  });

  @override
  State<SettingMenuDropdown> createState() => _SettingMenuDropdownState();
}

class _SettingMenuDropdownState extends State<SettingMenuDropdown> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semantics ?? widget.labelButton,
      child: MouseRegion(
        onHover: kIsWeb ? widget.onHover : null,
        onExit: kIsWeb ? widget.onExit : null,
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
          child: Padding(
            padding: widget.marginButtonLabel ?? EdgeInsets.symmetric(horizontal: paddingMid),
            child: Row(
              children: [
                widget.prefixIcon ?? Container(),
                ColumnDivider(space: spaceMid),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
                    children: [
                      cText(context, widget.labelButton ?? 'Item Pengaturan', align: widget.textAlign, maxLines: 1, 
                        style: widget.labelButtonStyle ?? TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.bold),
                      ),
                      if (widget.labelDescription == null) ...[
                        const SizedBox()
                      ] else if (widget.labelDescription != null) ...[
                        cText(context, widget.labelDescription!, align: widget.textAlign, maxLines: 5,
                          style: TextStyles.small(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.w300),
                        ),
                      ]
                    ],
                  ),
                ),
                ColumnDivider(space: spaceMid),
                if (widget.useSwitch != null && widget.valueSwitch != null) Switch(
                  value: widget.valueSwitch!,
                  onChanged: widget.onChangedSwitch,
                ),
                if (widget.useSwitch == null && widget.valueSwitch == null) DropdownButton<String>(
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(radiusSquare),
                  value: widget.value,
                  alignment: Alignment.centerRight,
                  onChanged: widget.onChanged,
                  items: widget.items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: cText(context, value, style: TextStyles.semiMedium(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.w800)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}