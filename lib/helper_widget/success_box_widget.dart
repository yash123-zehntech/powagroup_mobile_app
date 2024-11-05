import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/app.router.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked_services/stacked_services.dart';

class SuccessBoxWidget extends StatefulWidget {
  final String? success_title;
  final String? subTitle;
  final String? img;
  final int? value;
  const SuccessBoxWidget(
      {Key? key, this.success_title, this.subTitle, this.img, this.value})
      : super(key: key);

  @override
  State<SuccessBoxWidget> createState() => _SuccessBoxWidgetState();
}

class _SuccessBoxWidgetState extends State<SuccessBoxWidget> {
  final navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRect(
            child: Container(
                margin: EdgeInsets.only(left: 30.h, right: 30.h),
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    successIcon(),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      widget.success_title != null &&
                              widget.success_title!.isNotEmpty
                          ? widget.success_title.toString()
                          : '',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.44,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.h, right: 16.h),
                      child: Text(
                          widget.subTitle ?? "Oops Something Went Wrong",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff2A2A2A),
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                          )),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    const Divider(
                      color: Color(0xff2A2A2A),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 5.h,
                      ),
                      onTap: () {
                        if (widget.value == 1) {
                          navigationService.pushNamedAndRemoveUntil(
                              Routes.homePageView,
                              arguments: HomePageViewArguments(
                                  number: 0, numberforCart: 0));
                        } else {
                          navigationService.navigateTo(Routes.loginView);
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.value == 1) {
                          navigationService.pushNamedAndRemoveUntil(
                              Routes.homePageView,
                              arguments: HomePageViewArguments(
                                  number: 0, numberforCart: 0));
                        } else {
                          navigationService.navigateTo(Routes.loginView);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "OK",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 16 : 26,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.10,
                                color: Color(0xff33A3E4)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 15.h,
                      ),
                      onTap: () {
                        if (widget.value == 1) {
                          navigationService.pushNamedAndRemoveUntil(
                              Routes.homePageView,
                              arguments: HomePageViewArguments(
                                  number: 0, numberforCart: 0));
                        } else {
                          navigationService.navigateTo(Routes.loginView);
                        }
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget successIcon() => Container(
        height: 60.h,
        width: 60.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff33A3E4),
        ),
        alignment: Alignment.center,
        child: Icon(PowaGroupIcon.success,
            color: Colors.white, size: Globlas.deviceType == 'phone' ? 30 : 60),
      );
}
