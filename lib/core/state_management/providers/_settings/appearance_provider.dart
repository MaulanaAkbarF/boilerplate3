import 'dart:convert';
import 'dart:io';

import 'package:boilerplate_3_firebaseconnect/core/state_management/providers/_settings/permission_provider.dart';
import 'package:boilerplate_3_firebaseconnect/core/state_management/providers/_settings/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant_values/_setting_value/appearance_values.dart';
import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../global_values/_setting_data.dart';
import '../../../models/_settings_model/appearances.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'log_app_provider.dart';

class AppearanceSettingProvider extends ChangeNotifier{
  String _fontType = '';
  ListFontSize _fontSize = ListFontSize.medium;
  ListPreferredOrientation _preferredOrientation = ListPreferredOrientation.active;
  ListSafeAreaMode _isSafeArea = ListSafeAreaMode.active;
  ListTabletMode _isTabletMode = ListTabletMode.deactive;
  ListChangeToTabletMode _tabletModePixel = ListChangeToTabletMode.normal;
  ListThemeApp _themeType = ListThemeApp.light;
  Brightness _brightnessTheme = Brightness.light;
  Brightness _brightnessDarkTheme = Brightness.dark;
  bool _trueBlack = false;
  bool _isChanged = false;

  String get fontType => _fontType;
  ListFontSize get fontSizeString => _fontSize;
  ListPreferredOrientation get preferredOrientation => _preferredOrientation;
  ListSafeAreaMode get isSafeArea => _isSafeArea;
  ListTabletMode get isTabletMode => _isTabletMode;
  ListChangeToTabletMode get tabletModePixel => _tabletModePixel;
  ListThemeApp get themeType => _themeType;
  Brightness get brightnessTheme => _brightnessTheme;
  Brightness get brightnessDarkTheme => _brightnessDarkTheme;
  bool get trueBlack => _trueBlack;
  bool get isChanged => _isChanged;

  /// Fungsi untuk mengisiasi data saat pertama kali aplikasi dijalankan
  Future<void> initData(BuildContext context) async {
    print('RUNRUNRUNR');
    await getData();
    await PreferenceSettingProvider.read(context).getData();
    await PermissionSettingProvider.read(context).getLocationPermissionStatus();
    await LogAppSettingProvider.read(context).automaticallyDeleteLogAppWhenDateReached();
  }

  /// Mengatur jenis font aplikasi
  Future<void> setFontType(String data, {bool? notify}) async {
    _fontType = data;
    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Mengatur ukuran font aplikasi
  Future<void> setFontSize(String data, {bool? notify}) async {
    try {
      if (data.contains(ListFontSize.verySmall.text)) _fontSize = ListFontSize.verySmall;
      else if (data.contains(ListFontSize.small.text)) _fontSize = ListFontSize.small;
      else if (data.contains(ListFontSize.medium.text)) _fontSize = ListFontSize.medium;
      else if (data.contains(ListFontSize.veryLarge.text)) _fontSize = ListFontSize.veryLarge;
      else if (data.contains(ListFontSize.large.text)) _fontSize = ListFontSize.large;
      else _fontSize = ListFontSize.medium;

      await updateModel();
      if (notify != null && notify) notifyListeners();
    } catch (e, s) {
      clog('Terjadi masalah saat setFontSize: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Mengatur penggunaan Safe Area (Notch) pada aplikasi.
  /// Jika Safe Area false, maka akan memperluas tampilan aplikasi sampai ke status bar
  Future<void> setPreferredOrientation(bool data, {bool? notify}) async {
    if (data == ListPreferredOrientation.active.condition) {
      _preferredOrientation = ListPreferredOrientation.active;
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    } else {
      _preferredOrientation = ListPreferredOrientation.deactive;
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
      ]);
    }

    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Mengatur penggunaan Safe Area (Notch) pada aplikasi.
  /// Jika Safe Area false, maka akan memperluas tampilan aplikasi sampai ke status bar
  Future<void> setIsSafeArea(bool data, {bool? notify}) async {
    if (data == ListSafeAreaMode.active.condition) {
      _isSafeArea = ListSafeAreaMode.active;
    } else {
      _isSafeArea = ListSafeAreaMode.deactive;
    }

    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Mengatur mode tablet diaktifkan atau tidak pada aplikasi
  /// Mode Tablet berfungsi jika pengguna menggunakan tablet, maka UI akan berubah dan menyesuaikan lebar layar tablet
  /// Tampilan tablet didefinisikan secara manual melalui penggunakan setWideLayout() pada setiap halaman
  Future<void> setIsTabletMode(bool data, {bool? notify}) async {
    if (data == ListTabletMode.active.condition) {
      _isTabletMode = ListTabletMode.active;
    } else {
      _isTabletMode = ListTabletMode.deactive;
    }

    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Mengatur lebar layar (dalam pixel) ketika berubah menjadi mode tablet (WideLayout)
  /// Semakin kecil, maka tampikan akan lebih mudah berubah menjadi mode tablet
  Future<void> setTabletModePixel(String data, {bool? notify}) async {
    try {
      if (data.contains(ListChangeToTabletMode.narrow.text)) {
        _tabletModePixel = ListChangeToTabletMode.narrow;
      } else if (data.contains(ListChangeToTabletMode.normal.text)) _tabletModePixel = ListChangeToTabletMode.normal;
      else if (data.contains(ListChangeToTabletMode.wide.text)) _tabletModePixel = ListChangeToTabletMode.wide;
      else if (data.contains(ListChangeToTabletMode.veryWide.text)) _tabletModePixel = ListChangeToTabletMode.veryWide;
      else _tabletModePixel = ListChangeToTabletMode.normal;
    } catch (e, s) {
      clog('Terjadi masalah saat setTabletModePixel: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Mengatur tema aplikasi
  Future<void> setThemeType(String data, {bool? notify}) async {
    try {
      if (data.contains(ListThemeApp.light.text)){
        _themeType = ListThemeApp.light;
        _brightnessTheme = Brightness.light;
        _brightnessDarkTheme = Brightness.light;
        _trueBlack = false;
      } else if (data.contains(ListThemeApp.dark.text)){
        _themeType = ListThemeApp.dark;
        _brightnessTheme = Brightness.dark;
        _brightnessDarkTheme = Brightness.dark;
        _trueBlack = false;
      } else if (data.contains(ListThemeApp.system.text)){
        _themeType = ListThemeApp.system;
        _brightnessTheme = Brightness.light;
        _brightnessDarkTheme = Brightness.dark;
        _trueBlack = false;
      } else if (data.contains(ListThemeApp.black.text)){
        _themeType = ListThemeApp.black;
        _brightnessTheme = Brightness.light;
        _brightnessDarkTheme = Brightness.dark;
        _trueBlack = true;
      } else{
        _themeType = ListThemeApp.system;
        _brightnessTheme = Brightness.light;
        _brightnessDarkTheme = Brightness.dark;
        _trueBlack = false;
      } ;
    } catch (e, s) {
      clog('Terjadi masalah saat setThemeType: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }

    await updateModel();
    if (notify != null && notify) notifyListeners();
  }

  /// Memperbarui data pada Shared Preferences
  Future<void> updateModel() async {
    AppearancesModelSetting pref = AppearancesModelSetting(
      fontType: _fontType,
      fontSize: _fontSize,
      preferredOrientation: _preferredOrientation,
      isSafeArea: _isSafeArea,
      isTabletMode: _isTabletMode,
      tabletModePixel: _tabletModePixel,
      themeType: _themeType
    );

    await AppearanceHelper.saveAppearances(pref);
  }

  /// Mengambil data pada Shared Preferences
  Future<void> getData() async {
    try{
      AppearancesModelSetting? pref = await AppearanceHelper.getAppearances();
      if (pref != null){
        await setFontType(pref.fontType);
        await setFontSize(pref.fontSize.text);
        await setPreferredOrientation(pref.preferredOrientation.condition);
        await setIsSafeArea(pref.isSafeArea.condition);
        await setIsTabletMode(pref.isTabletMode.condition);
        await setTabletModePixel(pref.tabletModePixel.text);
        await setThemeType(pref.themeType.text);
      } else {
        await setFontType(Platform.isAndroid ? ListFontType.google.text : Platform.isIOS ? ListFontType.apple.text : ListFontType.segoe.text);
        await setFontSize(ListFontSize.medium.text);
        await setPreferredOrientation(ListPreferredOrientation.active.condition);
        await setIsSafeArea(ListSafeAreaMode.active.condition);
        await setIsTabletMode(ListTabletMode.deactive.condition);
        await setTabletModePixel(ListChangeToTabletMode.normal.text);
        await setThemeType(ListThemeApp.system.text);
      }
    } catch (e, s) {
      clog('Terjadi masalah saat getData: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Menunjukkan perubahan pada user ketika aplikasi user masih aktif dan belum di restart
  void setChanged({bool? notify}){
    _isChanged = true;
    if (notify != null && notify) notifyListeners();
  }

  static AppearanceSettingProvider read(BuildContext context) => context.read();
  static AppearanceSettingProvider watch(BuildContext context) => context.watch();
}

/// Class untuk menyimpan data Appearance Setting ke dalam Shared Preferences
class AppearanceHelper {
  static const String prefKey = 'appearance_setting';

  static Future<bool> saveAppearances(AppearancesModelSetting prefsSetting) async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.setString(prefKey, jsonEncode(prefsSetting.toJson())));
  }

  static Future<bool> clearAppearances() async {
    return await SharedPreferences.getInstance().then((prefs) => prefs.remove(prefKey));
  }

  static Future<AppearancesModelSetting?> getAppearances() async {
    final String? jsonString = await SharedPreferences.getInstance().then((prefs) => prefs.getString(prefKey));
    if (jsonString == null) return null;

    try {
      return AppearancesModelSetting.fromJson(jsonDecode(jsonString));
    } catch (e, s) {
      clog('Terjadi masalah saat decoding getAppearances: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return null;
    }
  }
}

/// Fungsi untuk mengatur konfigurasi Appearance awal saat aplikasi dijalankan/direstart
Future<void> getInitialAppearancesData() async {
  AppearancesModelSetting? pref = await AppearanceHelper.getAppearances();
  if (pref != null){
    AppearancesSettingData.preferredOrientation = pref.preferredOrientation.condition;
  } else {
    AppearancesSettingData.preferredOrientation = false;
  }
}