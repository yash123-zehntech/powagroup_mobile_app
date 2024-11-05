import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/sitecontact_info_response.dart';
import 'package:powagroup/util/globleData.dart';

Widget dropDownforSite(
  BuildContext context,
  SiteContactInfo? siteContactInfo,
  List<SiteContactInfo> addressList,
  int i,
  dynamic viewModel,
) =>
    Column(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<SiteContactInfo>(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //value: siteContactInfo,
            hint: Text(
              "Select",
              style: TextStyle(
                  color: const Color(0xff858D93),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
            ),
            // hint: viewModel.siteContect == null
            //     ? const Padding(
            //         padding: EdgeInsets.only(left: 10),
            //         // child: Text("Select"),
            //       )
            //     : Text(
            //         viewModel.siteContect,
            //         style: TextStyle(
            //             color: const Color(0xff858D93),
            //             fontWeight: FontWeight.w400,
            //             fontFamily: 'Raleway',
            //             fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
            //       ),
            isExpanded: true,
            iconSize: 30.h,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
            items: addressList.map<DropdownMenuItem<SiteContactInfo>>(
              (val) {
                return DropdownMenuItem<SiteContactInfo>(
                  value: val,
                  child: Text(
                    val.name!,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                  ),
                );
              },
            ).toList(),
            onChanged: (val) {
              viewModel.siteContactInfo = val;
            },
            validator: (value) {
              if (viewModel.siteContect != null &&
                  viewModel.siteContect.isNotEmpty) {
                value = SiteContactInfo(
                    selected: false, name: viewModel.siteContect);
              }

              if (value == null) return "      Please select this field";
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
