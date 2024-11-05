import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/globleData.dart';

//return end contant
Widget endContent(viewModel, text1, text2) => Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  text: text1,
                  style: TextStyle(
                      color: const Color(0xff1B1D1E),
                      fontSize: Globlas.deviceType == 'phone' ? 17 : 30,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                      // text2 == ' Create Account' ?

                      text: text2,
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => text2 == ' Create Account'
                            ? viewModel.onCreateAccountClick()
                            : text2 == ' Request for Login'
                                ? viewModel.onRequestForLoginClick()
                                : () => Container(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Globlas.deviceType == 'phone' ? 17 : 27,
                          fontFamily: 'Raleway',
                          color: const Color(0xFFD60505)),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );

// Login request widget

Widget loginRequestWidget(viewModel, text1, text2) => Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  text: text1,
                  style: TextStyle(
                      color: const Color(0xff1B1D1E),
                      fontSize: Globlas.deviceType == 'phone' ? 11.sp : 12.sp,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                      // text2 == ' Create Account' ?

                      text: text2,
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () => viewModel.onRequestForLoginClick(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:
                              Globlas.deviceType == 'phone' ? 11.sp : 12.sp,
                          fontFamily: 'Raleway',
                          color: const Color(0xFFD60505)),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
