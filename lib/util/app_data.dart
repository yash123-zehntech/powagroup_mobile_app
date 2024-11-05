import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  int _itemCount = 0;

  int get itemCount => _itemCount;

  void setBedgeCount(int itemCount) async {
    _itemCount = itemCount;
    notifyListeners();
  }
}
