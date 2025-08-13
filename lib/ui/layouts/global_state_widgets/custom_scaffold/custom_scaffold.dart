import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/widget/background_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../styleconfig/themecolors.dart';

class CustomScaffold extends StatelessWidget {
  final AppBar? appBar;
  final SliverAppBar? sliverAppBar;
  final Widget? drawer;
  final Widget body;
  final Widget? bottomNavigation;
  final bool? canPop;
  final Color? backgroundColor;
  final bool? useSafeArea;
  final bool? useExtension;
  final bool showBackgroundLogo;
  final EdgeInsets? padding;
  final PopInvokedWithResultCallback<dynamic>? onPopInvokedWithResult;

  const CustomScaffold({
    super.key,
    this.appBar,
    this.sliverAppBar,
    this.drawer,
    required this.body,
    this.bottomNavigation,
    this.canPop,
    this.backgroundColor,
    this.useSafeArea,
    this.useExtension,
    this.showBackgroundLogo = false,
    this.padding,
    this.onPopInvokedWithResult,
  });

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = body;
    if ((useExtension ?? false) && showBackgroundLogo) {
      bodyWidget = bodyWidget.gradientBackground(context: context).dismissKeyboardOnTap(context);
    } else if (useExtension ?? false) {
      bodyWidget = bodyWidget.dismissKeyboardOnTap(context);
    }

    if (appBar != null) {
      return PopScope(
        canPop: canPop ?? true,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Consumer<AppearanceSettingProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: appBar,
              drawer: drawer,
              backgroundColor: backgroundColor ?? (AppearanceSettingProvider.read(context).trueBlack == true ? ThemeColors.onSurface(context) : null),
              body: _buildBody(provider, bodyWidget),
              bottomNavigationBar: bottomNavigation,
            );
          },
        ),
      );
    } else if (sliverAppBar != null) {
      return PopScope(
        canPop: canPop ?? true,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Consumer<AppearanceSettingProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              drawer: drawer,
              backgroundColor: backgroundColor ?? (AppearanceSettingProvider.read(context).trueBlack == true ? ThemeColors.onSurface(context) : null),
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [sliverAppBar!];
                },
                body: _buildBody(provider, bodyWidget),
              ),
              bottomNavigationBar: bottomNavigation,
            );
          },
        ),
      );
    } else {
      return PopScope(
        canPop: canPop ?? true,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Consumer<AppearanceSettingProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              drawer: drawer,
              backgroundColor: backgroundColor ?? (AppearanceSettingProvider.read(context).trueBlack == true ? ThemeColors.onSurface(context) : null),
              body: _buildBody(provider, bodyWidget),
              bottomNavigationBar: bottomNavigation,
            );
          },
        ),
      );
    }
  }

  Widget _buildBody(AppearanceSettingProvider provider, Widget bodyWidget) {
    if (useSafeArea != null && useSafeArea!) {
      return provider.isSafeArea.condition
        ? SafeArea(child: Padding(padding: padding ?? const EdgeInsets.symmetric(horizontal: paddingMid), child: bodyWidget))
        : Padding(padding: padding ?? const EdgeInsets.symmetric(horizontal: paddingMid), child: bodyWidget);
    }
    return Padding(padding: padding ?? const EdgeInsets.symmetric(horizontal: paddingMid), child: bodyWidget);
  }
}