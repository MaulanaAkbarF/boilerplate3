import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../constant_values/_setting_value/log_app_values.dart';
import '../../state_management/providers/_settings/preference_provider.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

/// Mengubah string ke format tanggal yang enak dibaca
String formattedDate(BuildContext context, String data, {bool? shortDate}) {
  DateTime? dateTime;
  final List<DateFormat> inputFormats = [
    DateFormat('yyyy-MM-dd HH:mm:ss.SSS', 'id_ID'),
    DateFormat('yyyy-MM-dd HH:mm:ss.SSS', 'en_US'),
    DateFormat('d MMMM y HH:mm:ss', 'id_ID'),
    DateFormat('d MMMM y HH:mm:ss', 'en_US'),
    DateFormat('d MMMM y', 'id_ID'),
    DateFormat('d MMMM y', 'en_US'),
    DateFormat('yyyy-MM-dd HH:mm:ss.SSS'),
    DateFormat('yyyy-MM-dd HH:mm:ss'),
    DateFormat('yyyy-MM-dd'),
    DateFormat('dd/MM/yy HH:mm:ss'),
    DateFormat('dd/MM/yy')
  ];

  for (DateFormat format in inputFormats) {
    try {
      dateTime = format.parse(data);
      break;
    } catch (e, s){
      clog('Tidak dapat memparse dengan format "${format.pattern}" pada tanggal: $data.\n$e\n$s');
      addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
      continue;
    }
  }

  if (dateTime == null) return data;
  if (shortDate != null && shortDate) {
    return DateFormat('dd/MM').format(dateTime);
  } else {
    return DateFormat('d MMMM y', PreferenceSettingProvider.read(context).language.countryFormat).format(dateTime);
  }
}

/// Mengubah string ke format waktu yang enak dibaca
String formattedTime(String data) {
  try{
    return DateFormat('HH:mm').format(DateTime.parse(data));
  } catch (e, s){
    clog('Tidak dapat memparse format waktu: $data.\n$e\n$s');
    addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
    return data;
  }
}

/// Menghitung perbedaan hari dari tanggal sekarang
int countDateFromNow(String data, {DateTime? date}) {
  try{
    DateTime dateTime = DateTime.now();
    if (date != null) dateTime = date;
    if (date == null && data != '') dateTime = DateTime.parse(data);
    return dateTime.difference(DateTime.now()).inDays;
  } catch (e, s){
    clog('Tidak dapat menghitung counter tanggal: $data.\n$e\n$s');
    addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return 0;
  }
}

/// Menghitung perbedaan hari dari tanggal sekarang
bool isDateStillValid(String data, {DateTime? date}) {
  try{
    if (date != null) return date.isAfter(DateTime.now());
    return DateTime.parse(data).isAfter(DateTime.now());
  } catch (e, s){
    clog('Tidak dapat memastikan tanggal $data valid: .\n$e\n$s');
    addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
    return false;
  }
}

Future<void> setTimezone() async {
  String todayDateTimeWIB = await getAntiCheatTime(zone: IndonesiaTimeZone.WIB);
  clog('WIB: $todayDateTimeWIB');

  String todayDateTimeWITA = await getAntiCheatTime(zone: IndonesiaTimeZone.WITA);
  clog('WITA: $todayDateTimeWITA');

  String todayDateTimeWIT = await getAntiCheatTime(zone: IndonesiaTimeZone.WIT);
  clog('WIT: $todayDateTimeWIT');
}

enum IndonesiaTimeZone { WIB, WITA, WIT }
Future<String> getAntiCheatTime({IndonesiaTimeZone zone = IndonesiaTimeZone.WIB}) async {
  tz.initializeTimeZones();

  String timeZoneString;
  switch (zone) {
    case IndonesiaTimeZone.WIB:
      timeZoneString = 'Asia/Jakarta';
      break;
    case IndonesiaTimeZone.WITA:
      timeZoneString = 'Asia/Makassar';
      break;
    case IndonesiaTimeZone.WIT:
      timeZoneString = 'Asia/Jayapura';
      break;
  }

  DateTime ntpTime;
  try {
    ntpTime = await NTP.now();
  } catch (e, s) {
    ntpTime = DateTime.now();
    clog('Gagal mendapatkan waktu NTP. Menggunakan waktu lokal: $e\n$s');
    await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
  }

  return DateFormat('dd/MM/yy / HH:mm:ss').format(tz.TZDateTime.from(ntpTime, tz.getLocation(timeZoneString)));
}