//return login sub contant
  import 'package:flutter/cupertino.dart';
import 'package:powagroup/util/globleData.dart';

Widget headerSubContent(text, fontsize) => Container(
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xff2A2A2A),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                fontSize: fontsize)),
      );