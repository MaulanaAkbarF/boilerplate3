import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../ui/layouts/global_state_widgets/divider/custom_divider.dart';
import '../../../ui/layouts/styleconfig/textstyle.dart';
import '../../../ui/layouts/styleconfig/themecolors.dart';
import '../../constant_values/_setting_value/log_app_values.dart';
import '../../global_values/_setting_data.dart';
import '../../global_values/global_data.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

/// Fungsi untuk menampilkan SnackBar (pemberitahuan di bawah layar)
void showSnackBar(BuildContext context, String text, {Icon? icon, int? duration}){
  SnackBar snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null)...[
          icon,
          RowDivider(),
        ],
        Expanded(child: cText(context, text, style: TextStyles.medium(context).copyWith(color: ThemeColors.onSurface(context), fontWeight: FontWeight.w500))),
      ],
    ),
    backgroundColor: ThemeColors.greyHighContrast(context),
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: duration ?? 2000),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Fungsi untuk menampilkan Toast (pemberitahuan di atas layar)
void showToastTop(BuildContext context, String text){
  showToast(
    text,
    backgroundColor: ThemeColors.surface(context),
    textStyle: TextStyles.small(context). copyWith(color: ThemeColors.onSurface(context)),
    context: context,
    animation: StyledToastAnimation.slideFromTopFade,
    reverseAnimation: StyledToastAnimation.slideToTopFade,
    position: const StyledToastPosition(align: Alignment.topCenter, offset: 0.0),
    startOffset: const Offset(0.0, -3.0),
    reverseEndOffset: const Offset(0.0, -3.0),
    duration: const Duration(seconds: 4),
    animDuration: const Duration(seconds: 1),
    curve: Curves.fastLinearToSlowEaseIn,
    reverseCurve: Curves.fastOutSlowIn
  );
}

/// Fungsi untuk menyalin teks/string
void copyText(BuildContext context, String value, {String? response, Icon? icon, int? duration}) {
  Clipboard.setData(ClipboardData(text: value)).then((value) => showSnackBar(context, response ?? 'Teks disalin', icon: icon, duration: duration));
}

/// Fungsi untuk mengecek konektivas internet pengguna
Future<bool> checkInternetConnectivity() async {
  try{
    return await InternetConnectionChecker.instance.hasConnection;
  } catch (e, s) {
    clog('Terjadi kesalahan saat checkInternetConnectivity: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}

/// Fungsi untuk mengirim/berbagi konten melalui aplikasi yang dipilih (seperti WhatsApp, Telegram dll)
/// Fungsi ini mendukung pengirimkan Foto, Video, Dokumen, Suara, URL dan Teks
Future<bool> shareContent(BuildContext context, String content, {String? subject, List<XFile>? imageFiles}) async {
  try {
    final box = context.findRenderObject();
    Rect? sharePositionOrigin;

    if (box == null) return false;
    if (box is RenderBox) {
      sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
    } else if (box is RenderSliverList) {
      /// Kamu mungkin perlu logika khusus untuk mendapatkan posisi dari Sliver
      /// Ini adalah pendekatan sederhana sebagai alternatif
      sharePositionOrigin = Rect.fromLTWH(0, 0, 100, 100);
    }

    if (imageFiles != null && imageFiles.isNotEmpty) {
      await SharePlus.instance.share(ShareParams(files: imageFiles, text: content, subject: subject, sharePositionOrigin: sharePositionOrigin));
    } else if (content.contains('http')) {
      await SharePlus.instance.share(ShareParams(uri: Uri.parse(content), text: content, subject: subject, sharePositionOrigin: sharePositionOrigin));
    } else {
      await SharePlus.instance.share(ShareParams(title: content, text: content, subject: subject, sharePositionOrigin: sharePositionOrigin));
    }
    return true;
  } catch (e, s) {
    clog('Terjadi kesalahan saat shareContent: $e\n$s');
    await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    return false;
  }
}

/// Fungsi untuk mengambil data informasi umum perangkat pengguna
Future<void> getUserDeviceInfo() async {
  try{
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      UserDeviceInfo.brand = androidInfo.brand;
      UserDeviceInfo.model = androidInfo.model;
      UserDeviceInfo.device = androidInfo.device;
      UserDeviceInfo.manufacturer = androidInfo.manufacturer;
      UserDeviceInfo.board = androidInfo.board;
      UserDeviceInfo.hardware = androidInfo.hardware;
      UserDeviceInfo.versionRelease = androidInfo.version.release;
      UserDeviceInfo.versionSdkInt = androidInfo.version.sdkInt;
      UserDeviceInfo.versionCodeName = androidInfo.version.codename;
      UserDeviceInfo.isPhysicalDevice = androidInfo.isPhysicalDevice;
      clog('Sukses mendapatkan info perangkat Android');
    }
  } catch (e, s){
    clog('Terjadi kesalahan saat getUserDeviceInfo: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
  }
}

/// Fungsi untuk menentukan akses orientasi aplikasi
/// Jika pengguna mengaktifkan orientasi vertikal, maka aplikasi tidak dapat diputar
/// Jika pengguna menonaktifkan orientasi vertikal, maka aplikasi dapat diputar
Future<void> getPlatformOrientiation() async {
  if (AppearancesSettingData.preferredOrientation) {
    clog('Orientasi penuh aplikasi');
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  } else {
    clog('Orientasi vertikal aplikasi');
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}

/// Fungsi untuk keluar dari aplikasi
void quitApp() {
  SystemNavigator.pop();
}