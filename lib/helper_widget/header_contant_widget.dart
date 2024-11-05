import 'package:flutter/material.dart';
import 'package:powagroup/util/globleData.dart';

//return login contant
Widget headerContent(text, fontsize) => Container(
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Raleway-ExtraBold',
              fontWeight: FontWeight.w800,
              fontSize: fontsize)),
    );
