import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/models/_global_widget_model/bottom_navbar.dart';
import '../../../core/state_management/providers/_global_widget/main_navbar_provider.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/system_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/dialog/dialog_button/dialog_two_button.dart';
import '../../layouts/styleconfig/themecolors.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';

List<BottomNavbarModel> listBottomNavbar = [
  BottomNavbarModel(page: DashboardScreen(), title: 'Beranda', iconData: Icons.dashboard),
  BottomNavbarModel(page: ProfileScreen(), title: 'Profil', iconData: Icons.person),
];

class MainNavbar extends StatelessWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await showDialog(context: context, builder: (context) => DialogTwoButton(header: 'Keluar Aplikasi?', description: 'Anda yakin ingin keluar dari aplikasi?',
          acceptedOnTap: () => quitApp()));
      },
      child: Consumer2<AppearanceSettingProvider, MainNavbarProvider>(
        builder: (context, provider, provider2, child) {
          if (provider.isTabletMode.condition){
            if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context, provider2);
            if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context, provider2);
          }
          return _setPhoneLayout(context, provider2);
        }
      ),
    );
  }

  Widget _setPhoneLayout(BuildContext context, MainNavbarProvider provider){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context, provider),
      bottomNavigation: BottomNavigationBar(
        items: listBottomNavbar.map((data) => _buildBottomNavigationBarItem(context, data)).toList(),
        backgroundColor: ThemeColors.greyVeryLowContrast(context),
        currentIndex: provider.selectedIndex,
        selectedItemColor: ThemeColors.surface(context),
        unselectedItemColor: ThemeColors.greyLowContrast(context),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: provider.changePageIndex,
      )
    );
  }

  Widget _setTabletLayout(BuildContext context, MainNavbarProvider provider){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context, provider),
      bottomNavigation: BottomNavigationBar(
        items: listBottomNavbar.map((data) => _buildBottomNavigationBarItem(context, data)).toList(),
        backgroundColor: ThemeColors.greyVeryLowContrast(context),
        currentIndex: provider.selectedIndex,
        selectedItemColor: ThemeColors.surface(context),
        unselectedItemColor: ThemeColors.grey(context),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: provider.changePageIndex,
      )
    );
  }

  Widget _bodyWidget(BuildContext context, MainNavbarProvider provider) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: provider.pageController,
            onPageChanged: (index) => provider.changePageIndex(index),
            children: listBottomNavbar.map((data) => data.page).toList()
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(BuildContext context, BottomNavbarModel data) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: iconBtnMid,
        child: Icon(
          data.iconData,
          size: MainNavbarProvider.read(context).iconSize
        ),
      ),
      label: data.title,
    );
  }
}