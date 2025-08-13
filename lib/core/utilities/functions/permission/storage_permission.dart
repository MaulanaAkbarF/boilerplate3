import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../logger_func.dart';

/// Mengecek status perizinan membaca file manager saat ini
///
/// Jangan lupa menambahkan permission di AndroidManifest:
/// - xmlns:tools="http://schemas.android.com/tools"
/// - uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" tools:ignore="ScopedStorage"
/// - <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
///
/// NOTE: Hati-hati! Izin ini cukup susah diimplementasikan bila aplikasi perlu diunggah ke Play Store
Future<bool> getExternalStoragePermission() async {
  try {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final androidVersion = androidInfo.version.sdkInt;
    clog('Android version: $androidVersion');

    if (androidVersion >= 30) {
      final status = await Permission.manageExternalStorage.status;
      switch (status){
        case PermissionStatus.granted: return true;
        case PermissionStatus.denied: await Permission.manageExternalStorage.request(); break;
        case PermissionStatus.restricted: await Permission.manageExternalStorage.request(); break;
        case PermissionStatus.limited: await Permission.manageExternalStorage.request(); break;
        case PermissionStatus.permanentlyDenied: await openAppSettings();
        case PermissionStatus.provisional: await Permission.manageExternalStorage.request(); break;
      }
      clog('MANAGE_EXTERNAL_STORAGE permission: $status');
      return false;
    } else {
      final status = await Permission.storage.status;
      switch (status){
        case PermissionStatus.granted: return true;
        case PermissionStatus.denied: await Permission.storage.request(); break;
        case PermissionStatus.restricted: await Permission.storage.request(); break;
        case PermissionStatus.limited: await Permission.storage.request(); break;
        case PermissionStatus.permanentlyDenied: await openAppSettings();
        case PermissionStatus.provisional: await Permission.storage.request(); break;
      }
      clog('STORAGE permission: $status');
      return false;
    }
  } catch (e, s) {
    clog('Terjadi masalah saat getExternalStoragePermission: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}