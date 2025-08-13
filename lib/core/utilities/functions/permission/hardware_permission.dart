import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../services/firebase/firebase_messaging.dart';
import '../../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../logger_func.dart';

Future<bool> getBluetoothServiceStatus({bool? canOpenAppSetting}) async {
  bool serviceEnabled = await Permission.bluetooth.serviceStatus.isEnabled;
  if (serviceEnabled) return true;
  else {
    if (canOpenAppSetting != null && canOpenAppSetting) openAppSettings();
    return false;
  }
}

Future<bool> getLocationServiceStatus() async {
  bool serviceEnabled = await Permission.location.serviceStatus.isEnabled;
  if (serviceEnabled) return true;
  else {
    openAppSettings();
    return false;
  }
}

Future<bool> getLocationPermission({bool? requestForWifiControl, bool? useLocationOnlyWhenUseApp, bool? useLocationEvenAppInBackground}) async {
  bool isServiceEnable = await getLocationServiceStatus();
  if (isServiceEnable){
    Map<Permission, PermissionStatus> statuses;
    /// Ini dipakai ketika akses lokasi hanya digunakan saat pengguna membuka/menggunakan aplikasi
    /// Lokasi tidak akan berjalan di latar belakang atau saat aplikasi ditutup
    /// Privasi izin ini paling aman
    if (requestForWifiControl != null && requestForWifiControl) {
      statuses = await [Permission.location, Permission.locationWhenInUse, if (defaultTargetPlatform == TargetPlatform.android) Permission.nearbyWifiDevices].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.location] == PermissionStatus.granted
          && statuses[Permission.locationWhenInUse] == PermissionStatus.granted
          && defaultTargetPlatform == TargetPlatform.android ? statuses[Permission.nearbyWifiDevices] == PermissionStatus.granted : true;
      /// Ini dipakai ketika akses lokasi digunakan saat pengguna membuka/menggunakan aplikasi atau saat aplikasi ditutup
      /// Lokasi akan tetap berjalan di latar belakang bahkan saat aplikasi ditutup
      /// Privasi izin ini paling tidak aman dan tidak direkomendasikan, kecuali ada kasus dimana lokasi realtime diperlukan
      /// Izin ini akan dimintakan penjelasan pada Google Play Console
    } else if (useLocationOnlyWhenUseApp != null && useLocationOnlyWhenUseApp) {
      statuses = await [Permission.locationWhenInUse].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.locationWhenInUse] == PermissionStatus.granted;
      /// Ini dipakai ketika akses lokasi digunakan saat pengguna membuka/menggunakan aplikasi atau saat aplikasi ditutup
      /// Lokasi akan tetap berjalan di latar belakang bahkan saat aplikasi ditutup
      /// Privasi izin ini paling tidak aman dan tidak direkomendasikan, kecuali ada kasus dimana lokasi realtime diperlukan
      /// Izin ini akan dimintakan penjelasan pada Google Play Console
    } else if (useLocationEvenAppInBackground != null && useLocationEvenAppInBackground) {
      statuses = await [Permission.locationAlways].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.locationAlways] == PermissionStatus.granted;
      /// Izin default untuk mengakses lokasi saat aplikasi memerlukan penggunaan lokasi
    } else {
      statuses = await [Permission.location].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.location] == PermissionStatus.granted;
    }
  } else {
    return false;
  }
}

/// Mengecek status perizinan kamera saat ini
/// Jangan lupa menambahkan permission di AndroidManifest (sesuaikan kebutuhan):
/// - <uses-permission android:name="android.permission.RECORD_AUDIO"
/// - <uses-permission android:name="android.permission.CAMERA"
/// - <uses-feature android:name="android.hardware.camera"
Future<bool> getCameraPermission({bool? requestVideo}) async {
  Map<Permission, PermissionStatus> statuses;
  /// Ini dipakai kalau memerlukan izin kamera yang bisa ambil video
  if (requestVideo != null && requestVideo) {
    statuses = await [Permission.camera, Permission.audio, Permission.microphone].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.camera] == PermissionStatus.granted
        && statuses[Permission.audio] == PermissionStatus.granted
        && statuses[Permission.microphone] == PermissionStatus.granted;
  /// Ini adalah izin dasar
  /// Hanya bisa mengambil foto saja
  } else {
    statuses = await [Permission.camera].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.camera] == PermissionStatus.granted;
  }
}

/// Mengecek status perizinan galeri saat ini
/// Jangan lupa menambahkan permission di AndroidManifest (sesuaikan kebutuhan):
/// - <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"
/// - <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"
Future<bool> getGalleryPermission({bool? accessVideoFromGallery}) async {
  Map<Permission, PermissionStatus> statuses;
  /// Ini dipakai kalau memerlukan izin galeri yang bisa mengakses video di dalam galeri
  if (accessVideoFromGallery != null && accessVideoFromGallery) {
    statuses = await [Permission.photos, Permission.videos].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.photos] == PermissionStatus.granted
        && statuses[Permission.videos] == PermissionStatus.granted;
    /// Ini adalah izin dasar
    /// Hanya bisa mengambil galeri foto saja
  } else {
    statuses = await [Permission.photos].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.photos] == PermissionStatus.granted;
  }
}

/// Mengecek status perizinan penyimpanan/storage saat ini
/// Jangan lupa menambahkan permission di AndroidManifest:
/// Untuk Android API 30 kebawah:
/// - <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
/// - <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
/// Untuk Android API 30 keatas, biasanya perlu menambahkan permission berikut (sesuaikan kebutuhan):
/// - <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"
/// - <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"
/// - <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"
Future<bool> getStoragePermission({bool? manageExternalStorage}) async {
  Map<Permission, PermissionStatus> statuses;
  if (manageExternalStorage != null && manageExternalStorage) {
    statuses = await [Permission.storage, Permission.manageExternalStorage].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.storage] == PermissionStatus.granted
        && statuses[Permission.manageExternalStorage] == PermissionStatus.granted;
    /// Ini adalah izin dasar
    /// Hanya bisa mengambil galeri foto saja
  } else {
    statuses = await [Permission.storage].request();
    statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
    return statuses[Permission.storage] == PermissionStatus.granted;
  }
}

Future<bool> getAudioPermission() async {
  Map<Permission, PermissionStatus> statuses = await [Permission.audio, Permission.microphone].request();
  statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
  return statuses[Permission.audio] == PermissionStatus.granted && statuses[Permission.microphone] == PermissionStatus.granted;
}

Future<bool> getNotificationPermission() async {
  Map<Permission, PermissionStatus> statuses = await [Permission.notification].request();
  statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
  return statuses[Permission.notification] == PermissionStatus.granted;
}

Future<bool?> getFlutterLocalNotificationPermission() async {
  try {
    /// Meminta izin notifikasi untuk platform Android
    if (Platform.isAndroid) {
      var androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) return await androidImplementation.requestNotificationsPermission().then((value) => value);
    /// Meminta izin notifikasi untuk platform iOS
    } else if (Platform.isIOS) {
      var iosImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) return await iosImplementation.requestPermissions(alert: true, badge: true, sound: true).then((value) => value);
    }
    return false;
  } catch (e, s) {
    clog('Terjadi kesalahan saat request Izin Flutter Local Notification : $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}

Future<bool> getBluetoothPermission({bool? requestBluetoothScan}) async {
  bool isServiceEnable = await getBluetoothServiceStatus();
  if (isServiceEnable){
    Map<Permission, PermissionStatus> statuses;
    /// Ini dipakai ketika aplikasi memerlukan scanning bluetooth untuk mencari perangkat bluetooth
    if (requestBluetoothScan != null && requestBluetoothScan) {
      statuses = await [Permission.bluetooth, Permission.bluetoothConnect, Permission.bluetoothScan].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.bluetooth] == PermissionStatus.granted
          && statuses[Permission.bluetoothConnect] == PermissionStatus.granted
          && statuses[Permission.bluetoothScan] == PermissionStatus.granted;
      /// Izin default untuk menggunakan fitur bluetooth
    } else {
      statuses = await [Permission.bluetooth, Permission.bluetoothConnect].request();
      statuses.forEach((permission, status) => clog('Permission: $permission, Status: $status'));
      return statuses[Permission.bluetooth] == PermissionStatus.granted && statuses[Permission.bluetoothConnect] == PermissionStatus.granted;
    }
  } else {
    return false;
  }
}