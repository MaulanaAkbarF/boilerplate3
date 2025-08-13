import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FcmNotificationProvider extends ChangeNotifier{
  int _unread = 0;
  
  int get unread => _unread;

  void addAllUnread(int data) {
    log ('Total Unread Notifikasi: $data');
    _unread = data;
    notifyListeners();
  }

  void addSingleUnread(int data){
    _unread = _unread + data;
    notifyListeners();
  }

  void removeSingleUnread(){
    log ('Unread Notifikasi Exist: $_unread');
    if (_unread >= 1){
      _unread = _unread - 1;
      notifyListeners();
    }
  }

  void removeAllUnread(){
    _unread = 0;
    notifyListeners();
  }

  static FcmNotificationProvider read(BuildContext context) => context.read();
  static FcmNotificationProvider watch(BuildContext context) => context.watch();
}