import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/constant_values/_setting_value/permission_values.dart';
import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/services/firebase/firebase_messaging.dart';
import '../../../global_return_widgets/media_widgets_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../button/button_progress/animation_progress.dart';
import '../../divider/custom_divider.dart';

Future<T?> showCustomPermissionDialog<T>({required BuildContext context, required GetPermissionType getPermissionType}) async {
  return await showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      switch (getPermissionType){
        case GetPermissionType.locationDisabled: return PermissionDialog(
            header: 'GPS Non-Aktif',
            description: 'GPS Anda Non-Aktif. Perangkat Anda tidak dapat mengambil lokasi Anda saat ini. Mohon aktifkan GPS Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Buka Pengaturan',
            acceptedOnTap: () async => await AppSettings.openAppSettings(type: AppSettingsType.location).then((value) => Navigator.pop(context))
        );
        case GetPermissionType.locationDenied: return PermissionDialog(
            header: 'Izin Lokasi Tidak Diberikan',
            description: 'Kami tidak bisa mengambil lokasi Anda saat ini. Mohon klik tombol "Minta Izin" dan pilih "Selalu" atau "Saat Aplikasi Digunakan" agar kami dapat mengakses lokasi Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Minta Izin',
            acceptedOnTap: () async => await Geolocator.requestPermission().then((value) => Navigator.pop(context))
        );
        case GetPermissionType.locationDeniedForever: return PermissionDialog(
            header: 'Izin Lokasi Ditolak Permanen',
            description: 'Kami tidak bisa mengambil lokasi Anda saat ini. Mohon ubah perizinan Lokasi dan pilih "Selalu" atau "Saat Aplikasi Digunakan" agar kami dapat mengakses lokasi Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Buka Pengaturan',
            acceptedOnTap: () async => await openAppSettings().then((value) => Navigator.pop(context))
        );
        case GetPermissionType.locationUnableToDetermine: return PermissionDialog(
            header: 'Gagal Mengidentifikasi Izin Lokasi',
            description: 'Izin Lokasi tidak bisa diidentifikasi! Kami tidak bisa mengambil lokasi Anda saat ini. Mohon ubah perizinan Lokasi dan pilih "Selalu" atau "Saat Aplikasi Digunakan" agar kami dapat mengakses lokasi Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Buka Pengaturan',
            acceptedOnTap: () async => await openAppSettings().then((value) => Navigator.pop(context))
        );
        case GetPermissionType.notificationDenied: return PermissionDialog(
            header: 'Izin Notifikasi Tidak Diberikan',
            description: 'Kami tidak bisa mengirimkan notifikasi ke perangkat Anda. Mohon ubah perizinan Notifikasi dan pilih "Izinkan" agar kami dapat memberikan pemberitahuan melalui notifikasi kepada Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Buka Pengaturan',
            acceptedOnTap: () async => await AppSettings.openAppSettings(type: AppSettingsType.notification).then((value) => Navigator.pop(context))
        );
        case GetPermissionType.notificationFirebaseDenied: return PermissionDialog(
            header: 'Izin Notifikasi Tidak Diberikan',
            description: 'Kami tidak bisa mengirimkan notifikasi ke perangkat Anda. Mohon ubah perizinan Notifikasi dan pilih "Izinkan" agar kami dapat memberikan pemberitahuan melalui notifikasi kepada Anda',
            declinedText: 'Tolak',
            declinedOnTap: () => Navigator.pop(context),
            acceptedText: 'Buka Pengaturan',
            acceptedOnTap: () async => await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: false, criticalAlert: true, announcement: true).then((value) {
              fcmNotificationSetting = value;
              Navigator.pop(context);
            }));
        default: Navigator.pop(context); return const SizedBox();
      }
    },
  );
}

class PermissionDialog extends StatelessWidget {
  final String? lottiePath;
  final String? imagePathPNG;
  final IconData? iconData;
  final double? sizeContentImages;
  final Color? colorContentImages;
  final String? header;
  final String? description;
  final String? declinedText;
  final String? acceptedText;
  final TextStyle? headerTextStyle;
  final TextStyle? descriptionTextStyle;
  final Function() declinedOnTap;
  final Function() acceptedOnTap;

  const PermissionDialog({
    super.key,
    this.lottiePath,
    this.imagePathPNG,
    this.iconData,
    this.sizeContentImages,
    this.colorContentImages,
    this.header,
    this.description,
    this.declinedText,
    this.acceptedText,
    this.headerTextStyle,
    this.descriptionTextStyle,
    required this.declinedOnTap,
    required this.acceptedOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.greyLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.grey(context).withValues(alpha: shadowOpacityMid),
                spreadRadius: shadowSpreadLow,
                blurRadius: shadowBlueHigh,
                offset: const Offset(0, shadowoffsetMid),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingMid),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lottiePath != null ? loadLottieAsset(path: lottiePath!, width: sizeContentImages, height: sizeContentImages)
                    : imagePathPNG != null ? loadImageAssetPNG(path: imagePathPNG!, width: sizeContentImages, height: sizeContentImages, color: colorContentImages)
                    : iconData != null ? Icon(iconData, size: sizeContentImages, color: colorContentImages) : SizedBox(),
                  cText(context, header ?? 'Peringatan', maxLines: 3, align: TextAlign.center, style: headerTextStyle ?? TextStyles.large(context).copyWith(color: ThemeColors.redHighContrast(context), fontWeight: FontWeight.w900)),
                  ColumnDivider(),
                  cText(context, description ?? 'Harap klik tombol berwarna biru', align: TextAlign.center, style: descriptionTextStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
                  ColumnDivider(),
                  Row(
                    children: [
                      Expanded(
                        child: AnimateProgressButton(
                          labelButton: declinedText,
                          labelButtonStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.w900, color: ThemeColors.surface(context)),
                          labelProgress: 'Mengembalikan',
                          height: heightMid,
                          containerColor: ThemeColors.red(context),
                          containerRadius: radiusSquare,
                          onTap: () async => declinedOnTap(),
                        ),
                      ),
                      const RowDivider(space: 10),
                      Expanded(
                        child: AnimateProgressButton(
                          labelButton: acceptedText,
                          labelButtonStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.w900, color: ThemeColors.surface(context)),
                          labelProgress: 'Memproses',
                          height: heightMid,
                          containerColor: ThemeColors.blue(context),
                          containerRadius: radiusSquare,
                          onTap: () async => acceptedOnTap(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}