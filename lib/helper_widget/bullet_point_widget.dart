import 'package:flutter/material.dart';
import 'package:powagroup/util/globleData.dart';

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("• "),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.33,
                color: const Color(0xff000000)),
          ),
        ),
      ],
    );
  }
}
