import 'package:flutter/material.dart';

import '../../../../ui/layouts/styleconfig/textstyle.dart';
import '../../../../ui/layouts/styleconfig/themecolors.dart';
import '../../../core/constant_values/global_values.dart';

/// Widget untuk menampilkan item-item dari Popup Menu Button
PopupMenuItem popupMenuItem(BuildContext context, String value, String title, IconData iconData, Color color){
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        Icon(iconData, size: iconBtnSmall, color: color),
        SizedBox(width: spaceNear),
        cText(context, title),
      ],
    ),
  );
}

/// Widget untuk menampilkan peringatan validasi pada Widget yang menggunakan validator (seperti RegularTextField/AnimateTextField, CustomDropdown, CustomExpansionTiles dll)
Widget onValidationWarning(BuildContext context, FormFieldState form, String message, {double? paddingTop, double? paddingHorizontal}){
  return Padding(
    padding: EdgeInsets.fromLTRB(paddingHorizontal ?? 0, paddingTop ?? 2, paddingHorizontal ?? 0, 0),
    child: Row(
      children: [
        Icon(Icons.error, size: 16, color: ThemeColors.red(context)),
        const SizedBox(width: 3),
        Expanded(child: cText(context, message)),
      ],
    ),
  );
}

Widget labelRequired(BuildContext context, String title, bool showRequired){
  return Align(
    alignment: Alignment.topLeft,
    child: RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.start,
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(text: title, style: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.bold)),
          const WidgetSpan(child: SizedBox(width: 3)),
          if (showRequired) TextSpan(text: '*', style: TextStyles.medium(context).copyWith(color: ThemeColors.red(context))),
        ],
      ),
    ),
  );
}