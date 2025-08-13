import 'dart:io';

import 'package:boilerplate_3_firebaseconnect/core/utilities/extensions/primitive_data/int_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../constant_values/_setting_value/log_app_values.dart';
import '../../../../../models/_global_widget_model/sqflite.dart';
import '../../../../../state_management/providers/_settings/log_app_provider.dart';
import '../../../../functions/logger_func.dart';
import '../../_initialize/init_sqflite.dart';

class SqfliteLogAppServices {
  static Future<void> insertLogApp({required String level, int? statusCode, required String title, String? subtitle, String? description, required String logs}) async {
    try {
      if (!kIsWeb) {
        final db = await SqfliteDatabaseHelper.databases;
        await db.insert(
          SqfliteDatabaseHelper.tableName,
          LogAppSqflite(logDate: DateTime.now(), level: level, statusCode: statusCode, title: title, subtitle: subtitle, description: description, logs: logs).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat menyimpan log aplikasi ke dalam local storage.\n$title\n$logs');
      }
    } catch (e, s) {
      clog('Terjadi masalah saat insert Database Local LogApp: $e\n$s');
    }
  }

  static Future<List<LogAppSqflite>> getLogApp({bool? filterByAppLog, bool? filterByApiLog}) async {
    try {
      if (!kIsWeb) {
        final db = await SqfliteDatabaseHelper.databases;
        String? whereClause;
        List<Object?>? whereArgs;

        if (filterByAppLog != null && filterByAppLog) {
          whereClause = 'statusCode IS NULL';
        } else if (filterByApiLog != null && filterByApiLog) {
          whereClause = 'statusCode IS NOT NULL';
        }

        final List<Map<String, dynamic>> maps = await db.query(SqfliteDatabaseHelper.tableName, where: whereClause, whereArgs: whereArgs, orderBy: 'id DESC');
        if (maps.isEmpty) return [];
        return maps.map((map) => LogAppSqflite.fromMap(map)).toList();
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat mengambil log aplikasi dari local storage');
        return [];
      }
    } catch (e, s) {
      clog('Terjadi masalah saat mengambil semua data pada Database Local LogApp: $e\n$s');
      await addLogAppSql(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return [];
    }
  }

  static Future<bool> deleteAllLogApp() async {
    try {
      if (!kIsWeb) {
        final db = await SqfliteDatabaseHelper.databases;
        await db.delete(SqfliteDatabaseHelper.tableName);
        return true;
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat menghapus log aplikasi dari local storage');
        return false;
      }
    } catch (e, s) {
      clog('Terjadi masalah saat menghapus Database Local LogApp: $e\n$s');
      await addLogAppSql(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  static Future<bool> deleteSelectedLogApp(int id) async {
    try {
      if (!kIsWeb) {
        final db = await SqfliteDatabaseHelper.databases;
        final List<Map<String, dynamic>> result = await db.query(SqfliteDatabaseHelper.tableName, where: 'id = ?', whereArgs: [id]);
        
        if (result.isEmpty) return false;
        final deletedRows = await db.delete(SqfliteDatabaseHelper.tableName, where: 'id = ?', whereArgs: [id]);

        if (deletedRows > 0) {
          clog('Delete Selected Log App Success!');
          return true;
        }
        return false;
      } else {
        clog('Aplikasi dijalankan pada Web. Tidak dapat menghapus log aplikasi dari local storage');
        return false;
      }
    } catch (e, s) {
      clog('Terjadi masalah saat menghapus Database Local LogApp: $e\n$s');
      await addLogAppSql(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Fungsi untuk mendapatkan ukuran database Log App
  /// Nilai integer dari "size" mengembalikan nilai dalam bentuk Bytes (B)
  static Future<(String, int)> getDatabaseSize() async {
    try {
      String path = join(await getDatabasesPath(), SqfliteDatabaseHelper.databaseName);
      final file = File(path);
      if (await file.exists()) {
        int size = await file.length();
        if (size != 0) {
          clog('DB Size: ${size.readAsByte}');
          return (size.readAsByte, size);
        } else {
          return ('0 B', 0);
        }
      } else {
        return ('0 B', 0);
      }
    } catch (e, s) {
      clog('Terjadi masalah saat menghitung ukuran Database: $e\n$s');
      await addLogAppSql(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return ('0 B', 0);
    }
  }

  /// Fungsi untuk menghapus log app otomatis saat batas ukuran maksimal tercapai (default dapat menampung sebesar 32MB)
  static Future<bool?> automaticallyDeleteLogAppWhenSizeReached() async {
    try {
      final sizeInfo = await getDatabaseSize();
      int maxLogAppSize = await LogAppHelper.getMaxLogAppSize();
      clog('Total Size Now: ${sizeInfo.$2}, Max Log App: $maxLogAppSize');
      if (sizeInfo.$2 > maxLogAppSize) {
        await deleteAllLogApp();
        return true;
      }
      return false;
    } catch (e, s) {
      clog('Terjadi masalah saat automaticallyDeleteLogAppWhenSizeReached: $e\n$s');
      await addLogAppSql(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }
}

// Helper function
Future<void> addLogAppSql({required String level, int? statusCode, required String title, String? subtitle, String? description, required String logs}) async {
  try {
    await SqfliteLogAppServices.insertLogApp(level: level, statusCode: statusCode, title: title, subtitle: subtitle, description: description, logs: logs);
  } catch (e, s) {
    clog('Terjadi masalah saat add Database Local LogApp: $e\n$s');
  }
}