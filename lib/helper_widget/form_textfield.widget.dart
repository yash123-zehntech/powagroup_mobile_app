import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/util/globleData.dart';

//return TextInput fields
Widget formField(
  viewModel,
  labelText,
  context,
  hintText,
  icon,
  keyboardType,
  controller,
  validationfield,
  isBusy,
  number,
) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(child: fieldContent(labelText)),
        number
            ? TextFormField(
                cursorColor: Color(0xffD60505),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                keyboardType: keyboardType,
                controller: controller,
                validator: (value) => validationfield(value),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  // errorText: validationfield ? 'This field is required.' : null,
                  enabled: isBusy ? false : true,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Globlas.deviceType == 'phone' ? 10 : 15,
                      vertical: Globlas.deviceType == 'phone' ? 12 : 15),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFD60505),
                  )),
                  // enabledBorder: const UnderlineInputBorder(
                  //   borderSide: BorderSide(
                  //     color: Colors.black,
                  //   ),
                  // ),
                  hintStyle: TextStyle(
                      color: const Color(0xff858D93),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                  hintText: hintText,
                  counterText: "",
                  suffixIcon: IconButton(
                      icon: Icon(
                        icon,
                        size: Globlas.deviceType == 'phone' ? 20 : 35,
                      ),
                      onPressed: () {
                        !viewModel.passwordVisible
                            ? PowaGroupIcon.password_icon
                            : Icons.visibility_off_outlined;
                        viewModel.passwordVisible = !viewModel.passwordVisible;
                      }),
                ),
                onSaved: (value) => controller = value,
              )
            : TextFormField(
                cursorColor: Color(0xffD60505),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                keyboardType: keyboardType,
                controller: controller,
                validator: (value) => validationfield(value),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                decoration: InputDecoration(
                  isDense: true,
                  enabled: isBusy ? false : true,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Globlas.deviceType == 'phone' ? 10 : 15,
                      vertical: Globlas.deviceType == 'phone' ? 12 : 15),

                  hintStyle: TextStyle(
                      color: const Color(0xff858D93),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                  hintText: hintText,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color(0xFFD60505),
                  )),
                  // enabledBorder: const UnderlineInputBorder(
                  //     borderSide: BorderSide(
                  //   color: Color(0xFF000000),
                  // )),

                  // suffixIcon:
                  //     Icon(icon, size: Globlas.deviceType == 'phone' ? 20 : 45),

                  suffixIcon: IconButton(
                      icon: Icon(
                        icon,
                        size: Globlas.deviceType == 'phone' ? 20 : 30,
                      ),
                      onPressed: () {
                        !viewModel.passwordVisible
                            ? PowaGroupIcon.password_icon
                            : Icons.visibility_off_outlined;

                        viewModel.passwordVisible = !viewModel.passwordVisible;
                      }),
                ),
                onSaved: (value) => controller = value,
              ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
