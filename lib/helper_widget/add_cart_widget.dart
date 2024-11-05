import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/util/globleData.dart';

class AddTruckWidget extends StatelessWidget {
  String? screenName;
  AddTruckWidget({Key? key, this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(6.sp),
        // width: 100.w,
        // height: 28.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xffD60505).withOpacity(0.11),
            borderRadius: BorderRadius.circular(6.r)),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                PowaGroupIcon.truck,
                size: 12.h,
                color: const Color(0xffD60505),
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                'Add To Truck',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 10 : 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.33,
                    color: const Color(0xffD60505)),
              ),
            ]));
  }
}
