import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

navigate(screenName, routeName, BuildContext context) {
  PersistentNavBarNavigator.pushNewScreen(context,
      screen: screenName,
      pageTransitionAnimation: PageTransitionAnimation.fade);
}
