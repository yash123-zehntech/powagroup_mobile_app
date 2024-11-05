import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';

import '../util/globleData.dart';

Widget doubleIcon() => Stack(
      children: [
        // Positioned(
        //   // top: 6,
        //   // right: 18,
        //   // child: Icon(
        //   //   // PowaGroupIcon.arrow_forword,
        //   //   PowaGroupIcon.arrow_forword,
        //   //   size: 10.h,
        //   //   color: const Color(0xFFD60505),
        //   // ),
        // ),
        Positioned(
          // left: 2,
          child: Icon(PowaGroupIcon.arrow_with_half_circle,
              size: 22.h,
              // color: const Color(0xFFD60505),
              color: const Color(0xffD60505).withOpacity(0.11)),
        ),
        Positioned(
          top: Globlas.deviceType == "phone" ? 5 : 8,
          right: Globlas.deviceType == "phone" ? 16 : 28,
          child: Icon(
            // PowaGroupIcon.arrow_forword,
            PowaGroupIcon.arrow_forword,
            size: Globlas.deviceType == "phone" ? 10 : 18,
            color: const Color(0xFFD60505),
          ),
        ),
      ],
    );
