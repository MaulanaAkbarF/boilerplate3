import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterRiverpod = ChangeNotifierProvider<CounterRiverpod>((ref) => CounterRiverpod());

class CounterRiverpod extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increase() {
    _counter++;
    notifyListeners();
  }
}