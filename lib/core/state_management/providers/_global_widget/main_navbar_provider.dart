import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant_values/global_values.dart';

class MainNavbarProvider extends ChangeNotifier{
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  double _iconSize = iconBtnMid;

  PageController get pageController => _pageController;
  int get selectedIndex => _selectedIndex;
  double get iconSize => _iconSize;

  void changePageIndex(int index){
    _selectedIndex = index;
    _pageController.jumpToPage(index);

    if (index == selectedIndex){
      _iconSize = iconBtnMid;
    } else {
      _iconSize = iconBtnSmall;
    }
    notifyListeners();
  }

  /// Note: Gunakan startScreenRemoveAll untuk kembali ke halaman Navbar dari halaman lain
  static MainNavbarProvider read(BuildContext context) => context.read();
  static MainNavbarProvider watch(BuildContext context) => context.watch();
}