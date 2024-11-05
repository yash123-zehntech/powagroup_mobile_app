import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CommunicationViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;
  set isEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    notifyListeners();
  }

  List<String> subSectionList = [
    "Push Notification",
    "Email Notification",
    "SMS Notification",
  ];

  // on login buttion clik
  onItemClick(int index) {}
}
