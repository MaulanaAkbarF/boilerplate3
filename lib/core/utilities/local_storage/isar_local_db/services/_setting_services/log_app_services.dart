import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/int_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../../../../constant_values/_setting_value/log_app_values.dart';
import '../../../../../state_management/providers/_settings/log_app_provider.dart';
import '../../../../functions/logger_func.dart';
import '../../../sqflite/services/_setting_services/log_app_services.dart';
import '../../_initialize/init_isar.dart';
import '../../collections/_setting_collection/log_app.dart';

class LogAppServices {
  static Future<Isar> isarDB = openIsarDB();

  static Future<void> insertLogApp({required String level, int? statusCode, required String title, String? subtitle, String? description, required String logs}) async {
    try {
      if (!kIsWeb){
        final collection = LogAppCollection()
          ..logDate = DateTime.now()
          ..level = level
          ..statusCode = statusCode
          ..title = title
          ..subtitle = subtitle
          ..description = description
          ..logs = logs;

        await isarDB.then((isar) async => await isar.writeTxn(() async => await isar.logAppCollections.put(collection)));
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat menyimpan log aplikasi ke dalam local storage.\n$title\n$logs');
      }
    } catch (e, s) {
      clog('Terjadi masalah saat insert Database Local LogApp: $e\n$s');
    }
  }

  static Future<List<LogAppCollection>> getLogApp({bool? filterByAppLog, bool? filterByApiLog}) async {
    try {
      if (!kIsWeb){
        final isar = await isarDB;
        final List<LogAppCollection> collection;
        if (filterByAppLog != null && filterByAppLog) collection = await isar.logAppCollections.filter().statusCodeIsNull().findAll();
        else if (filterByApiLog != null && filterByApiLog) collection = await isar.logAppCollections.filter().statusCodeIsNotNull().findAll();
        else collection = await isar.logAppCollections.where().findAll();

        if (collection.isEmpty) return [];
        collection.sort((a, b) => b.id.compareTo(a.id));
        return collection;
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat mengambil log aplikasi dari local storage');
        return [];
      }
    } catch (e, s) {
      clog('Terjadi masalah saat mengambil semua data pada Database Local LogApp: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return [];
    }
  }

  static Future<bool> deleteAllLogApp() async {
    try {
      if (!kIsWeb){
        await isarDB.then((isar) async => await isar.writeTxn(() async => await isar.logAppCollections.clear()));
        return true;
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat menghapus log aplikasi dari local storage');
        return false;
      }
    } catch (e, s) {
      clog('Terjadi masalah saat menghapus Database Local LogApp: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  static Future<bool> deleteSelectedLogApp(int id) async {
    try {
      final isar = await isarDB;
      final LogAppCollection? collection;
      collection = (await isar.logAppCollections.filter().idEqualTo(id).findFirst());

      if (collection == null) return false;
      await isarDB.then((isar) async => await isar.writeTxn(() async => await isar.logAppCollections.delete(collection!.id)));
      clog('Delete All Log App Success!');
      return true;
    } catch (e, s) {
      clog('Terjadi masalah saat menghapus Database Local LogApp: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Fungsi untuk mendapatkan ukuran database Log App
  /// Nilai integer dari "size" mengembalikan nilai dalam bentuk Bytes (B)
  static Future<(String, int)> getDatabaseSize() async {
    try {
      final isar = await isarDB;
      int size = await isar.logAppCollections.getSize();
      if (size != 0){
        clog('DB Size: ${size.readAsByte}');
        return (size.readAsByte, size);
      } else {
        return ('0 B', 0);
      }
    } catch (e, s) {
      clog('Terjadi masalah saat menghitung ukuran Database: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return ('0 B', 0);
    }
  }

  /// Fungsi untuk menghapus log app otomatis saat batas ukuran maksimal tercapai (default dapat menampung sebesar 32MB)
  static Future<bool?> automaticallyDeleteLogAppWhenSizeReached() async {
    try {
      await getDatabaseSize().then((value) async {
        int maxLogAppSize = await LogAppHelper.getMaxLogAppSize();
        clog('Total Size Now: ${value.$2}, Max Log App: $maxLogAppSize');
        if (value.$2 > maxLogAppSize){
          await deleteAllLogApp();
          return true;
        }
      });
      return false;
    } catch (e, s){
      clog('Terjadi masalah saat automaticallyDeleteLogAppWhenSizeReachede: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }
}

Future<void> addLogApp({required String level, int? statusCode, required String title, String? subtitle, String? description, required String logs}) async {
  try{
    await LogAppServices.insertLogApp(level: level, statusCode: statusCode, title: title, subtitle: subtitle, description: description, logs: logs);
    await addLogAppSql(level: level, statusCode: statusCode, title: title, subtitle: subtitle, description: description, logs: logs);
  } catch (e, s) {
    clog('Terjadi masalah saat add Database Local LogApp: $e\n$s');
  }
}