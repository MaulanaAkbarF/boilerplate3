import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../ui/layouts/styleconfig/textstyle.dart';
import '../_settings/preference_provider.dart';

class RealtimeProvider extends ChangeNotifier {
  BuildContext? _context;
  String _time = '';
  Timer? _timer;
  static DateTime? _ntpTime;

  String get time => _time;

  /// Inisiasi waktu untuk sementara
  RealtimeProvider(BuildContext context) {
    _time = DateFormat('HH:mm').format(DateTime.now());
  }

  /// Mengisiasi semua objek
  /// Disini tidak bisa menggunakan NTP secara realtime
  Future<void> initialize(BuildContext context) async {
    tz.initializeTimeZones();
    // _ntpTime = await NTP.now(); // Inisiasi NTP disable agar kondisi menggunakan DateTime.now()
    _context = context;
    _initTimer();
  }

  /// Inisiasi timer untuk mmperbarui waktu dengan menjalankan fungsi _updateTime tiap 1  detik
  void _initTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  /// Fungsi _updateTime untuk memperbarui objek _time dengan waktu terbaru
  void _updateTime() {
    _time = DateFormat(Provider.of<PreferenceSettingProvider>(_context!, listen: false).timeFormat.pattern).format(
      tz.TZDateTime.from(_ntpTime ?? DateTime.now(), tz.getLocation(Provider.of<PreferenceSettingProvider>(_context!, listen: false).timeZone.text)));
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Fungsi untuk menambahkan realtime waktu pada Widget Tree
  /// Contoh implementasi kode pada Widget Tree: RealtimeProvider.realtimeWidget(context)
  /// Contoh singkat:
  /// Column(
  ///   children: [
  ///     RealtimeProvider.realtimeWidget(context)
  ///   ]
  /// )
  static Widget realtimeWidget(BuildContext context, {RealtimeProvider? providers, String? text, TextAlign? align, TextStyle? style}) {
    return Consumer<RealtimeProvider>(
      builder: (context, provider, child) {
        if (providers != null && text != null) return cText(context, text, align: align, style: style);
        return cText(context, provider.time, maxLines: 2, align: align, style: style);
      },
    );
  }

  /// Fungsi untuk menambahkan realtime waktu pada sebuah String
  /// Contoh implementasi kode: RealtimeProvider.realtimeString(context)
  /// Contoh singkat: Text("Waktu Saat Ini: ${RealtimeProvider.realtimeString(context)}")
  static String realtimeString(BuildContext context) {
    return DateFormat(Provider.of<PreferenceSettingProvider>(context, listen: false).timeFormat.pattern).format(
        tz.TZDateTime.from(_ntpTime ?? DateTime.now(), tz.getLocation(Provider.of<PreferenceSettingProvider>(context, listen: false).timeZone.text)));
  }
}