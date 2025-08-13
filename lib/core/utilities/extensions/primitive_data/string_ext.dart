import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constant_values/_setting_value/log_app_values.dart';
import '../../../services/http_services/_global_url.dart';
import '../../../state_management/providers/_settings/preference_provider.dart';
import '../../functions/logger_func.dart';
import '../../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';

extension StringManipulator on String {
  /// Mengubah huruf pertama menjadi kapital
  String get capitalizeFirstWord {
    if (contains(" ")) return split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ');
    else return isNotEmpty ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
  }

  /// Mengubah format ke Snake Case
  String get toSnakeCase {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}').replaceAll(' ', '_').toLowerCase();
  }

  /// Mengubah format ke Upper Snake Case
  String get toUpperSnakeCase {
    return toSnakeCase.toUpperCase();
  }

  /// Mengubah format ke Kebab Case
  String get toKebabCase {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}-${m[2]}').replaceAll(' ', '-').toLowerCase();
  }

  /// Mengubah format ke Camel Case
  String get toCamelCase {
    List<String> words = split(RegExp(r'[^a-zA-Z0-9]'));
    if (words.isEmpty) return this;
    String camelCase = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      camelCase += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return camelCase;
  }

  /// Mengubah format ke Pascal Case
  String get toPascalCase {
    List<String> words = split(RegExp(r'[^a-zA-Z0-9]'));
    if (words.isEmpty) return this;
    return words.map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join('');
  }

  /// Mengubah string menjadi url gambar yang dapat di download dari API
  String get withStorageEndpointAsPrefix {
    if(startsWith("http")) return this;
    return "${ApiService.getEndpoint()}/storage/$this";
  }

  /// Mengubah String json satu baris menjadi sebuah String dengan tampilan format JSON
  String get convertToJsonStyle {
    try {
      return JsonEncoder.withIndent("   ").convert(jsonDecode(this));
    } catch (e, s) {
      return 'Format JSON tidak valid: $e\n$s';
    }
  }

  String get removesAllQuotes {
    return replaceAll('"', '');
  }

  /// Mengubah string ke format tanggal yang enak dibaca
  String formattedDate({required BuildContext context, bool? shortDate}) {
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
        dateTime = format.parse(this);
        break;
      } catch (e, s) {
        clog('Tidak dapat memparse dengan format "${format.pattern}" pada tanggal: $this.\n$e\n$s');
        addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
        continue;
      }
    }

    if (dateTime == null) return this;
    if (shortDate != null && shortDate) {
      return DateFormat('dd/MM').format(dateTime);
    } else {
      return DateFormat(PreferenceSettingProvider.read(context).dateFormat.pattern, PreferenceSettingProvider.read(context).language.countryFormat).format(dateTime);
    }
  }

  /// Mengubah string ke format waktu yang enak dibaca
  String formattedTime() {
    try{
      DateTime dateTime = DateTime.parse(this);
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(dateTime);
    } catch (e, s){
      clog('Tidak dapat memparse format waktu: $this.\n$e\n$s');
      addLogApp(level: ListLogAppLevel.moderate.level, title: e.toString(), logs: s.toString());
      return this;
    }
  }
}
