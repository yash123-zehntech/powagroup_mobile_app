import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/bottom_contant_widget.dart';

import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/checkbox_widget.dart';
import 'package:powagroup/helper_widget/form_dropdown_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/header_contant_widget.dart';
import 'package:powagroup/helper_widget/header_sub_contant_widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/user_module/register/register_view_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewMode>.reactive(
        viewModelBuilder: () => RegisterViewMode(),
        onViewModelReady: (RegisterViewMode viewModel) {},
        builder: (context, viewModel, child) {
          return Stack(children: [
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
                bottomNavigationBar: endContent(viewModel,
                    'Already have an account ?', ' Request for Login'),
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
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        headerContent('Create Account',
                            Globlas.deviceType == 'phone' ? 40.0 : 60.0),
                        const SizedBox(
                          height: 5,
                        ),
                        headerSubContent(
                            'Please Create Account to Contiune with App',
                            Globlas.deviceType == 'phone' ? 13.0 : 20.0),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppUtil.displayWidth(context) * 0.03.h),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 2 / 2.7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0XFFFFFFFF),
                            borderRadius: BorderRadius.circular(15.0.r)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 30, bottom: 30),
                          child: Stack(
                            children: [
                              KeyboardVisibilityBuilder(
                                  builder: (context, visible) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          // dynamicPadding
                                          visible
                                              ? AppUtil.displayHeight(context) *
                                                  0.35.h
                                              : AppUtil.displayHeight(context) *
                                                  0.09.h),
                                  child: ListView(
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      getRegisterForm(context, viewModel),
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
                                      viewModel.onRegisterButtonClick();
                                    },
                                    child: ButtonWidget(
                                      isBusy: viewModel.isBusy,
                                      buttonTitle: 'Submit',
                                      containerWidth: double.infinity,
                                      containerHeigth: 58.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ]);
        });
  }

//return the TextField details
  Widget getRegisterForm(context, RegisterViewMode viewModel) => Form(
        key: viewModel.formKey,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: formField(
                viewModel,
                'First Name',
                context,
                ' First Name',
                PowaGroupIcon.user_icon,
                TextInputType.name,
                viewModel.firstNameController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Last Name',
                context,
                'Last Name',
                PowaGroupIcon.user_icon,
                TextInputType.name,
                viewModel.lastNameController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
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
                true,
              )),
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
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Account First Name',
                context,
                'Name of person',
                PowaGroupIcon.user_icon,
                TextInputType.name,
                viewModel.accountNameController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Account Last Name',
                context,
                'Last Name of person',
                PowaGroupIcon.user_icon,
                TextInputType.name,
                viewModel.accountLastNameController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Account Email',
                context,
                'Enter accounts email address',
                PowaGroupIcon.email,
                TextInputType.emailAddress,
                viewModel.accountEmailController,
                Validation.emailValidate,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Account Phone Number',
                context,
                'Who do we call re accounts',
                PowaGroupIcon.phone,
                TextInputType.number,
                viewModel.phoneNumberController,
                Validation.validMobile,
                viewModel.isBusy,
                true,
              )),
              Container(
                  child: formField(
                viewModel,
                'Company Name',
                context,
                'Please use full legel name',
                PowaGroupIcon.company,
                TextInputType.name,
                viewModel.companyNameController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'ABN',
                context,
                'For new customer applications',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.abnController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'ACN',
                context,
                'If Application and have company or trust',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.acnController,
                Validation.notValidate,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: fieldContent('Trade Type select from drop down')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.dropDownTrade, viewModel.trade, 1)),
              SizedBox(
                height: 10.h,
              ),
              Container(child: fieldContent('Main Type of work')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.worksType, viewModel.workType, 4)),
              SizedBox(
                height: 10.h,
              ),
              Container(
                  child: formField(
                viewModel,
                'Business Address',
                context,
                'Street number & street name',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.businessAddController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'Post Code',
                context,
                'code',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.postCodeController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: formField(
                viewModel,
                'City',
                context,
                'City',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.cityAddController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(
                  child: fieldContent('State/Territory select from drop down')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.dropDownAct, viewModel.act, 2)),
              SizedBox(
                height: 10.h,
              ),
              Container(
                  child: formField(
                viewModel,
                'Estimated Monthly Spend',
                context,
                'e.g.\$1,000 per month',
                PowaGroupIcon.space,
                TextInputType.name,
                viewModel.monthlySpendController,
                Validation.fieldEmpty,
                viewModel.isBusy,
                false,
              )),
              Container(child: fieldContent('How did you hear about us?')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.dropDownHereAbout, viewModel.hereAbout, 5)),
              SizedBox(
                height: 10.h,
              ),
              checkbox(
                viewModel,
              ),
              SizedBox(
                height: 10.h,
              ),
              viewModel.allcheck || viewModel.isButtonClick
                  ? Text(" ")
                  : Text("     Please accept all the terms and conditions",
                      style: TextStyle(color: const Color(0xffD60505))),
              SizedBox(
                height: 15.h,
              ),
              Container(
                  child: fieldContent('Select your preferred account type')),
              Container(
                  child: dropDown(AppUtil.getContext(), viewModel,
                      viewModel.dropDownAccount, viewModel.accountType, 3)),
            ]),
        // ])
      );
}
