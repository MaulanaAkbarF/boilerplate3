import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../../ui/layouts/global_state_widgets/custom_scaffold/custom_drawer.dart';
import '../../../ui/layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../../ui/page_auth/login_screen.dart';
import '../../../ui/page_main/_bottom_navbar/main_navbar.dart';
import '../../../ui/page_main/dashboard/dashboard_screen.dart';
import '../../../ui/page_main/profile/profile_screen.dart';
import '../../../ui/page_setting/_main_setting_screen.dart';
import '../../../ui/page_setting/appearance_setting_screen.dart';
import '../../../ui/page_setting/developer_setting_screen.dart';
import '../../../ui/page_setting/permission_setting_screen.dart';
import '../../../ui/page_setting/preference_setting_screen.dart';
import '../../constant_values/global_values.dart';
import '../../state_management/providers/_settings/appearance_provider.dart';
import '../../state_management/providers/_settings/dev_mode_provider.dart';
import '../functions/media_query_func.dart';

final GlobalKey<NavigatorState> _dashboardNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouters = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', redirect: (context, state) async {
      await AppearanceSettingProvider.read(context).initData(context);
      return '/login';
    }),

    /// Route yang berdiri sendiri (Standalone Route)
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    /// Tampilan Sidebar sebagai route utama (Shell Route)
    /// Ketika dari halaman lain dan ingin pergi dan menampilkan sidebar, bisa diarahkan ke route cabang (Shell Branch) [NOTE: Pada kode dibawah ini, Shell Branch adalah "mainSidebarbranch"]
    /// Contoh: Setelah dari route ('/login') dan ingin menampilkan Sidebar dan halaman dashboard, bisa diarahkan ke: context.go('/dashboard'))
    /// Direkomendasikan untuk diarahkan ke index pertama dari List Shell Branch
    StatefulShellRoute.indexedStack(
      branches: mainSidebarbranch,
      builder: (context, state, navigationShell) {
        final SidebarXController controller = SidebarXController(selectedIndex: navigationShell.currentIndex, extended: true);
        List<SidebarXItem> items = listBottomNavbar.asMap().entries.map((entry) => SidebarXItem(icon: entry.value.iconData, label: entry.value.title, onTap: () => navigationShell.goBranch(entry.key))).toList();
        return CustomScaffold(
          useSafeArea: true,
          padding: EdgeInsets.zero,
          body: Row(
            children: [
              if (getMediaQueryWidth(context) * .5 > mainSidebarWidth) CustomSidebarXMain(controller: controller, items: items),
              Expanded(child: navigationShell),
            ],
          ),
        );
      },
    ),
  ],
);

/// Tampilan halaman dari Route Cabang
final List<StatefulShellBranch> mainSidebarbranch = [
  StatefulShellBranch(
    navigatorKey: _dashboardNavigatorKey,
    routes: [
      GoRoute(path: '/dashboard',
        // onExit: (context, state) async => await showDialog(context: context, builder: (context) => DialogTwoButton(header: 'Keluar Aplikasi?', description: 'Anda yakin ingin keluar dari aplikasi?',
        //   acceptedOnTap: () => quitApp())),
        builder: (context, state) => const DashboardScreen()),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _profileNavigatorKey,
    routes: [
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
  ),
  StatefulShellBranch(
    navigatorKey: _settingsNavigatorKey,
    routes: [
      GoRoute(path: '/setting_main', builder: (context, state) {
        AppearanceSettingProvider.read(context).initData(context);
        return MainSettingScreen();
      }),
      GoRoute(path: '/setting_appearance', builder: (context, state) => const AppearanceSettingScreen()),
      GoRoute(path: '/setting_preferences', builder: (context, state) => const PreferenceSettingScreen()),
      GoRoute(path: '/setting_permissions', builder: (context, state) => const PermissionSettingScreen()),
      GoRoute(path: '/setting_developer', builder: (context, state) {
        DevModeProvider.read(context).initData();
        return const DevSettingScreen();
      }),
    ],
  ),
];