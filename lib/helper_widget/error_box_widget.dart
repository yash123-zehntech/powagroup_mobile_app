import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:stacked_services/stacked_services.dart';

class ErrorBoxWidget extends StatefulWidget {
  final String? title;
  final String? img;
  const ErrorBoxWidget({Key? key, this.title, this.img}) : super(key: key);

  @override
  State<ErrorBoxWidget> createState() => _ErrorBoxWidgetState();
}

class _ErrorBoxWidgetState extends State<ErrorBoxWidget> {
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
          InkWell(
            child: ClipRect(
              child: Container(
                  margin: EdgeInsets.only(left: 30.h, right: 30.h),
                  padding: EdgeInsets.only(left: 16, right: 16),
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
                      widget.img == null
                          ? Image.asset(
                              'assets/icon/alert.png',
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              widget.img.toString(),
                              fit: BoxFit.fill,
                            ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        "ERROR",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.44,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(widget.title ?? "Oops Something Went Wrong",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xff2A2A2A),
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w500,
                            fontSize: Globlas.deviceType == "phone" ? 13 : 23,
                          )),
                      SizedBox(
                        height: 12.h,
                      ),
                      const Divider(
                        color: Color(0xff2A2A2A),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      InkWell(
                        child: Text(
                          "OK",
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.10,
                              color: const Color(0xFFD60505)),
                        ),
                        onTap: () {
                          //navigationService.back();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  )),
            ),
            onTap: () {
              //navigationService.back();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}