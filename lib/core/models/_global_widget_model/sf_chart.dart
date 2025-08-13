import 'package:flutter/material.dart';

class SfBarChart{
  final String x;
  final double y;

  SfBarChart({
    required this.x,
    required this.y,
  });
}

class SfLineChart{
  final DateTime? xDate;
  final String? xString;
  final double y;

  SfLineChart({
    this.xDate,
    this.xString,
    required this.y,
  });
}

class SfCircularsChart{
  final String x;
  final double y;
  final Color? color;

  SfCircularsChart({
    required this.x,
    required this.y,
    this.color,
  });
}