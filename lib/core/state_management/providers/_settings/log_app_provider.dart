import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/collections/_setting_collection/log_app.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class LogAppSettingProvider extends ChangeNotifier{
  List<LogAppCollection> _listLogApp = [];
  List<LogAppCollection> _listLogAppError = [];
  List<LogAppCollection> _listLogResponseError = [];

  List<LogAppCollection> get listLogApp => _listLogApp;
  List<LogAppCollection> get listLogAppError => _listLogAppError;
  List<LogAppCollection> get listLogResponseError => _listLogResponseError;

  /// Mengisiasi semua log aplikasi
  Future<void> initialize() async {
    try{
      notifyListeners();
      _listLogApp = await LogAppServices.getLogApp();
      _listLogAppError = await LogAppServices.getLogApp(filterByAppLog: true);
      _listLogResponseError = await LogAppServices.getLogApp(filterByApiLog: true);
    } catch (e, s) {
      clog('Terjadi masalah saat getInitLogApp: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
    notifyListeners();
  }

  /// Menghapus semua log aplikasi
  Future<void> deleteAllLog() async {
    try{
      bool resp = await LogAppServices.deleteAllLogApp();
      if (resp) {
        _listLogApp = [];
        _listLogAppError = [];
        _listLogResponseError = [];
      } else {
        clog('Gagal menghapus semua data log aplikasi!');
      }
    } catch (e, s) {
      clog('Terjadi masalah saat deleteAllLog: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    notifyListeners();
  }

  /// Menghapus log aplikasi terpilih
  Future<void> deleteSelectedLog(int id) async {
    try{
      bool resp = await LogAppServices.deleteSelectedLogApp(id);
      if (resp){
        _listLogApp.removeWhere((log) => log.id == id);
        _listLogAppError.removeWhere((log) => log.id == id);
        _listLogResponseError.removeWhere((log) => log.id == id);
      } else {
        clog('Gagal menghapus semua data log aplikasi!');
      }
    } catch (e, s) {
      clog('Terjadi masalah saat deleteAllLog: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    notifyListeners();
  }

  Future<void> automaticallyDeleteLogAppWhenDateReached() async {
    try{
      DateTime? dateStamp = await LogAppHelper.getLastDate();
      if (dateStamp != null){
        dateStamp.add(Duration(days: 30));
        /// Jika tanggal tersimpan sama dengan hari ini atau lebih dari hari ini, hapus log
        if (DateTime.now().isAtSameMomentAs(dateStamp) || DateTime.now().isAfter(dateStamp)){
          await deleteAllLog();
          LogAppHelper.saveLastDate(DateTime.now());
        /// Jika tanggal tersimpan kurang dari hari ini, jalankan pengecekan batas ukuran log app
        } else {
          await LogAppServices.automaticallyDeleteLogAppWhenSizeReached();
        }
      /// Jika data tersimpan kosong, atur tanggalnya mulai hari ini
      } else {
        LogAppHelper.saveLastDate(DateTime.now());
      }
    } catch (e, s) {
      clog('Terjadi masalah saat automaticallyDeleteLogAppWhenDateReached: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  static LogAppSettingProvider read(BuildContext context) => context.read();
  static LogAppSettingProvider watch(BuildContext context) => context.watch();
}

/// Class untuk menyimpan data LogApp Setting ke dalam Shared Preferences
class LogAppHelper {
  static const String prefKey = 'log_app_setting';
  static const String maxLogAppSizeKey = 'max_log_app_setting';

  static Future<bool> saveLastDate(DateTime date) async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.setString(prefKey, date.toString()));
  }

  static Future<bool> setMaxLogAppSize(int data) async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.setInt(maxLogAppSizeKey, data));
  }

  static Future<DateTime?> getLastDate() async {
    try {
      final String? dateString = await SharedPreferences.getInstance().then((prefs) => prefs.getString(prefKey));
      if (dateString == null) return null;
      return DateTime.parse(dateString);
    } catch (e, s) {
      clog('Terjadi masalah pada getLastDate: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }

  static Future<int> getMaxLogAppSize() async {
    // Default Log App menampung sebesar 32MB (bisa disesuaikan)
    return await SharedPreferences.getInstance().then((prefs) => prefs.getInt(maxLogAppSizeKey) ?? 32000000);
  }
}