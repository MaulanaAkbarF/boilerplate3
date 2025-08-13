import 'dart:async';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/system_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../global_values/global_data.dart';
import '../../../utilities/functions/logger_func.dart';
import '../../../utilities/functions/permission/hardware_permission.dart';
import '../../../utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

class BluetoothControlProvider extends ChangeNotifier {
  final TextEditingController _messageController = TextEditingController();
  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _pairedDevices = [];
  List<Device> _discoveredDevices = [];
  Device _selectedPairingDevice = Device(address: '');
  bool _isScanning = false;
  bool _tryToConnecting = false;
  int _deviceStatus = Device.disconnected;
  List<int> _receivedData = [];
  List<String> _logs = [];
  String _platformVersion = 'Unknown';
  String _uuidSelected = 'Mempersiapkan UUID';

  StreamSubscription<int>? _deviceStatusSubscription;
  StreamSubscription<List<int>>? _dataReceivedSubscription;
  StreamSubscription<Device>? _deviceDiscoveredSubscription;

  List<String> commonUUIDs = [
    "00001101-0000-1000-8000-00805f9b34fb", // SPP (Serial Port Profile)
    "0000111e-0000-1000-8000-00805f9b34fb", // HFP (Hands-Free Profile)
    "0000110b-0000-1000-8000-00805f9b34fb", // Audio Sink
    "00001105-0000-1000-8000-00805f9b34fb", // OBEX Object Push
    "00001106-0000-1000-8000-00805f9b34fb", // OBEX File Transfer
    "0000110a-0000-1000-8000-00805f9b34fb", // A2DP Source
    "0000110c-0000-1000-8000-00805f9b34fb", // AVRCP Target
    "00001112-0000-1000-8000-00805f9b34fb", // Headset Audio Gateway
    "00001108-0000-1000-8000-00805f9b34fb", // Headset
    "fa87c0d0-afac-11de-8a39-0800200c9a66", // Custom Android UUID
    "8ce255c0-200a-11e0-ac64-0800200c9a66", // Another common Android UUID
  ];


  TextEditingController get messageController => _messageController;
  List<Device> get pairedDevices => _pairedDevices;
  List<Device> get discoveredDevices => _discoveredDevices;
  Device get selectedPairingDevice => _selectedPairingDevice;
  bool get isScanning => _isScanning;
  bool get tryToConnecting => _tryToConnecting;
  int get deviceStatus => _deviceStatus;
  String get receivedData => String.fromCharCodes(_receivedData);
  List<String> get logs => _logs;
  String get platformVersion => _platformVersion;
  String get uuidSelected => _uuidSelected;

  /// Inisialisasi plugin dan listener
  /// Jangan lupa menambahkan permission di AndroidManifest:
  /// - uses-permission android:name="android.permission.BLUETOOTH"
  /// - uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
  /// - uses-permission android:name="android.permission.BLUETOOTH_SCAN"
  /// - uses-permission android:name="android.permission.BLUETOOTH_CONNECT"
  /// - uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"
  Future<void> initialize() async {
    try {
      /// Memeriksa prizinan bluetooth classic
      final status = await _bluetoothClassicPlugin.initPermissions();
      if (!status) clog('Perizinan Bluetooth Classic ditolak! Tidak dapat melakukan pemindaian dan menghubungkan perangkat');
      clog('Status Perizinan Bluetooth Classic: $status');
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider _initialize: $e\n$s');
      await addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      /// Kode yang harus diesksekusi saat inisiasi
      /// Terkadang ketika melakukan pengecekan perizinan bluetooth, muncul error bahwa perizinan masih dalam mode "request" dan menunggu tindakan user
      /// Walaupun user telah mengizinkannya
      /// Sehingga saat meminta pengecekan perizinan akan terjadi error
      if (GlobalData.isBluetoothHasBeenInitialized == false){
        _platformVersion = await _bluetoothClassicPlugin.getPlatformVersion() ?? 'Unknown platform version';
        GlobalData.isBluetoothHasBeenInitialized = true;
        setupListeners();
      }
      await getPairedDevices();
      await getConnectedDeviceFromSystem();

    }
    notifyListeners();
  }

  /// Fungsi untuk menjalankan listener dan status dari konektivitas bluetooth
  /// Listener tidak bisa di disposed/dihancurkan!
  /// Jadi letakkan Provider pada hierarki tertinggi (default pada main.dart)
  void setupListeners() {
    try {
      /// Listener untuk status perangkat
      _deviceStatusSubscription = _bluetoothClassicPlugin.onDeviceStatusChanged().listen((status) {
        clog('Status Perangkat Bluetooth Classic: $status');
        _logs.add('Status Perangkat Bluetooth: $status');
        _deviceStatus = status;

        /// Update pernagkat yang terhubung saat ini berdasarkan status
        if (status == Device.connected && _selectedPairingDevice.address.isNotEmpty) {
          _selectedPairingDevice = _selectedPairingDevice;
        } else if (status == Device.disconnected) {
          _selectedPairingDevice = Device(address: '');
        }

        notifyListeners();
      }, onError: (e, s) {
        clog('Terjadi masalah saat BluetoothControlProvider onDeviceStatusChanged: $e\n$s');
        addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
      });

      /// Listener untuk data yang diterima
      _dataReceivedSubscription = _bluetoothClassicPlugin.onDeviceDataReceived().listen((data) {
        clog('Data Diterima oleh Bluetooth Classic: $data');
        _logs.add('Data Diterima oleh Bluetooth: $data');
        _receivedData = [..._receivedData, ...data];
        notifyListeners();
      }, onError: (e, s) {
        clog('Terjadi masalah saat BluetoothControlProvider onDeviceDataReceived: $e\n$s');
        addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
      });

      /// Listener untuk perangkat yang ditemukan saat scanning
      _deviceDiscoveredSubscription = _bluetoothClassicPlugin.onDeviceDiscovered().listen((device) {
        clog('Perangkat Bluetooth Classic Ditemukan: ${device.name}');
        _logs.add('Perangkat Bluetooth Ditemukan: ${device.name}');
        if (!_discoveredDevices.any((d) => d.address == device.address)) {
          _discoveredDevices = [..._discoveredDevices, device];
          notifyListeners();
        }
        notifyListeners();
      }, onError: (e, s) {
        clog('Terjadi masalah saat BluetoothControlProvider onDeviceDiscovered: $e\n$s');
        addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
      });
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider _setupListeners: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Mendapatkan daftar perangkat yang sudah dipasangkan
  Future<void> getPairedDevices({BuildContext? context}) async {
    try {
      await getBluetoothServiceStatus().then((statuses) async {
        if (statuses){
          clog('Bluetooth aktif!');
          _pairedDevices = await _bluetoothClassicPlugin.getPairedDevices();
          notifyListeners();
        } else {
          clog('Bluetooth non-aktif! Harap aktifkan bluetooth untuk dapat melakukan pemindaian');
          if (context != null) showSnackBar(context, 'Bluetooth non-aktif! Harap aktifkan bluetooth untuk dapat melakukan pemindaian');
        }
      });
    } catch (e, s) {
      if (context != null) showSnackBar(context, 'Terjadi masalah ketika mencoba mendapatkan perangkat tersimpan');
      clog('Terjadi masalah saat BluetoothControlProvider getPairedDevices: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Fungsi untuk mendapatkan perangkat yang terhubung dari system level
  Future<void> getConnectedDeviceFromSystem() async {
    try {
      final result = await MethodChannel('bluetooth_system_operations').invokeMethod('getConnectedDevices');
      if (result != null && result is List && result.isNotEmpty) {
        /// Ambil device pertama yang terhubung (jika ada)
        final deviceData = result.first as Map;
        _selectedPairingDevice = Device(address: deviceData['address'] ?? '', name: deviceData['name'] ?? 'Unknown Device');
        _deviceStatus = Device.connected;

        clog('Perangkat terhubung: ${_selectedPairingDevice.name} (${_selectedPairingDevice.address})');
        _logs.add('Perangkat terhubung: ${_selectedPairingDevice.name} (${_selectedPairingDevice.address})');
      } else {
        _selectedPairingDevice = Device(address: '');
        clog('Tidak ada perangkat yang terhubung pada system level');
        _logs.add('Tidak ada perangkat yang terhubung pada system level');
      }
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider getConnectedDeviceFromSystem: $e\n$s');
      await addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
    }
  }

  /// Memulai atau menghentikan pemindaian perangkat
  Future<void> scanDevices({BuildContext? context}) async {
    try {
      await getBluetoothServiceStatus().then((statuses) async {
        if (statuses){
          clog('Bluetooth aktif!');
          if (_isScanning) {
            await _bluetoothClassicPlugin.stopScan();
            _isScanning = false;
          } else {
            _discoveredDevices = [];
            await _bluetoothClassicPlugin.startScan();
            _isScanning = true;
          }
          notifyListeners();
        } else {
          clog('Bluetooth non-aktif! Harap aktifkan bluetooth untuk dapat melakukan pemindaian');
          if (context != null) showSnackBar(context, 'Bluetooth non-aktif! Harap aktifkan bluetooth untuk dapat melakukan pemindaian');
          if (_isScanning) {
            await _bluetoothClassicPlugin.stopScan();
            _isScanning = false;
          }
        }
      });
    } catch (e, s) {
      await _bluetoothClassicPlugin.stopScan();
      _isScanning = false;
      clog('Terjadi masalah saat BluetoothControlProvider scanDevices: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    }
    notifyListeners();
  }

  /// Menghubungkan ke perangkat
  Future<void> connectToDevice(Device device, {bool? useSystemPairing}) async {
    if (_tryToConnecting == false){
      _tryToConnecting = true;
      _deviceStatus = Device.connecting;
      _selectedPairingDevice = device;
      notifyListeners();
      try {
        if (_deviceStatus == Device.connected) {
          clog('Memutuskan koneksi sebelumnya...');
          _logs.add('Memutuskan koneksi sebelumnya...');
          await disconnect();
          await Future.delayed(Duration(milliseconds: 500));
        }

        if (_isScanning) {
          clog('Menghentikan scanning...');
          _logs.add('Menghentikan scanning...');
          await _bluetoothClassicPlugin.stopScan();
          _isScanning = false;
          await Future.delayed(Duration(milliseconds: 300));
        }

        clog('Mencoba menghubungkan ke: ${device.name} (${device.address})');
        bool connected = false;
        if (useSystemPairing != null && useSystemPairing){
          /// Melakukan koneksi dengan System Level
          connected = await _pairDeviceUsingPlatformChannel(device.address);
        } else {
          /// Melakukan koneksi Application Socket Level dengan berbagai UUID
          for (String uuid in commonUUIDs) {
            if (connected) break;
            try {
              clog('Mencoba koneksi ke ${device.address} dengan UUID: $uuid');
              _uuidSelected = uuid;
              notifyListeners();
              await Future.delayed(Duration(milliseconds: 1200));
              connected = await _bluetoothClassicPlugin.connect(device.address, uuid);
              if (_deviceStatus == Device.connected) {
                clog('Koneksi berhasil menggunakan UUID: $uuid');
                _logs.add('Koneksi berhasil menggunakan UUID: $uuid');
                clog('Mengetes stabilitas koneksi dengan menggunakan delay');
                _logs.add('Mengetes stabilitas koneksi dengan menggunakan delay 3 detik');
                await Future.delayed(Duration(milliseconds: 3000));
                clog('Koneksi stabil!');
                _logs.add('Koneksi stabil!');
              } else {
                clog('Koneksi gagal terhubung dengan UUID: $uuid (status: $_deviceStatus)');
              }
            } catch (e, s) {
              clog('Koneksi gagal dengan UUID $uuid\n$s');
              _logs.add('Koneksi gagal dengan UUID $uuid\nMencoba menghubungan dengan UUID lainnya...');
              continue;
            }
          }
        }

        if (!connected) {
          _uuidSelected = 'Mempersiapkan UUID';
          _selectedPairingDevice = Device(address: '');
          if (useSystemPairing != null && useSystemPairing){
            _logs.add('Tidak dapat terhubung dengan peangkat pada System Level!\nHarap coba tes dengan menghubungkan perangkat secara manual pada pengaturan bluetooth');
            throw Exception('Tidak dapat terhubung dengan peangkat pada System Level!\nHarap coba tes dengan menghubungkan perangkat secara manual pada pengaturan bluetooth');
          } else {
            _logs.add('Tidak dapat terhubung dengan semua UUID yang tersedia');
            throw Exception('Tidak dapat terhubung dengan semua UUID yang tersedia');
          }
        }

        await getPairedDevices();
        clog('Koneksi berhasil ke ${_selectedPairingDevice.name}');
        _logs.add('Koneksi berhasil ke ${_selectedPairingDevice.name}');
      } catch (e, s) {
        _selectedPairingDevice = Device(address: '');
        clog('Terjadi masalah saat BluetoothControlProvider connectToDevice: $e\n$s');
        addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      } finally {
        _tryToConnecting = !_tryToConnecting;
        notifyListeners();
      }
    }
  }

  /// Fungsi untuk system pairing menggunakan platform channel (System Level)
  Future<bool> _pairDeviceUsingPlatformChannel(String address) async {
    try {
      return await MethodChannel('bluetooth_system_operations').invokeMethod('pairDevice', {'address': address});
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider _pairDeviceUsingPlatformChannel: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Method untuk mengecek apakah perangkat sudah system-paired
  bool isDeviceSystemPaired(String address) {
    return _pairedDevices.any((device) => device.address == address);
  }

  /// Method untuk unpair perangkat dari sistem
  Future<bool> unpairDevice(String address) async {
    try {
      final result = await MethodChannel('bluetooth_system_operations').invokeMethod('unpairDevice', {'address': address});
      if (result) {
        clog('Berhasil memutuskan sambungan dengan perangkat bluetooth pada System Level');
        _logs.add('Berhasil memutuskan sambungan dengan perangkat bluetooth pada System Level');
        _deviceStatus = Device.disconnected;
        await getPairedDevices();
      }
      return result;
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider unpairDevice: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
      return false;
    }
  }

  /// Memutuskan koneksi
  /// realDisconnected digunakan untuk memutuskan perangkat dan bukan pada saat berganti perangkat
  /// disconnectSystemPairing digunakan untuk memutuskan perangkat pada System Level
  Future<void> disconnect({bool? realDisconnected, bool? disconnectSystemPairing}) async {
    try {
      _logs.add('Memutuskan koneksi dengan perangkat ${_selectedPairingDevice.name}');
      if (disconnectSystemPairing != null && disconnectSystemPairing) await unpairDevice(_selectedPairingDevice.address);
      if (realDisconnected != null && realDisconnected) _selectedPairingDevice = Device(address: '');
      await _bluetoothClassicPlugin.disconnect();
    } catch (e, s) {
      clog('Terjadi masalah saat BluetoothControlProvider disconnect: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Mengirim data
  Future<void> sendData(String data) async {
    _logs.add('Mengirim pesan ke perangkat ${_selectedPairingDevice.name}\nPesan: $data');
    if (_deviceStatus == Device.connected) {
      await _bluetoothClassicPlugin.write(data);
      notifyListeners();
    }
  }

  /// Fungsi untuk mematikan mode searching bluetooth saat meninggalkan halaman
  void turnOff() {
    try {
      _logs.add('Mematikan pemindaian dan meninggalkan halaman');
      if (_tryToConnecting == true) _tryToConnecting = false;
      if (_isScanning) {
        _bluetoothClassicPlugin.stopScan();
        _isScanning = !_isScanning;
      }
      if (_deviceStatusSubscription != null) _deviceStatusSubscription!.cancel();
      if (_dataReceivedSubscription != null) _dataReceivedSubscription!.cancel();
      if (_deviceDiscoveredSubscription != null) _deviceDiscoveredSubscription!.cancel();
    } catch (e, s){
      clog('Terjadi masalah saat BluetoothControlProvider turnOff: $e\n$s');
      addLogApp(level: ListLogAppLevel.severe.level, title: e.toString(), logs: s.toString());
    } finally {
      notifyListeners();
    }
  }

  static BluetoothControlProvider read(BuildContext context) => context.read();
  static BluetoothControlProvider watch(BuildContext context) => context.watch();
}

/*
Untuk dapat menggunakan fitur Bluetooth Classic hingga System Level, kamu harus memodifikasi kode native.
Berikut contoh perubahan kode Native pada MainActivity (Kotlin):

package com.maulana.boilerplate_3_firebaseconnect

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothProfile
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "bluetooth_system_operations"
    private lateinit var bluetoothAdapter: BluetoothAdapter

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Initialize Bluetooth Adapter
        try {
            bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        } catch (e: Exception) {
            // Handle case where Bluetooth is not available
            println("Bluetooth not available: ${e.message}")
        }

        // Set up Method Channel for Bluetooth System Operations
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pairDevice" -> {
                    val address = call.argument<String>("address")
                    if (address != null) {
                        pairDevice(address, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Address is required", null)
                    }
                }
                "unpairDevice" -> {
                    val address = call.argument<String>("address")
                    if (address != null) {
                        unpairDevice(address, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Address is required", null)
                    }
                }
                "isBluetoothEnabled" -> {
                    try {
                        val isEnabled = ::bluetoothAdapter.isInitialized && bluetoothAdapter.isEnabled
                        result.success(isEnabled)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "getConnectedDevices" -> {
                    getConnectedDevices(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getConnectedDevices(result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val connectedDevices = mutableListOf<Map<String, Any>>()

            try {
                // Get connected devices for different profiles
                val profileListener = object : BluetoothProfile.ServiceListener {
                    override fun onServiceConnected(profile: Int, proxy: BluetoothProfile?) {
                        proxy?.let { bluetoothProfile ->
                            val devices = bluetoothProfile.connectedDevices
                            for (device in devices) {
                                val deviceInfo = mapOf(
                                    "name" to (device.name ?: "Unknown Device"),
                                    "address" to device.address,
                                    "bondState" to device.bondState,
                                    "profile" to profile
                                )

                                // Avoid duplicates based on address
                                if (!connectedDevices.any { it["address"] == device.address }) {
                                    connectedDevices.add(deviceInfo)
                                }
                            }
                        }
                        bluetoothAdapter.closeProfileProxy(profile, proxy)
                    }

                    override fun onServiceDisconnected(profile: Int) {
                        // Not used in this implementation
                    }
                }

                // Check for A2DP profile (Audio)
                bluetoothAdapter.getProfileProxy(this, profileListener, BluetoothProfile.A2DP)

                // Check for Headset profile
                bluetoothAdapter.getProfileProxy(this, profileListener, BluetoothProfile.HEADSET)

                // Add delay to allow profile connections to complete
                Handler(Looper.getMainLooper()).postDelayed({
                    // Also check paired devices that might be connected but not through specific profiles
                    val pairedDevices = bluetoothAdapter.bondedDevices
                    for (device in pairedDevices) {
                        // You can add additional checks here to determine if device is actually connected
                        // This is a basic implementation - for more accuracy you might need to use reflection
                        // or check device connection state through other means

                        if (!connectedDevices.any { it["address"] == device.address }) {
                            // Only add if we can confirm it's connected (this is simplified)
                            val deviceInfo = mapOf(
                                "name" to (device.name ?: "Unknown Device"),
                                "address" to device.address,
                                "bondState" to device.bondState,
                                "profile" to -1 // Indicates unknown/general profile
                            )
                            // Note: This will add all paired devices.
                            // For more accurate detection, you might need additional checks
                        }
                    }

                    result.success(connectedDevices)
                }, 1000) // 1 second delay

            } catch (e: SecurityException) {
                result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
            }

        } catch (e: Exception) {
            result.error("ERROR", "Error getting connected devices: ${e.message}", null)
        }
    }

    private fun pairDevice(address: String, result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val device = bluetoothAdapter.getRemoteDevice(address)

            // Check if device address is valid
            if (!BluetoothAdapter.checkBluetoothAddress(address)) {
                result.error("INVALID_ADDRESS", "Invalid Bluetooth address", null)
                return
            }

            // Check if already paired
            if (device.bondState == BluetoothDevice.BOND_BONDED) {
                result.success(true)
                return
            }

            // Check if currently pairing
            if (device.bondState == BluetoothDevice.BOND_BONDING) {
                result.error("ALREADY_PAIRING", "Device is already in pairing process", null)
                return
            }

            // Start pairing process
            val pairingResult = device.createBond()

            if (pairingResult) {
                // Register receiver to listen for pairing result
                val pairingReceiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val action = intent?.action
                        if (BluetoothDevice.ACTION_BOND_STATE_CHANGED == action) {
                            val deviceFromIntent = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                            if (deviceFromIntent?.address == address) {
                                when (deviceFromIntent.bondState) {
                                    BluetoothDevice.BOND_BONDED -> {
                                        try {
                                            context?.unregisterReceiver(this)
                                        } catch (e: Exception) {
                                            // Receiver might already be unregistered
                                        }
                                        result.success(true)
                                    }
                                    BluetoothDevice.BOND_NONE -> {
                                        try {
                                            context?.unregisterReceiver(this)
                                        } catch (e: Exception) {
                                            // Receiver might already be unregistered
                                        }
                                        result.error("PAIRING_FAILED", "Pairing was rejected or failed", null)
                                    }
                                    // BOND_BONDING state - still in progress, do nothing
                                }
                            }
                        }
                    }
                }

                val filter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
                registerReceiver(pairingReceiver, filter)

                // Set timeout for pairing (30 seconds)
                Handler(Looper.getMainLooper()).postDelayed({
                    try {
                        unregisterReceiver(pairingReceiver)
                        if (device.bondState != BluetoothDevice.BOND_BONDED) {
                            result.error("PAIRING_TIMEOUT", "Pairing timeout after 30 seconds", null)
                        }
                    } catch (e: Exception) {
                        // Receiver might already be unregistered
                        if (device.bondState != BluetoothDevice.BOND_BONDED) {
                            result.error("PAIRING_TIMEOUT", "Pairing timeout", null)
                        }
                    }
                }, 30000) // 30 seconds timeout

            } else {
                result.error("PAIRING_FAILED", "Failed to start pairing process", null)
            }

        } catch (e: SecurityException) {
            result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
        } catch (e: Exception) {
            result.error("PAIRING_ERROR", "Error during pairing: ${e.message}", null)
        }
    }

    private fun unpairDevice(address: String, result: MethodChannel.Result) {
        try {
            // Check if Bluetooth adapter is initialized and enabled
            if (!::bluetoothAdapter.isInitialized) {
                result.error("BLUETOOTH_NOT_AVAILABLE", "Bluetooth adapter not available", null)
                return
            }

            if (!bluetoothAdapter.isEnabled) {
                result.error("BLUETOOTH_DISABLED", "Bluetooth is not enabled", null)
                return
            }

            val device = bluetoothAdapter.getRemoteDevice(address)

            // Check if device address is valid
            if (!BluetoothAdapter.checkBluetoothAddress(address)) {
                result.error("INVALID_ADDRESS", "Invalid Bluetooth address", null)
                return
            }

            if (device.bondState != BluetoothDevice.BOND_BONDED) {
                result.success(true) // Already unpaired
                return
            }

            // Use reflection to call removeBond (hidden method)
            try {
                val removeBondMethod = device.javaClass.getMethod("removeBond")
                val unpairResult = removeBondMethod.invoke(device) as Boolean
                result.success(unpairResult)
            } catch (e: NoSuchMethodException) {
                result.error("METHOD_NOT_FOUND", "removeBond method not available on this Android version", null)
            } catch (e: Exception) {
                result.error("REFLECTION_ERROR", "Error calling removeBond via reflection: ${e.message}", null)
            }

        } catch (e: SecurityException) {
            result.error("PERMISSION_ERROR", "Missing Bluetooth permissions: ${e.message}", null)
        } catch (e: Exception) {
            result.error("UNPAIR_ERROR", "Error during unpairing: ${e.message}", null)
        }
    }
}
 */