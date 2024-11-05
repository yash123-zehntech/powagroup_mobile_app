import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/util/globleData.dart';

//return TextInput fields
Widget formFieldUserProfile(
  viewModel,
  labelText,
  context,
  icon,
  controller,
  isBusy,
) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style: TextStyle(
                color: const Color(0xff36393C),
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: Globlas.deviceType == 'phone' ? 15 : 25)),
        !viewModel.isBusy
            ? TextFormField(
                maxLines: 2,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                controller: controller,
                readOnly: true,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                decoration: InputDecoration(
                  enabled: isBusy ? false : true,
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.only(left: 12, right: 12),
                      icon: Icon(
                        icon,
                        size: Globlas.deviceType == 'phone' ? 24 : 35,
                      ),
                      onPressed: () {}),
                ),
              )
            : ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                )),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
