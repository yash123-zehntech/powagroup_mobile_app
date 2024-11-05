import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/util/globleData.dart';

class AppBarWidget extends StatelessWidget {
  final dynamic leading;
  final String? title;
  final dynamic subtitle;
  final dynamic trailing;
  final dynamic backColor;
  final double? height;
  final Widget? backIcon;
  final Widget? actionIcon;
  final dynamic? buttom;

  const AppBarWidget(
      {this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.backColor,
      this.height,
      this.backIcon,
      this.actionIcon,
      this.buttom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: title != null && title!.isNotEmpty ? true : false,
      backgroundColor: const Color(0xffEFF1F2),
      elevation: 0,
      toolbarHeight: 90,
      title: backIcon == null
          ? Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Image.asset(
                'assets/icon/appbar_logo.png',
                fit: BoxFit.contain,
                height: 70.h,
                width: 80.w,
              ),
            )
          : title != null && title!.isNotEmpty
              ? Text(
                  title!,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff36393C),
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                  ),
                )
              : Container(),
      leading: backIcon ?? Container(),
      leadingWidth: backIcon == null ? 0 : 50,
      actions: actionIcon != null ? [actionIcon!] : [],
      bottom: buttom,
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
