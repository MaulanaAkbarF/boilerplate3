import 'package:shared_preferences/shared_preferences.dart';

class ApiService{
  static int activeEndpoint = 0;
  static String mainEndpoint = 'https://main.endpoint.com/api';
  static String devEndpoint = 'https://dev.endpoint.com/api';
  static String customEndpoint = '';
  
  static String getEndpoint(){
    switch (activeEndpoint){
      case 0 : return mainEndpoint;
      case 1 : return devEndpoint;
      case 2 : return customEndpoint;
      default : return mainEndpoint;
    }
  }
}

class ApiSharedPreferences {
  static const String keyActiveEndpoint = 'keyActiveEndpoint';
  static const String keyCustomEndpoint = 'keyCustomEndpoint';

  static Future<void> setApiCondition(int data, {String? customEndpoint}) async {
    if (customEndpoint != null){
      ApiService.activeEndpoint = 2;
      await SharedPreferences.getInstance().then((prefs) async => await prefs.setInt(keyActiveEndpoint, data));
      await SharedPreferences.getInstance().then((prefs) async => await prefs.setString(keyCustomEndpoint, customEndpoint));
    } else {
      ApiService.activeEndpoint = data;
      await SharedPreferences.getInstance().then((prefs) async => await prefs.setInt(keyActiveEndpoint, data));
    }
  }

  static Future<void> getApiCondition() async {
    int selectedActiveEndpoint = 0;
    final prefs = await SharedPreferences.getInstance();
    /// Atur ke 1 untuk menjalankan dev endpoint saat aplikasi pertama kali diinstal
    /// Clear data untuk mereset shared preferences
    selectedActiveEndpoint = prefs.getInt(keyActiveEndpoint) ?? 0;
    if (selectedActiveEndpoint == 2){
      ApiService.activeEndpoint = selectedActiveEndpoint;
      ApiService.customEndpoint = prefs.getString(keyCustomEndpoint) ?? '';
    } else {
      ApiService.activeEndpoint = selectedActiveEndpoint;
    }
  }
}