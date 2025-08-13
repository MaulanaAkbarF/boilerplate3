import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../global_return_widgets/media_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';
import '../divider/custom_divider.dart';

class CustomSidebarXMain extends StatelessWidget {
  final SidebarXController controller;
  final List<SidebarXItem> items;

  const CustomSidebarXMain({super.key, required this.controller, required this.items});

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      showToggleButton: true,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(paddingFar),
        textStyle: TextStyles.medium(context),
        itemMargin: const EdgeInsets.symmetric(horizontal: paddingMid),
        iconTheme: IconThemeData(color: ThemeColors.surface(context), size: iconBtnSmall),
        decoration: BoxDecoration(color: ThemeColors.greyLowContrast(context), borderRadius: BorderRadius.circular(radiusSquare)),
        itemPadding: const EdgeInsets.all(paddingFar),
        itemDecoration: BoxDecoration(borderRadius: BorderRadius.circular(radiusSharp)),
        itemTextPadding: const EdgeInsets.only(left: paddingMid),
        hoverColor: ThemeColors.blueVeryLowContrast(context).withValues(alpha: .5),
        hoverTextStyle: TextStyles.medium(context),
        selectedItemPadding: const EdgeInsets.all(paddingFar),
        selectedItemTextPadding: const EdgeInsets.only(left: paddingMid),
        selectedItemMargin: const EdgeInsets.symmetric(horizontal: paddingMid),
        selectedTextStyle: TextStyles.semiLarge(context),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusSharp),
          gradient: LinearGradient(colors: [ThemeColors.blueVeryLowContrast(context), ThemeColors.blueLowContrast(context)]),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.28), blurRadius: 30)
          ],
        ),
        selectedIconTheme: IconThemeData(color: ThemeColors.surface(context), size: iconBtnSmall),
      ),
      extendedTheme: SidebarXTheme(width: 300, decoration: BoxDecoration(color: ThemeColors.greyVeryLowContrast(context))),
      footerDivider:  Divider(color: ThemeColors.onSurface(context).withValues(alpha: 0.3), height: 1),
      headerBuilder: (context, extended) {
        return Container(
          constraints: BoxConstraints(maxHeight: 150),
          padding: const EdgeInsets.all(paddingMid),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loadDefaultAppLogoPNG(sizeLogo: 60),
              ColumnDivider(),
              cText(context, 'Maulana Akbar', align: TextAlign.center, maxLines: 1, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
              cText(context, 'maulana@mail.com', align: TextAlign.center, maxLines: 1, style: TextStyles.medium(context).copyWith(color: ThemeColors.grey(context))),
            ],
          ),
        );
      },
      items: items,
    );
  }
}
