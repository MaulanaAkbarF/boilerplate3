import 'package:flutter/material.dart';

/// Fungsi untuk mendapatkan lebar maksimal dari lebar layar perangkat pengguna
double getMediaQueryWidth(BuildContext context, {double? size}) {
  if (size != null) return MediaQuery.of(context).size.width * size;
  return MediaQuery.of(context).size.width;
}

/// Fungsi untuk mendapatkan tinggi maksimal dari tinggi layar perangkat pengguna
double getMediaQueryHeight(BuildContext context, {double? size}) {
  if (size != null) return MediaQuery.of(context).size.height * size;
  return MediaQuery.of(context).size.height;
}