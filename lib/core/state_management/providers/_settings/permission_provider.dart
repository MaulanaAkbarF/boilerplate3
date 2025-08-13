import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../ui/layouts/global_state_widgets/dialog/dialog_button/permission_dialog.dart';
import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../constant_values/_setting_value/permission_values.dart';
import '../../../services/firebase/firebase_messaging.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/functions/permission/hardware_permission.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class PermissionSettingProvider extends ChangeNotifier{
  ListLocationPermission _locationPermission = ListLocationPermission.denied;
  ListNotificationPermission _notificationPermission = ListNotificationPermission.denied;

  ListLocationPermission get locationPermission => _locationPermission;
  ListNotificationPermission get notificationPermission => _notificationPermission;

  /// Mengecek status perizinan lokasi saat ini
  /// Jangan lupa menambahkan permission di AndroidManifest:
  /// - uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
  /// - uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"
  Future<ListLocationPermission> getLocationPermissionStatus() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      clog('Status Permission Lokasi: $permission');
      switch (permission){
        case LocationPermission.whileInUse: _locationPermission = ListLocationPermission.whileInUse; break;
        case LocationPermission.denied: _locationPermission = ListLocationPermission.denied; break;
        case LocationPermission.deniedForever: _locationPermission = ListLocationPermission.deniedForever; break;
        case LocationPermission.always: _locationPermission = ListLocationPermission.always; break;
        case LocationPermission.unableToDetermine: _locationPermission = ListLocationPermission.unableToDetermine; break;
      }

      notifyListeners();
      return locationPermission;
    } catch (e, s) {
      clog('Terjadi masalah saat getLocationPermissionStatus: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return ListLocationPermission.denied;
    }
  }

  /// Fungsi untuk meminta izin penggunaan lokasi
  Future<bool> requestLocationPermission({BuildContext? context}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.locationDisabled) : await AppSettings.openAppSettings(type: AppSettingsType.location).then((value) => value);
      ListLocationPermission permission = await getLocationPermissionStatus();
      switch (permission){
        case ListLocationPermission.whileInUse: return true;
        case ListLocationPermission.denied: context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.locationDenied) : await Geolocator.requestPermission(); break;
        case ListLocationPermission.deniedForever: context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.locationDeniedForever) : await openAppSettings(); break;
        case ListLocationPermission.always: return true;
        case ListLocationPermission.unableToDetermine: context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.locationUnableToDetermine) : await openAppSettings(); break;
      }
      await Future.delayed(Duration(seconds: 1)).then((_) => getLocationPermissionStatus().then((value) => value));
      return false;
    } catch (e, s) {
      clog('Terjadi masalah saat requestLocationPermission: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Menginisiasi notifikasi global
  /// Jangan lupa menambahkan permission di AndroidManifest:
  /// - uses-permission android:name="android.permission.POST_NOTIFICATIONS"
  /// dan menambahkan : coreLibraryDesugaringEnabled true, pada app/build.gradle > android > compileOptions
  /// dan menambahkan :
  /// dependencies {
  ///     coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
  /// }
  /// dibawah kode :
  /// flutter {
  ///     source = "../.."
  /// }
  Future<bool> initializeFlutterNotification({BuildContext? context}) async {
    try {
      await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
          macOS: DarwinInitializationSettings(),
          linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
        ),
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
      );

      return await getNotificationPermissionStatus(context: context);
    } catch (e, s) {
      clog('Terjadi masalah saat initializeFlutterNotification: $e\n$s');
      await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Fungsi untuk mengecek status perizinan notifikasi saat ini
  Future<bool> getNotificationPermissionStatus({BuildContext? context}) async {
    try {
      bool? status = await getFlutterLocalNotificationPermission();
      if (status != null && status){
        fcmNotificationSetting = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: false, criticalAlert: true, announcement: true);
        clog('Status Permission Notifikasi FCM: ${fcmNotificationSetting?.authorizationStatus}');
        switch (fcmNotificationSetting?.authorizationStatus) {
          case AuthorizationStatus.authorized:
            _notificationPermission = ListNotificationPermission.authorized;
            notifyListeners();
            return true;
          case AuthorizationStatus.denied:
            _notificationPermission = ListNotificationPermission.denied;
            context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.notificationFirebaseDenied)
                : await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: false, criticalAlert: true, announcement: true).then((value) => fcmNotificationSetting = value);
            break;
          case AuthorizationStatus.notDetermined:
            _notificationPermission = ListNotificationPermission.notDetermined;
            context != null ? showCustomPermissionDialog(context: context, getPermissionType: GetPermissionType.notificationFirebaseDenied)
                : await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true, provisional: false, criticalAlert: true, announcement: true).then((value) => fcmNotificationSetting = value);
            break;
          case AuthorizationStatus.provisional: _notificationPermission = ListNotificationPermission.provisional; break;
          case null: break;
        }
        notifyListeners();
        return false;
      } else {
        clog('Izin Notifikasi Firebase Ditolak! Status Saat Ini: $status');
        return false;
      }
    } catch (e, s) {
      clog('Terjadi masalah saat getNotificationPermissionStatus: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  static PermissionSettingProvider read(BuildContext context) => context.read();
  static PermissionSettingProvider watch(BuildContext context) => context.watch();
}