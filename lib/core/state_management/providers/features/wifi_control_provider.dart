import 'dart:async';

import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/system_func.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../models/features/wifi_network.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/functions/permission/hardware_permission.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class WifiControlProvider extends ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  WifiNetworkDetails? _networkDetails;
  List<WiFiAccessPoint> _accessPoints = [];
  String? _currentSsid;
  bool _isWifiEnabled = false;
  bool _isConnected = false;
  bool _isScanning = false;
  bool _isExpandedInfo = false;
  StreamSubscription<List<WiFiAccessPoint>>? _scanSubscription;

  NetworkInfo get networkInfo => _networkInfo;
  WifiNetworkDetails? get networkDetails => _networkDetails;
  List<WiFiAccessPoint> get accessPoints => _accessPoints;
  String? get currentSsid => _currentSsid;
  bool get isWifiEnabled => _isWifiEnabled;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  bool get isExpandedInfo => _isExpandedInfo;
  StreamSubscription<List<WiFiAccessPoint>>? get scanSubscription => _scanSubscription;

  /// Inisialisasi plugin
  /// Jangan lupa menambahkan permission di AndroidManifest:
  /// - uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
  /// - uses-permission android:name="android.permission.ACCESS_WIFI_STATE"
  /// - uses-permission android:name="android.permission.CHANGE_WIFI_STATE"
  /// - uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"
  Future<void> initialize() async {
    await checkPermissions();
    await updateWifiStatus();
    await getCurrentWifi();
    notifyListeners();
  }

  /// Fungsi untuk mengecek dan request permission
  Future<bool> checkPermissions() async {
    await getLocationPermission(requestForWifiControl: true).then((statuses) async {
      if (!statuses) {
        clog('Beberapa perizinan tidak diberikan! Wi-Fi Contol memerlukan perizinan lengkap');
        return statuses;
      }

      await getLocationServiceStatus().then((statuses) {
        if (!statuses) {
          clog('Lokasi belum diaktifkan! Harap aktifkan lokasi untuk dapat menggunakan Wi-Fi Control');
          return statuses;
        }
      });
    });

    return true;
  }

  /// Perbarui status Wi-Fi enabled dan connected
  Future<void> updateWifiStatus() async {
    try {
      _isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      _isConnected = await WiFiForIoTPlugin.isConnected();
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider updateWifiStatus: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Dapatkan info Wi-Fi saat ini (SSID, etc.)
  Future<void> getCurrentWifi() async {
    try {
      _currentSsid = await _networkInfo.getWifiName();
      if (_currentSsid == null && _isConnected) _currentSsid = await WiFiForIoTPlugin.getSSID();
      await updateNetworkDetails();
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider getCurrentWifi: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Ambil semua detail jaringan dari NetworkInfo
  Future<void> updateNetworkDetails() async {
    try {
      final ssid = await _networkInfo.getWifiName();
      final bssid = await _networkInfo.getWifiBSSID();
      final ipAddress = await _networkInfo.getWifiIP();
      final ipv6Address = await _networkInfo.getWifiIPv6();
      final subnetMask = await _networkInfo.getWifiSubmask();
      final gatewayIp = await _networkInfo.getWifiGatewayIP();
      final broadcastIp = await _networkInfo.getWifiBroadcast();
      print('NETWORKINFO: $ssid, $bssid, $ipv6Address, $ipAddress, $subnetMask');

      _networkDetails = WifiNetworkDetails.fromNetworkInfo(
        ssid: ssid,
        bssid: bssid,
        ipAddress: ipAddress,
        ipv6Address: ipv6Address,
        subnetMask: subnetMask,
        gatewayIp: gatewayIp,
        broadcastIp: broadcastIp,
      );
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider updateNetworkDetails: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      _networkDetails = null;
    } finally {
      notifyListeners();
    }
  }

  void toggleMoreWifiInfo(){
    _isExpandedInfo = !_isExpandedInfo;
    notifyListeners();
  }

  /// Mulai scanning Wi-Fi
  Future<void> startScan() async {
    if (_isScanning) {
      stopScan();
      return;
    }
    _isScanning = true;
    _accessPoints = [];
    notifyListeners();

    try {
      final canStart = await WiFiScan.instance.canStartScan(askPermissions: true);
      if (canStart != CanStartScan.yes) {
        _isScanning = false;
        notifyListeners();
        return;
      }

      await WiFiScan.instance.startScan();
      _scanSubscription = WiFiScan.instance.onScannedResultsAvailable.listen((results) {
        _accessPoints = results;
        notifyListeners();
      });
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider startScan: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Hentikan listening scan
  void stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    _isScanning = false;
    notifyListeners();
  }

  /// Hubungkan ke Wi-Fi dengan SSID dan password
  Future<bool> connectToWifi(String ssid, String password, {BuildContext? context, NetworkSecurity security = NetworkSecurity.WPA}) async {
    notifyListeners();
    try {
      if (!_isWifiEnabled) await toggleWifi(true);
      final success = await WiFiForIoTPlugin.connect(ssid, password: password, security: security, withInternet: true);
      if (success) {
        await updateWifiStatus();
        await getCurrentWifi();
        await updateNetworkDetails();
        return true;
      } else {
        clog('Gagal terhubung ke $ssid');
        if (context != null) showSnackBar(context, 'Gagal terhubung ke $ssid\nHarap pastikan Anda memasukan kata sandi yang benar');
      }
      return false;
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider connectToWifi: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Disconnect dari Wi-Fi saat ini
  Future<void> disconnect() async {
    notifyListeners();
    try {
      if (_currentSsid != null) await WiFiForIoTPlugin.removeWifiNetwork(_currentSsid!);
      await WiFiForIoTPlugin.disconnect();
      await updateWifiStatus();
      await getCurrentWifi();
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider disconnect: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Toggle Wi-Fi enabled/disabled (handle deprecation)
  Future<void> toggleWifi(bool enabled) async {
    notifyListeners();
    try {
      /// Di Android >=29 dan iOS, buka settings jika deprecated
      await WiFiForIoTPlugin.setEnabled(enabled, shouldOpenSettings: true);
      await updateWifiStatus();
    } catch (e, s) {
      clog('Terjadi masalah saat WifiControlProvider toggleWifi: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopScan();
    super.dispose();
  }

  static WifiControlProvider read(BuildContext context) => context.read();
  static WifiControlProvider watch(BuildContext context) => context.watch();
}