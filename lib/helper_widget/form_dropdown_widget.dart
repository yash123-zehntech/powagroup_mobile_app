import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
//return dropdownButtton with functionallity
Widget dropDown(BuildContext context, viewModel, type, list, int value) =>
    Column(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            hint: value == 1
                ? viewModel.dropDownTrade == null
                    ? const Padding(
                        padding: EdgeInsets.only(left: 10),
                      )
                    : Text(
                        viewModel.dropDownTrade,
                        style: TextStyle(
                            color: const Color(0xff858D93),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Raleway',
                            fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                      )
                : value == 2
                    ? viewModel.dropDownAct == null
                        ? const Padding(
                            padding: EdgeInsets.only(left: 10),
                          )
                        : Text(
                            viewModel.dropDownAct,
                            style: TextStyle(
                                color: const Color(0xff858D93),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Raleway',
                                fontSize:
                                    Globlas.deviceType == 'phone' ? 15 : 25),
                          )
                    : value == 3
                        ? viewModel.dropDownAccount == null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 10),
                              )
                            : Text(
                                viewModel.dropDownAccount,
                                style: TextStyle(
                                    color: const Color(0xff858D93),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Raleway',
                                    fontSize: Globlas.deviceType == 'phone'
                                        ? 15
                                        : 25),
                              )
                        : value == 4
                            ? viewModel.worksType == null
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                  )
                                : Text(
                                    viewModel.worksType,
                                    style: TextStyle(
                                        color: const Color(0xff858D93),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Raleway',
                                        fontSize: Globlas.deviceType == 'phone'
                                            ? 15
                                            : 25),
                                  )
                            : value == 5
                                ? viewModel.dropDownHereAbout == null
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                      )
                                    : Text(
                                        viewModel.dropDownHereAbout,
                                        style: TextStyle(
                                            color: const Color(0xff858D93),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Raleway',
                                            fontSize:
                                                Globlas.deviceType == 'phone'
                                                    ? 15
                                                    : 25),
                                      )
                                : Container(),
            isExpanded: true,
            iconSize: 30.h,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
            items: list.map<DropdownMenuItem<String>>(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val,
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
              value == 1
                  ? viewModel.dropDownTrade = val!
                  : value == 2
                      ? viewModel.dropDownAct = val!
                      : value == 3
                          ? viewModel.dropDownAccount = val!
                          : value == 5
                              ? viewModel.dropDownHereAbout = val!
                              : Container();

              viewModel.notifyListeners();
            },
            onTap: () {},
            validator: (value) {
              if (value == null) return "      Please select this field";
              return null;
            },
          ),
        ),
        // Container(
        //   height: 1.h,
        //   width: double.infinity,
        //   color: Colors.grey,
        // ),
        const SizedBox(
          height: 10,
        )
      ],
    );

Widget dropDownForPlace(viewModel, list, int valueData) {
  return Column(
    children: [
      DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          hint: valueData == 1
              ? Text(
                  viewModel.stateValue != null &&
                          viewModel.stateValue.isNotEmpty
                      ? viewModel.getStateValue(viewModel.stateValue)
                      : '  Select',
                  style: viewModel.stateValue != null &&
                          viewModel.stateValue.isNotEmpty
                      ? TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == 'phone' ? 14 : 24)
                      : TextStyle(
                          color: const Color(0xff858D93),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                )
              : valueData == 2
                  ? Text(
                      viewModel.cityValue != null &&
                              viewModel.cityValue.isNotEmpty
                          ? viewModel.cityValue
                          : '  Select',
                      style: viewModel.cityValue != null &&
                              viewModel.cityValue.isNotEmpty
                          ? TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == 'phone' ? 14 : 24)
                          : TextStyle(
                              color: const Color(0xff858D93),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Raleway',
                              fontSize:
                                  Globlas.deviceType == 'phone' ? 15 : 25),
                    )
                  : Text(
                      viewModel.addressTypeValue != null &&
                              viewModel.addressTypeValue.isNotEmpty
                          ? viewModel.addressTypeValue
                          : '  Select',
                      style: viewModel.addressTypeValue != null &&
                              viewModel.addressTypeValue.isNotEmpty
                          ? TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == 'phone' ? 14 : 24)
                          : TextStyle(
                              color: const Color(0xff858D93),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Raleway',
                              fontSize:
                                  Globlas.deviceType == 'phone' ? 15 : 25),
                    ),
          isExpanded: true,
          iconSize: 30.h,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
          items: list.map<DropdownMenuItem<String>>(
            (val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                ),
              );
            },
          ).toList(),
          onChanged: (val) async {
            if (valueData == 1) {
              viewModel.stateValue = val!;
              List<String?> cityList =
                  await AppUtil.getCities(viewModel.stateValue);
              viewModel.cityList = cityList;
            } else if (valueData == 2) {
              viewModel.cityValue = val!;
            } else if (valueData == 3) {
              viewModel.addressTypeValue = val;
            }
          },
          validator: (value) {
            if (valueData == 1) {
              if (viewModel.stateValue != null &&
                  viewModel.stateValue.isNotEmpty) {
                value = viewModel.stateValue;
              }
            } else if (valueData == 2) {
              if (viewModel.cityValue != null &&
                  viewModel.cityValue.isNotEmpty) {
                value = viewModel.cityValue;
              }
            } else if (valueData == 3) {
              if (viewModel.addressTypeValue != null &&
                  viewModel.addressTypeValue.isNotEmpty) {
                value = viewModel.addressTypeValue;
              }
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
}
