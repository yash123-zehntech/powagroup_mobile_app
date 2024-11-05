// return labal text
import 'package:flutter/cupertino.dart';
import 'package:powagroup/util/globleData.dart';

Widget fieldContent(text) => Text(text,
    style: TextStyle(
        color: const Color(0xff36393C),
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        fontSize: Globlas.deviceType == 'phone' ? 15 : 25));
