import 'package:boilerplate_3_firebaseconnect/core/constant_values/_constant_text_values.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/dialog/dialog_button/dialog_one_button.dart';
import 'package:boilerplate_3_firebaseconnect/ui/page_setting/permission_setting_screen.dart';
import 'package:boilerplate_3_firebaseconnect/ui/page_setting/preference_setting_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../core/constant_values/global_values.dart';
import '../../core/global_values/global_data.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/state_management/providers/_settings/dev_mode_provider.dart';
import '../../core/state_management/providers/_settings/log_app_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../../core/utilities/functions/page_routes_func.dart';
import '../../core/utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../layouts/global_return_widgets/helper_widgets_func.dart';
import '../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../layouts/global_state_widgets/custom_background/container_background.dart';
import '../layouts/global_state_widgets/custom_page_animation/pa_zoom_out.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';
import 'appearance_setting_screen.dart';
import 'developer_setting_screen.dart';
import 'log_app_setting_screen.dart';

class MainSettingScreen extends StatelessWidget {
  final SidebarXController controller = SidebarXController(selectedIndex: 0);

  MainSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (kIsWeb) {
          if (getMediaQueryWidth(context) < minWebLayoutWidth) return _setPhoneLayout(context);
          return _setWebLayout(context);
        }
        if (provider.isTabletMode.condition){
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Pengaturan', showBackButton: true, showPopupMenuButton: true,
        onPopupMenuSelected: (value) async {
          switch (value) {
            case '0': DevModeProvider.read(context).toggle(); break;
            case '1': showDialog(context: context, builder: (context) =>
              DialogOneButton(
                header: 'Informasi Perangkat', description:
                  'Merek: ${UserDeviceInfo.brand}\n'
                  'Model: ${UserDeviceInfo.model}\n'
                  'Manufaktur: ${UserDeviceInfo.manufacturer}\n'
                  'Android: ${UserDeviceInfo.versionRelease} ${UserDeviceInfo.versionCodeName}\n'
                  'API: ${UserDeviceInfo.versionSdkInt.toString()}\n'
                  'Perangkat Fisik: ${UserDeviceInfo.getPysicalDevice()}\n'
                  'Versi Aplikasi: $appVersionText\n',
                )); break;
          }
        },
        popupMenuItemBuilder: (context){
          return [
            popupMenuItem(context, '0', DevModeProvider.read(context).isActive ? 'Non-Aktifkan Dev Mode' : 'Aktifkan Dev Mode',
              DevModeProvider.read(context).isActive ? Icons.toggle_on : Icons.toggle_off, ThemeColors.surface(context)),
            popupMenuItem(context, '1', 'Info Perangkat', Icons.devices_sharp, ThemeColors.blue(context)),
          ];
        }),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Pengaturan', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWebWidget(context: context, title: 'Pengaturan',
        actions: [
          cText(context, 'Dev Mode', style: TextStyles.medium(context)),
          RowDivider(),
          Switch(value: DevModeProvider.watch(context).isActive, onChanged: (value) => DevModeProvider.read(context).toggle(), inactiveTrackColor: ThemeColors.onSurface(context))
        ]),
      body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        _button(context: context, label: 'Pengaturan Akun', icon: Icon(Icons.person, size: iconBtnSmall, color: ThemeColors.green(context)),
          onTap: () async => await Future.delayed(Duration(seconds: 3))),
        _button(context: context, label: 'Tampilan', icon: Icon(Icons.palette, size: iconBtnSmall, color: ThemeColors.yellow(context)),
            onTap: () => kIsWeb ? context.go('/setting_appearance') : startScreenSwipe(context, AppearanceSettingScreen())),
        _button(context: context, label: 'Preferensi', icon: Icon(Icons.tune, size: iconBtnSmall, color: ThemeColors.red(context)),
            onTap: () => kIsWeb ? context.go('/setting_preferences') : startScreenSwipe(context, PreferenceSettingScreen())),
        _button(context: context, label: 'Perizinan', icon: Icon(Icons.security, size: iconBtnSmall, color: ThemeColors.blue(context)),
            onTap: () => kIsWeb ? context.go('/setting_permissions') : startScreenSwipe(context, PermissionSettingScreen())),
        Consumer<DevModeProvider>(
          builder: (context, provider, child) {
            return provider.isActive ? Column(
              children: [
                _button(context: context, label: 'Log Aplikasi', icon: Icon(Icons.history, size: iconBtnSmall, color: ThemeColors.grey(context)),
                  onTap: () async => await LogAppServices.getDatabaseSize().then((value) {
                    LogAppSettingProvider.read(context).initialize();
                    startScreenSwipe(context, LogAppSettingScreen(dbSize: value.$1));
                  })
                ),
                _button(context: context, label: 'Pengaturan Developer', icon: Icon(Icons.code, size: iconBtnSmall, color: ThemeColors.blueLowContrast(context)),
                    onTap: () {
                      DevModeProvider.read(context).initData();
                      kIsWeb ? context.go('/setting_developer') : startScreenSwipe(context, DevSettingScreen());
                    }
                ),
              ],
            ) : const SizedBox();
          },
        ),
        _button(context: context, label: 'Konfigurasi Aplikasi', icon: Icon(Icons.settings, size: iconBtnSmall, color: ThemeColors.grey(context)),
            onTap: () async => await openAppSettings()),
      ],
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    String title = 'Pengaturan';
    String description = 'Sesuaikan aplikasi sesuai dengan preferensi Anda!';

    return ListView(
      shrinkWrap: true,
      children: [
        ColumnDivider(),
        StatefulBuilder(
          builder: (context, setState) {
            void setEmpty() => setState((){title = 'Pengaturan'; description = 'Sesuaikan aplikasi sesuai dengan preferensi Anda!';});
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  isExpanded: true,
                  containerColor: ThemeColors.greyVeryLowContrast(context),
                  child: PageAnimationSwipeZoomOut(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _button(context: context, label: 'Pengaturan Akun', icon: Icon(Icons.person, size: iconBtnSmall, color: ThemeColors.green(context)),
                            onHover: (value) => value ? setState((){title = 'Pengaturan Akun'; description = 'Edit dan sesuaikan informasi Akun Anda';}) : setEmpty(),
                            onTap: () async => await Future.delayed(Duration(seconds: 3))),
                        _button(context: context, label: 'Tampilan', icon: Icon(Icons.palette, size: iconBtnSmall, color: ThemeColors.yellow(context)),
                            onHover: (value) => value ? setState((){title = 'Tampilan'; description = 'Edit dan sesuaikan tampilan aplikasi Anda!\nAtur Font, Ukuran Font, Tema, dan ukuran sisi';}) : setEmpty(),
                            onTap: () => kIsWeb ? context.go('/setting_appearance') : startScreenSwipe(context, AppearanceSettingScreen())),
                        _button(context: context, label: 'Preferensi', icon: Icon(Icons.tune, size: iconBtnSmall, color: ThemeColors.red(context)),
                            onHover: (value) => value ? setState((){title = 'Preferensi'; description = 'Atur preferensi aplikasi seperti Bahasa, Waktu, Tanggal dan Animasi';}) : setEmpty(),
                            onTap: () => kIsWeb ? context.go('/setting_preferences') : startScreenSwipe(context, PreferenceSettingScreen())),
                        _button(context: context, label: 'Perizinan', icon: Icon(Icons.security, size: iconBtnSmall, color: ThemeColors.blue(context)),
                            onHover: (value) => value ? setState((){title = 'Perizinan'; description = 'Lihat, beri akses dan sesuaikan segala perizinan aplikasi';}) : setEmpty(),
                            onTap: () => kIsWeb ? context.go('/setting_permissions') : startScreenSwipe(context, PermissionSettingScreen())),
                        Consumer<DevModeProvider>(
                          builder: (context, provider, child) {
                            return provider.isActive ? Column(
                              children: [
                                _button(context: context, label: 'Pengaturan Developer', icon: Icon(Icons.code, size: iconBtnSmall, color: ThemeColors.blueLowContrast(context)),
                                  onHover: (value) => value ? setState((){title = 'Pengaturan Developer'; description = 'Edit dan sesuaikan opsi developer untuk debugging aplikasi, seperti Endpoint utama dan sub-endpoint';}) : setEmpty(),
                                  onTap: (){
                                    DevModeProvider.read(context).initData();
                                    kIsWeb ? context.go('/setting_developer') : startScreenSwipe(context, DevSettingScreen());
                                  }
                                ),
                              ],
                            ) : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                RowDivider(),
                CustomContainer(
                  isExpanded: true,
                  padding: EdgeInsets.all(paddingVeryFar),
                  containerColor: ThemeColors.greyVeryLowContrast(context),
                  child: Column(
                    children: [
                      cText(context, title, align: TextAlign.center, style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold)),
                      ColumnDivider(),
                      cText(context, description, align: TextAlign.center, style: TextStyles.large(context)),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, required Icon icon, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
      labelButton: label,
      labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context)),
      containerColor: Colors.transparent,
      icon: icon,
      useArrow: true,
      onHover: onHover,
      onTap: onTap
    );
  }
}
