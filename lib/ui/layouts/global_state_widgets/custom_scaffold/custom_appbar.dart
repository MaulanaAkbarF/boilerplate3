import 'package:flutter/material.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../global_return_widgets/media_widgets_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';
import '../divider/custom_divider.dart';

SliverAppBar sliverAppBarWidget({
  required BuildContext context,
  required String imagePath,
  String? title,
  bool? showAppLogo,
  Widget? leading,
  List<Widget>? actions,
}) {
  return SliverAppBar(
    expandedHeight: 300,
    leading: leading ?? GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(paddingMid),
            child: Icon(Icons.arrow_circle_left_outlined, color: ThemeColors.onSurface(context), size: iconBtnMid),
          ),
        )
    ),
    title: showAppLogo != null && showAppLogo
        ? loadDefaultAppLogoPNG()
        : title != null
        ? Text(title, maxLines: 1, style: TextStyles.large(context).copyWith(fontWeight: FontWeight.w700, color: ThemeColors.onSurface(context)))
        : null,
    actions: actions,
    flexibleSpace: Image.network(imagePath, height: getMediaQueryHeight(context, size: .2), fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(height: getMediaQueryHeight(context, size: .2), width: double.infinity, color: Colors.transparent, child: loadDefaultAppLogoPNG(sizeLogo: getMediaQueryHeight(context, size: .2)));
      },
    ),
  );
}

AppBar appBarWidget({
  required BuildContext context,
  String? title,
  bool? showAppLogo,
  bool? showBackButton,
  bool? showPopupMenuButton,
  Color? backgroundColor,
  TabController? tabController,
  List<Widget>? listTab,
  List<Widget>? actions,
  void Function(dynamic)? onPopupMenuSelected,
  PopupMenuItemBuilder<dynamic>? popupMenuItemBuilder,
}) {
  return AppBar(
    bottom: tabController != null ? TabBar.secondary( // atau bisa menggunakan TabBar.secondary untuk tampilan lebih kompak
      labelColor: ThemeColors.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      unselectedLabelColor: ThemeColors.surface(context),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyles.medium(context).copyWith(
        fontWeight: FontWeight.w600,
      ),
      dividerColor: Colors.transparent,
      tabs: listTab ?? [],
    ) : null,
    backgroundColor: backgroundColor ?? (AppearanceSettingProvider.read(context).trueBlack ? ThemeColors.onSurface(context) : null),
    toolbarHeight: 40,
    elevation: 0,
    scrolledUnderElevation: 0,
    leadingWidth: showBackButton != null && showBackButton ? null : 0,
    leading: showBackButton != null && showBackButton ? null : const SizedBox(),
    title: showAppLogo != null && showAppLogo ? Center(child: Padding(padding: const EdgeInsets.only(right: paddingNear), child: loadDefaultAppLogoPNG(sizeLogo: 40))) : title != null ? Center(
      child: cText(context, title, maxLines: 1, style: TextStyles.large(context).copyWith(fontWeight: FontWeight.w800, color: ThemeColors.surface(context))),
    ) : null,
    actions: actions ?? [
      if (showPopupMenuButton != null && showPopupMenuButton && popupMenuItemBuilder != null)
        PopupMenuButton(
          icon: Icon(Icons.more_vert, color: ThemeColors.surface(context)),
          onSelected: onPopupMenuSelected,
          itemBuilder: popupMenuItemBuilder,
        ),
      if (showBackButton != null && showBackButton && showPopupMenuButton == null && popupMenuItemBuilder == null) RowDivider(space: 48),
    ],
  );
}

AppBar appBarWebWidget({
  required BuildContext context,
  String? title,
  bool? showPopupMenuButton,
  TabController? tabController,
  List<Widget>? listTab,
  Widget? leading,
  List<Widget>? actions,
  void Function(dynamic)? onPopupMenuSelected,
  PopupMenuItemBuilder<dynamic>? popupMenuItemBuilder,
}) {
  return AppBar(
    bottom: tabController != null ? TabBar.secondary( // atau bisa menggunakan TabBar.secondary untuk tampilan lebih kompak
      labelColor: ThemeColors.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      unselectedLabelColor: ThemeColors.surface(context),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyles.medium(context).copyWith(
        fontWeight: FontWeight.w600,
      ),
      dividerColor: Colors.transparent,
      tabs: listTab ?? [],
    ) : null,
    backgroundColor: ThemeColors.onSurface(context),
    toolbarHeight: 60,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: leading,
    title: title != null ? cText(context, title, style: TextStyles.giant(context)) : null,
    actions: actions ?? [
      if (showPopupMenuButton != null && showPopupMenuButton && popupMenuItemBuilder != null)
        PopupMenuButton(
          icon: Icon(Icons.more_vert, color: ThemeColors.surface(context)),
          onSelected: onPopupMenuSelected,
          itemBuilder: popupMenuItemBuilder,
        ),
    ],
  );
}