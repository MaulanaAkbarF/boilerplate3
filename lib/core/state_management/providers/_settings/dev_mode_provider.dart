import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/http_services/_global_url.dart';

class DevModeProvider extends ChangeNotifier{
  final TextEditingController _tecActiveEndpoint = TextEditingController();
  bool _isActive = false;
  String _activeEndpoint = '';
  bool _isConfig = false;

  TextEditingController get tecActiveEndpoint => _tecActiveEndpoint;
  bool get isActive => _isActive;
  String get activeEndpoint => _activeEndpoint;
  bool get isConfig => _isConfig;

  void initData(){
    _activeEndpoint = ApiService.getEndpoint();
    _tecActiveEndpoint.text = _activeEndpoint;
    notifyListeners();
  }

  // void activate(){
  //   _isActive = true;
  //   notifyListeners();
  // }
  //
  // void deactivate(){
  //   _isActive = false;
  //   notifyListeners();
  // }

  /// Fungsi untuk mengaktifkan dan menonaktifkan developer mode
  void toggle(){
    _isActive = !_isActive;
    notifyListeners();
  }

  Future<void> setNewEndpoint() async {
    ApiService.devEndpoint = _tecActiveEndpoint.text;
    ApiService.activeEndpoint = 1;
    await ApiSharedPreferences.setApiCondition(1);
    initData();
  }

  void restoreMainEndpoint(){
    ApiSharedPreferences.setApiCondition(0);
    ApiService.activeEndpoint = 0;
    initData();
  }

  void restoreDevEndpoint(){
    ApiSharedPreferences.setApiCondition(1);
    ApiService.activeEndpoint = 1;
    initData();
  }

  /// Fungsi untuk menampilkan pengaturan lainnya pada Main Endpoint
  void toggleConfig(){
    _isConfig = !_isConfig;
    notifyListeners();
  }

  static DevModeProvider read(BuildContext context) => context.read();
  static DevModeProvider watch(BuildContext context) => context.watch();
}