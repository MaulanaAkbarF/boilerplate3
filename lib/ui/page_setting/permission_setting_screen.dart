import 'dart:ui';

import 'package:boilerplate_3_firebaseconnect/core/services/firebase/firebase_messaging.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/page_routes_func.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/system_func.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/_setting_value/permission_values.dart';
import '../../core/constant_values/assets_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/global_values/global_data.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/state_management/providers/_settings/dev_mode_provider.dart';
import '../../core/state_management/providers/_settings/permission_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../layouts/global_return_widgets/media_widgets_func.dart';
import '../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../layouts/global_state_widgets/custom_page_animation/pa_zoom_out.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';

class PermissionSettingScreen extends StatelessWidget {
  const PermissionSettingScreen({super.key});

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
      appBar: appBarWidget(context: context, title: 'Perizinan', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Perizinan', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        appBar: appBarWebWidget(context: context, title: 'Perizinan'),
        body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            Expanded(child: cText(context, 'Daftar Perizinan Aplikasi', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300))),
            IconButton(icon: Icon(Icons.app_registration_sharp, size: iconBtnMid), color: ThemeColors.surface(context), onPressed: () async => await openAppSettings()),
            if (DevModeProvider.read(context).isActive) IconButton(icon: Icon(Icons.settings, size: iconBtnMid), color: ThemeColors.surface(context), onPressed: () async => startScreenSwipe(context, OtherPermissionSettingScreen())),
          ],
        ),
        _themeButton(context: context, label: 'Izin Lokasi', desc: 'Lokasi digunakan untuk mengambil posisi Anda saat ini', status: PermissionSettingProvider.watch(context).locationPermission.text,
            imagePath: imgLocation, onTap: () => PermissionSettingProvider.read(context).requestLocationPermission()),
        _themeButton(context: context, label: 'Izin Notifikasi', desc: 'Notifikasi digunakan untuk mengirimkan pesan pemberitahuan kepada pengguna', status: PermissionSettingProvider.watch(context).notificationPermission.text,
            imagePath: imgNotification, onTap: () => PermissionSettingProvider.read(context).getNotificationPermissionStatus()),
        ColumnDivider(),
      ],
    );
  }

  Widget _themeButton({required BuildContext context, required String label, required String desc, required String status, required String imagePath, required VoidCallback onTap}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingNear),
      child: GestureDetector(
        onTap: () => onTap(),
        child: SizedBox(
          height: kIsWeb ? AppearanceSettingProvider.read(context).fontSizeString.value * 16 : AppearanceSettingProvider.read(context).fontSizeString.value * 8,
          child: Stack(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(radiusSquare),
                child: Opacity(opacity: .7, child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: loadImageAssetPNG(path: imagePath, width: getMediaQueryWidth(context), height: kIsWeb
                      ? AppearanceSettingProvider.read(context).fontSizeString.value * 16
                      : AppearanceSettingProvider.read(context).fontSizeString.value * 8)))),
              Padding(
                padding: const EdgeInsets.all(paddingMid),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cText(context, label, maxLines: 1, style: TextStyles.semiGiant(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    cText(context, desc, maxLines: 2, style: TextStyles.medium(context).copyWith(color: Colors.white)),
                    cText(context, status, maxLines: 2, style: TextStyles.medium(context).copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: status == ListNotificationPermission.denied.text ? Colors.red : status == ListNotificationPermission.authorized.text ? Colors.green : Colors.white
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        ColumnDivider(),
        PageAnimationSwipeZoomOut(
          child: ListView(
            shrinkWrap: true,
            children: [
              _themeButton(context: context, label: 'Izin Lokasi', desc: 'Lokasi digunakan untuk mengambil posisi Anda saat ini', status: PermissionSettingProvider.watch(context).locationPermission.text,
                  imagePath: imgLocation, onTap: () => PermissionSettingProvider.read(context).requestLocationPermission()),
              _themeButton(context: context, label: 'Izin Notifikasi', desc: 'Notifikasi digunakan untuk mengirimkan pesan pemberitahuan kepada pengguna', status: PermissionSettingProvider.watch(context).notificationPermission.text,
                  imagePath: imgNotification, onTap: () => PermissionSettingProvider.read(context).getNotificationPermissionStatus()),
              ColumnDivider(),
            ],
          ),
        ),
      ],
    );
  }
}

class OtherPermissionSettingScreen extends StatelessWidget {
  const OtherPermissionSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
        builder: (context, provider, child) {
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
        appBar: appBarWidget(context: context, title: 'Lainnya', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        appBar: appBarWidget(context: context, title: 'Lainnya', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        cText(context, 'Notifikasi', style: TextStyles.giant(context)),
        ColumnDivider(),
        Container(
          padding: EdgeInsets.all(paddingMid),
          decoration: BoxDecoration(
            color: ThemeColors.greyVeryLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare)
          ),
          child: Row(
            children: [
              Expanded(child: cText(context, GlobalData.fcmToken ?? 'Tidak ada token', align: TextAlign.left)),
              RowDivider(),
              IconButton(icon: Icon(Icons.copy), iconSize: iconBtnMid, onPressed: () => copyText(context, GlobalData.fcmToken ?? 'Tidak ada token'))
            ],
          ),
        ),
        ColumnDivider(),
        _button(context: context, label: 'Trigger Notifikasi Standar', onTap: () => triggerLocalNotification()),
        ColumnDivider(),
        _button(context: context, label: 'Trigger Notifikasi Deskriptif', onTap: () => triggerLocalNotification()),
        ColumnDivider(),
        _button(context: context, label: 'Trigger Notifikasi Bergambar', onTap: () => triggerLocalNotification()),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, Icon? icon, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
        labelButton: label,
        labelButtonStyle: TextStyles.large(context).copyWith(color: ThemeColors.surface(context)),
        containerColor: ThemeColors.blueVeryLowContrast(context),
        height: heightMid,
        icon: icon,
        onHover: onHover,
        onTap: onTap
    );
  }
}