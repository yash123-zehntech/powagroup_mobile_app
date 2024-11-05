import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';

import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/form_dropdown_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/header_contant_widget.dart';
import 'package:powagroup/helper_widget/header_sub_contant_widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/user_module/submit_request/submit_request_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class SubmitRegisterView extends StatelessWidget {
  const SubmitRegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubmitRegisterViewMode>.reactive(
        viewModelBuilder: () => SubmitRegisterViewMode(),
        builder: (context, viewModel, child) => Stack(children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icon/blur.png'),
                        fit: BoxFit.cover),
                  )),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        //viewModel.navigationService.back();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        PowaGroupIcon.arrow_back,
                        color: const Color(0xff36393C),
                        size: 25.h,
                      ),
                    ),
                    backgroundColor: const Color(0xffC6F2E7).withOpacity(0.1),
                    elevation: 0,
                  ),
                  body: ListView(
                    padding: EdgeInsets.only(left: 20.h, right: 20.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          headerContent(
                              'If your Company has an account, Request Login',
                              Globlas.deviceType == 'phone' ? 23.0 : 42.0),
                          SizedBox(
                            height: 15.h,
                          ),
                          headerSubContent(
                              "If your Company has an account/has purchased from us before, & you don't have an online login, please fill out the form below. We will then get in touch & get a login set up for you.",
                              Globlas.deviceType == 'phone' ? 14.0 : 20.0),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: AppUtil.displayWidth(context) * 0.03.h),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 2 / 3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0XFFFFFFFF),
                              borderRadius: BorderRadius.circular(15.0.r)),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 30, bottom: 30),
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    KeyboardVisibilityBuilder(
                                        builder: (context, visible) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: visible
                                                ? AppUtil.displayHeight(
                                                        context) *
                                                    0.30.h
                                                : AppUtil.displayHeight(
                                                        context) *
                                                    0.09.h),
                                        child: ListView(
                                          physics: BouncingScrollPhysics(),
                                          children: [
                                            getSubmitRequestForm(
                                                context, viewModel),
                                          ],
                                        ),
                                      );
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () {
                                            viewModel
                                                .onSubmitRequestButtonClick();
                                          },
                                          child: ButtonWidget(
                                            isBusy: viewModel.isBusy,
                                            buttonTitle: 'Submit Request',
                                            containerWidth: double.infinity,
                                            containerHeigth: 58.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ]));
  }

//return formfieds details
  Widget getSubmitRequestForm(context, SubmitRegisterViewMode viewModel) =>
      Form(
        key: viewModel.formKey,

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: formField(
                      viewModel,
                      'First Name',
                      context,
                      ' First Name',
                      PowaGroupIcon.person,
                      TextInputType.name,
                      viewModel.firstNameController,
                      Validation.fieldEmpty,
                      viewModel.isBusy,
                      false)),
              Container(
                  child: formField(
                      viewModel,
                      'Last Name',
                      context,
                      'Last Name',
                      PowaGroupIcon.person,
                      TextInputType.name,
                      viewModel.lastNameController,
                      Validation.fieldEmpty,
                      viewModel.isBusy,
                      false)),
              Container(
                  child: formField(
                      viewModel,
                      'Mobile Number',
                      context,
                      'Mobile Number',
                      PowaGroupIcon.phone,
                      TextInputType.number,
                      viewModel.mobileNumberController,
                      Validation.validMobile,
                      viewModel.isBusy,
                      true)),
              Container(
                  child: formField(
                      viewModel,
                      'Email Address',
                      context,
                      'Your email address',
                      PowaGroupIcon.email,
                      TextInputType.emailAddress,
                      viewModel.emailController,
                      Validation.emailValidate,
                      viewModel.isBusy,
                      false)),
              Container(
                  child: formField(
                      viewModel,
                      'Your Company',
                      context,
                      'Company Name',
                      PowaGroupIcon.company,
                      TextInputType.name,
                      viewModel.companyNameController,
                      Validation.fieldEmpty,
                      viewModel.isBusy,
                      false)),
              Container(child: fieldContent('Trade Type')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.dropDownTrade, viewModel.trade, 1)),
              SizedBox(
                height: 80,
              )
            ]),
        // ])
      );
}
