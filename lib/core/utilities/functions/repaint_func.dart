import 'dart:io';
import 'dart:ui' as ui;

import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/permission/hardware_permission.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/dialog/dialog_action/custom_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../../../ui/layouts/styleconfig/textstyle.dart';
import '../../../ui/layouts/styleconfig/themecolors.dart';
import '../../constant_values/_setting_value/log_app_values.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

class WidgetToImage {
  Future<bool> captureAndSaveWidget(BuildContext context, GlobalKey widgetKey) async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion >= 33) {
          await getGalleryPermission(accessVideoFromGallery: true).then((statuses){
            if (!statuses) {
              clog('Media permissions ditolak');
              return statuses;
            }
          });
        } else if (androidVersion >= 30) {
          await getStoragePermission(manageExternalStorage: true).then((statuses){
            if (!statuses) {
              clog('Storage permissions ditolak');
              return statuses;
            }
          });
        } else {
          await getStoragePermission().then((statuses){
            if (!statuses) {
              clog('Storage permissions ditolak');
              return statuses;
            }
          });
        }
      }

      await Future.delayed(const Duration(milliseconds: 500));
      final boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        clog('Error: ByteData null');
        return false;
      }

      String? filePath;
      if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final folderPath = '${externalDir.path.split('Android')[0]}/BOILERPLATE3/WidgetImage';
          clog('Directory path: $folderPath');
          await Directory(folderPath).create(recursive: true);
          filePath = '$folderPath/qrcode_${DateTime.now().millisecondsSinceEpoch}.png';
        }
      }

      if (filePath == null) {
        clog('Error: Tidak bisa mendapatkan path file');
        return false;
      }

      await File(filePath).writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), flush: true);
      await _showImagePreviewDialog(context, filePath);
      return true;
    } catch (e, s) {
      clog('Terjadi kesalahan saat captureAndSaveWidget: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  Future<void> _showImagePreviewDialog(BuildContext context, String imagePath) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogCustom(
          header: 'Code Anda',
          description: 'Code Anda berhasil dicetak!',
          headerTextStyle: TextStyles.large(context).copyWith(color: ThemeColors.blueHighContrast(context)),
          descriptionTextStyle: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context)),
          acceptedText: 'Kembali',
          acceptedOnTap: () => Navigator.pop(context),
          child: Image.file(File(imagePath), height: 300, fit: BoxFit.contain),
        );
      },
    );
  }
}