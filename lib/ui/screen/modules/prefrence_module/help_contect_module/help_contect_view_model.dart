import 'package:flutter/material.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpContectViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;
  set isEnabled(bool isEnabled) {
    _isEnabled = isEnabled;
    notifyListeners();
  }

  List<String> subSectionList = [
    "About Us",
    "FAQ",
    "Online Chat",
    "Terms & Conditions",
    "Delivery Info"
  ];

  // on login buttion clik
  onItemClick(int index) {
    if (index == 0) {
      AppUtil.launchURL(Constants.ABOUT_US);
    } else if (index == 1) {
      AppUtil.launchURL(Constants.FAQ_URL);
    } else if (index == 2) {
      AppUtil.launchURL(Constants.Prod_Chat_URL);
    } else if (index == 3) {
      AppUtil.launchURL(Constants.TERMS_AND_CONDITION);
    } else if (index == 4) {
      AppUtil.launchURL(Constants.DELIVERY_INFO);
    }
  }
}
