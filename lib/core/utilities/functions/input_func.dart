import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

final decimalPattern = intl.NumberFormat.decimalPattern();

/// Fungsi untuk menampilkan data harga dalam bentuk format harga
String inputPriceWithFormat(String? unit, String value) {
  String numericValue = value.replaceAll(RegExp(r'[^\d]'), '');

  if (numericValue.length > 12) {
    numericValue = numericValue.substring(0, 12);
  }

  int number = int.parse(numericValue);
  String formatted = intl.NumberFormat('#,###', 'id_ID').format(number);
  if (unit != null){
    return '$unit $formatted';
  } else {
    return formatted;
  }
}

/// Fungsi untuk membatasi input desimal pada TextField (pada kode di bawah ini maksimal input diizinkan adalah 2)
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!_isValidInput(newValue.text)) return oldValue;

    if (newValue.text.contains('.')) {
      var parts = newValue.text.split('.');
      if (parts.length > 2) return oldValue;
      if (parts[1].length > decimalRange) return oldValue;
    }

    return newValue;
  }

  bool _isValidInput(String value) {
    return RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(value);
  }
}

String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(length, (index) => chars[Random.secure().nextInt(chars.length)]).join();
}

int generateRandomInt(int min, int max) {
  return min + Random.secure().nextInt(max - min + 1);
}

double generateRandomFloat(double min, double max) {
  return min + Random.secure().nextDouble() * (max - min);
}

T? getOneRandomValue<T>(List<T> listData) {
  if (listData.isNotEmpty) return listData[Random().nextInt(listData.length)];
  return null;
}

String getOneRandomString(List<String> listString) {
  if (listString.isNotEmpty) return listString[Random().nextInt(listString.length)];
  return 'List Kosong!';
}

int getOneRandomInt(List<int> listInteger) {
  if (listInteger.isNotEmpty) return listInteger[Random().nextInt(listInteger.length)];
  return 0;
}

double getOneRandomDouble(List<double> listDouble) {
  if (listDouble.isNotEmpty) return listDouble[Random().nextInt(listDouble.length)];
  return 0.0;
}