import 'package:flutter/material.dart';

class NavigatorProvider extends ChangeNotifier{
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static NavigatorState? get navigatorState => navigatorKey.currentState;
}