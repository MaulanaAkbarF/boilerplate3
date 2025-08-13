import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/utilities/functions/media_query_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../textfield_form/animate_form.dart';

class AnimateTypeAhead<T> extends StatefulWidget {
  final List<T> data;
  final String labelText;
  final String? emptyText;
  final TextInputType? keyboardType;
  final bool? onlyBottomBorder;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;
  final bool? isRequired;
  final String Function(T) suggestionCallback;
  final void Function(T) onSelected;

  const AnimateTypeAhead({
    super.key,
    required this.data,
    required this.labelText,
    this.emptyText,
    this.keyboardType,
    this.onlyBottomBorder,
    this.iconData,
    this.iconSize,
    this.iconColor,
    this.isRequired = true,
    required this.suggestionCallback,
    required this.onSelected,
  });

  @override
  AnimateTypeAheadState<T> createState() => AnimateTypeAheadState<T>();
}

class AnimateTypeAheadState<T> extends State<AnimateTypeAhead<T>> with SingleTickerProviderStateMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsCallback: (pattern) async => widget.data.where((item) => widget.suggestionCallback(item).toLowerCase().contains(pattern.toLowerCase())).toList(),
      builder: (context, controller, focusNode) {
        return Padding(
          padding: const EdgeInsets.only(bottom: paddingMid),
          child: AnimateTextField(
            controller: FocusScope.of(context).hasFocus ? controller : _controller,
            focusNode: focusNode,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            labelText: widget.labelText,
            shadowColor: ThemeColors.surface(context),
            isRequired: widget.isRequired,
            suffixIcon: _controller.text.isNotEmpty ? Icon(Icons.cancel, color: ThemeColors.red(context), size: iconBtnSmall) : null,
            suffixOnTap: () {
              _controller.clear();
              controller.clear();
            },
          ),
        );
      },
      constraints: BoxConstraints(maxHeight: getMediaQueryHeight(context, size: .5)),
      itemBuilder: (context, suggestion) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          minVerticalPadding: 0,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: widget.iconData != null ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
            child: Icon(widget.iconData, size: widget.iconSize ?? iconBtnSmall * 0.75, color: widget.iconColor ?? ThemeColors.greenLowContrast(context)),
          ) : null,
          title: cText(context, widget.suggestionCallback(suggestion), maxLines: 2, style: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
        );
      },
      onSelected: (selected) {
        _controller.text = widget.suggestionCallback(selected);
        widget.onSelected(selected);
        FocusScope.of(context).unfocus();
      },
      emptyBuilder: (context){
        return Padding(
          padding: const EdgeInsets.all(paddingMid),
          child: cText(context, widget.emptyText ?? 'Tidak ada data ditemukan', maxLines: 2, style: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)))
        );
      },
      errorBuilder: (context, error){
        return Padding(
          padding: const EdgeInsets.all(paddingMid),
          child: cText(context, '$error', maxLines: 2, style: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)))
        );
      },
    );
  }
}