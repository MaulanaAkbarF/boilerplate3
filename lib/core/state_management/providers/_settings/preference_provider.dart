import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../constant_values/_setting_value/preferences_values.dart';
import '../../../models/_settings_model/preferences.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class PreferenceSettingProvider extends ChangeNotifier{
  ListLanguage _language = ListLanguage.indonesia;
  ListTimeZone _timeZone = ListTimeZone.jakartaWib;
  ListDateFormat _dateFormat = ListDateFormat.dayMonthYear;
  ListTimeFormat _timeFormat = ListTimeFormat.hourMinute;
  ListUseAnimation _useAnimation = ListUseAnimation.active;
  ListUsePageTransition _pageTransition = ListUsePageTransition.active;
  ListUsePageAnimation _pageAnimation = ListUsePageAnimation.active;
  bool _isChanged = false;

  ListLanguage get language => _language;
  ListTimeZone get timeZone => _timeZone;
  ListDateFormat get dateFormat => _dateFormat;
  ListTimeFormat get timeFormat => _timeFormat;
  ListUseAnimation get useAnimation => _useAnimation;
  ListUsePageTransition get pageTransition => _pageTransition;
  ListUsePageAnimation get pageAnimation => _pageAnimation;
  bool get isChanged => _isChanged;

  /// Mengatur bahasa aplikasi
  Future<void> setLanguage(String data) async {
    try{
      if (data.contains(ListLanguage.indonesia.text)) _language = ListLanguage.indonesia;
      else _language = ListLanguage.indonesia;
    } catch (e, s) {
      clog('Terjadi masalah saat setLanguage: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur zona waktu aplikasi
  Future<void> setTimeZone(String data) async {
    try{
      if (data.contains(ListTimeZone.jakartaWib.text)) _timeZone = ListTimeZone.jakartaWib;
      else if (data.contains(ListTimeZone.makassarWita.text)) _timeZone = ListTimeZone.makassarWita;
      else if (data.contains(ListTimeZone.jayapuraWit.text)) _timeZone = ListTimeZone.jayapuraWit;
      else _timeZone = ListTimeZone.jakartaWib;
    } catch (e, s) {
      clog('Terjadi masalah saat setTimeZone: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur format tanggal aplikasi
  Future<void> setDateFormat(String data) async {
    try{
      if (data.contains(ListDateFormat.dayMonthYear.text)) _dateFormat = ListDateFormat.dayMonthYear;
      else if (data.contains(ListDateFormat.monthDayYear.text)) _dateFormat = ListDateFormat.monthDayYear;
      else if (data.contains(ListDateFormat.dayMonthYearHyphen.text)) _dateFormat = ListDateFormat.dayMonthYearHyphen;
      else if (data.contains(ListDateFormat.dayMonthYearSlash.text)) _dateFormat = ListDateFormat.dayMonthYearSlash;
      else if (data.contains(ListDateFormat.monthDayYearHyphen.text)) _dateFormat = ListDateFormat.monthDayYearHyphen;
      else if (data.contains(ListDateFormat.monthDayYearSlash.text)) _dateFormat = ListDateFormat.monthDayYearSlash;
      else if (data.contains(ListDateFormat.yearDayMonthHyphen.text)) _dateFormat = ListDateFormat.yearDayMonthHyphen;
      else if (data.contains(ListDateFormat.yearDayMonthSlash.text)) _dateFormat = ListDateFormat.yearDayMonthSlash;
      else if (data.contains(ListDateFormat.yearMonthDayHyphen.text)) _dateFormat = ListDateFormat.yearMonthDayHyphen;
      else if (data.contains(ListDateFormat.yearMonthDaySlash.text)) _dateFormat = ListDateFormat.yearMonthDaySlash;
      else _dateFormat = ListDateFormat.dayMonthYear;
    } catch (e, s) {
      clog('Terjadi masalah saat setDateFormat: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur format waktu aplikasi
  Future<void> setTimeFormat(String data) async {
    try{
      if (data.contains(ListTimeFormat.hourMinute.text)) _timeFormat = ListTimeFormat.hourMinute;
      else if (data.contains(ListTimeFormat.hourMinuteSecond.text)) _timeFormat = ListTimeFormat.hourMinuteSecond;
      else if (data.contains(ListTimeFormat.hourMinuteMeridiem.text)) _timeFormat = ListTimeFormat.hourMinuteMeridiem;
      else if (data.contains(ListTimeFormat.hourMinuteSecondMeridiem.text)) _timeFormat = ListTimeFormat.hourMinuteSecondMeridiem;
      else _timeFormat = ListTimeFormat.hourMinute;
    } catch (e, s) {
      clog('Terjadi masalah saat setTimeFormat: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur penggunaan animasi pada aplikasi.
  /// Jika Use Animation false, maka semua animasi di aplikasi akan dinonaktifkan
  Future<void> setUseAnimation(bool data) async {
    if (data == ListUseAnimation.active.condition) {
      _useAnimation = ListUseAnimation.active;
    } else {
      _useAnimation = ListUseAnimation.deactive;
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur penggunaan animasi transisi halaman.
  /// Jika Use Animation false, maka semua animasi di aplikasi akan dinonaktifkan
  Future<void> setPageTransition(bool data) async {
    if (data == ListUsePageTransition.active.condition) {
      _pageTransition = ListUsePageTransition.active;
    } else {
      _pageTransition = ListUsePageTransition.deactive;
    }

    await updateModel();
    notifyListeners();
  }

  /// Mengatur penggunaan animasi halaman.
  /// Jika Use Animation false, maka semua animasi di aplikasi akan dinonaktifkan
  Future<void> setPageAnimation(bool data) async {
    if (data == ListUsePageAnimation.active.condition) {
      _pageAnimation = ListUsePageAnimation.active;
    } else {
      _pageAnimation = ListUsePageAnimation.deactive;
    }

    await updateModel();
    notifyListeners();
  }

  /// Memperbarui data pada Shared Preferences
  Future<void> updateModel() async {
    PreferencesModelSetting pref = PreferencesModelSetting(
      language: _language,
      timeZone: _timeZone,
      dateFormat: _dateFormat,
      timeFormat: _timeFormat,
      useAnimation: _useAnimation,
      pageTransition: _pageTransition,
      pageAnimation: _pageAnimation,
    );

    await PreferenceHelper.savePreferences(pref);
  }

  /// Mengambil data pada Shared Preferences
  Future<void> getData() async {
    try{
      PreferencesModelSetting? pref = await PreferenceHelper.getPreferences();
      if (pref != null){
        await setLanguage(pref.language.text);
        await setTimeZone(pref.timeZone.text);
        await setDateFormat(pref.dateFormat.text);
        await setTimeFormat(pref.timeFormat.text);
        await setUseAnimation(pref.useAnimation.condition);
        await setPageTransition(pref.pageTransition.condition);
        await setPageAnimation(pref.pageAnimation.condition);
      } else {
        await setLanguage(ListLanguage.indonesia.text);
        await setTimeZone(ListTimeZone.jakartaWib.text);
        await setDateFormat(ListDateFormat.dayMonthYear.text);
        await setTimeFormat(ListTimeFormat.hourMinute.text);
        await setUseAnimation(ListUseAnimation.active.condition);
        await setPageTransition(ListUsePageTransition.active.condition);
        await setPageAnimation(ListUsePageAnimation.active.condition);
      }
    } catch (e, s) {
      clog('Terjadi masalah saat getData: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Menunjukkan perubahan pada user ketika aplikasi user masih aktif dan belum di restart
  void setChanged(){
    _isChanged = true;
    notifyListeners();
  }

  static PreferenceSettingProvider read(BuildContext context) => context.read();
  static PreferenceSettingProvider watch(BuildContext context) => context.watch();
}

/// Class untuk menyimpan data Preference Setting ke dalam Shared Preferences
class PreferenceHelper {
  static const String prefKey = 'preference_setting';

  static Future<bool> savePreferences(PreferencesModelSetting prefsSetting) async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.setString(prefKey, jsonEncode(prefsSetting.toJson())));
  }

  static Future<bool> clearPreferences() async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.remove(prefKey));
  }

  static Future<PreferencesModelSetting?> getPreferences() async {
    final String? jsonString = await SharedPreferences.getInstance().then((prefs) => prefs.getString(prefKey));
    if (jsonString == null) return null;

    try {
      return PreferencesModelSetting.fromJson(jsonDecode(jsonString));
    } catch (e, s) {
      clog('Terjadi masalah saat decoding getPreferences: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }
}