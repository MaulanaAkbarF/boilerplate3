import 'package:flutter/material.dart';

class BottomNavbarModel{
  final Widget page;
  final String title;
  final String? route;
  final IconData iconData;

  BottomNavbarModel({
    required this.page,
    required this.title,
    this.route,
    required this.iconData,
  });
}