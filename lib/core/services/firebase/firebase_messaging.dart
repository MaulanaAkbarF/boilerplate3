import 'dart:convert';

import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/input_func.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/page_routes_func.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../ui/page_setting/permission_setting_screen.dart';
import '../../constant_values/_setting_value/log_app_values.dart';
import '../../global_values/global_data.dart';
import '../../models/_global_widget_model/notification.dart';
import '../../state_management/providers/_global_widget/fcm_notification_provider.dart';
import '../../state_management/providers/_settings/permission_provider.dart';
import '../../utilities/functions/logger_func.dart';
import '../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

/// Fungsi untuk menampilkan banner notifikasi pada notification center
Future<void> showLocalNotification({required int id, required String title, required String description, required String payload}) async {
  try{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id.toString(),
      title,
      channelDescription: 'channel1',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      enableVibration: false,
      ticker: 'ticker',
    );
    await flutterLocalNotificationsPlugin.show(id, title, description, NotificationDetails(android: androidPlatformChannelSpecifics), payload: payload);
  } catch (e, s) {
    clog('Terjadi kesalahan saat showLocalNotification: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
  }
}

/// Trigger notifikasi lokal (buat test notif)
Future<void> triggerLocalNotification({String? title, String? description, Map<String, dynamic>? payload}) async {
  await showLocalNotification(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: title ?? 'Judul notif nih',
    description: description ?? 'Ini deskripsi. Kalo ini muncul berarti udah aman sih',
    payload: payload != null ? json.encode(payload) : json.encode({
      'id': generateRandomString(20),
      'timestamp': DateTime.now().toIso8601String(),
    }),
  );
}

/// ------------------------------------------------------- FIREBASE MESSAGING FUNCTIONS -------------------------------------------------------

/// Inisiasi objek Notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationSettings? fcmNotificationSetting;

/// Fungsi ini akan dijalankan ketika notifikasi di klik saat kondisi aplikasi berada di latar depan [onForeground]
void onDidReceiveNotificationResponse(NotificationResponse message) {
  try {
    final String? payload = message.payload;
    if (message.payload != null) {
      try {
        clog("Payload Notifikasi Mentah: $payload");
        if (payload == '') clog("Payload Notifikasi Kosong!");
        if (payload != '') {
          startNavigatorPush(OtherPermissionSettingScreen());
          // switch (payload) {
          //   case "case_1": startNavigatorPush(SplashScreen()); break;
          //   case "case_2": startNavigatorPush(SplashScreen()); break;
          //   case "case_3": startNavigatorPush(SplashScreen()); break;
          //   default: break;
          // }
        }
      } catch (e, s) {
        clog('Terjadi kesalahan saat memparsing data notifikasi: $e\n$s');
        addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      }
    }
  } catch (e, s) {
    clog('Terjadi kesalahan saat onDidReceiveNotificationResponse: $e\n$s');
    addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
  }
}

void onNotificationTap(NotificationResponse notificationResponse) {
  clog('Notifikasi di Tap');
}

/// Fungsi untuk menginisiasi notifikasi (kasarannya untuk mengaktifkan notifikasi) dan menangani berbagai kondisi pada notifikasi
Future<void> fcmNotificationInit(BuildContext context) async {
  await PermissionSettingProvider.read(context).initializeFlutterNotification(context: context).then((value){
    if (!value) clog('Perizinan Notifikasi FCM belum diizinkan!');
    if (value){
      FirebaseMessaging.instance.getInitialMessage().then(_fcmListener);
      FirebaseMessaging.onMessageOpenedApp.listen(_fcmListener);
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
      /// Fungsi ini akan dijalankan ketika mendapatkan notifikasi saat kondisi aplikasi berada di latar depan [onForeground]
      FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
        if (message == null) clog('Notifikasi FCM Kosong!');
        if (message != null) {
          clog("FCM Foreground Data: ${message.data}");
          try {
            NotificationModel notification = NotificationModel.fromJson(message.data);
            await showLocalNotification(
              id: notification.id ?? 1,
              title: notification.title ?? 'title',
              description: notification.description ?? 'description',
              payload: json.encode(notification.toJson())
            );
            FcmNotificationProvider.read(context).addSingleUnread(1);
          } catch (e, s) {
            clog('Terjadi kesalahan saat memparsing data Notifikasi FCM: $e\n$s');
            addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
          }
        }
      });
    }
  });
}

/// Fungsi ini akan dijalankan ketika mendapatkan notifikasi saat kondisi aplikasi berada di latar belakang [onBackground]
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  clog("FCM Background Data: ${message.data}");
}

/// Fungsi ini akan dijalankan ketika notifikasi di klik saat kondisi aplikasi berada di latar belakang [onBackground]
void _fcmListener(RemoteMessage? message) async {
  if (message == null) clog('Listener Notifikasi FCM Kosong!');
  if (message != null) {
    clog("Notification diklik! Data Mentah: ${message.data}");
    startNavigatorPush(OtherPermissionSettingScreen());
  }
}

/// Fungsi untuk mendapatkan token FCM (biasanya digunakan untuk test Send Notification melalui Firebase Console
Future<String> getFcmNotificationToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  clog('Token Notifikasi FCM: $token');
  GlobalData.fcmToken = token;
  return token ?? '';
}