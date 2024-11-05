import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/ui/screen/modules/search_module/search_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked_services/stacked_services.dart';

// ignore: must_be_immutable
class NetworkError extends StatelessWidget {
  final navigationService = locator<NavigationService>();
  String? icon;
  String? content;
  String? subContant;
  dynamic viewModel;

  NetworkError(
      {Key? key, this.icon, this.content, this.subContant, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(
              flex: 1,
            ),
            Image.asset(icon!),
            const Spacer(
              flex: 1,
            ),
            Text(
              content!,
              style: TextStyle(
                  color: const Color(0xff1B1D1E),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Raleway',
                  letterSpacing: -0.33,
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              subContant!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xff36393C),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  letterSpacing: -0.33,
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
            ),
            const Spacer(
              flex: 2,
            )
          ]),
    );
  }
}
