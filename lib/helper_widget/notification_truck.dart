import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/app.router.dart';

import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';

class NotificationTruck extends StatelessWidget {
  final navigationService = locator<NavigationService>();
  int notificationCount;
  dynamic viewModel;
  bool bottomBar;

  NotificationTruck(
      {Key? key,
      required this.notificationCount,
      required this.viewModel,
      required this.bottomBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> _counter = ValueNotifier<int>(notificationCount);

    return Stack(
      //alignment: Alignment.center,
      children: [
        Icon(PowaGroupIcon.truck_1, size: 30.h, color: Color(0xff36393C)),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: notificationCount > 0
              ? Container(
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      (notificationCount).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Globlas.deviceType == 'phone' ? 12 : 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
