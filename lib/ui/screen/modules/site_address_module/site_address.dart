import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/cities_search.dart';
import 'package:powagroup/helper_widget/form_dropdown_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/site_address_module/site_address_model.dart';

import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

import '../../../../helper_widget/shimmer_loading.dart';

class SiteAddressView extends StatefulWidget {
  String? deliveryAddressId;
  SiteAddressView({Key? key, this.deliveryAddressId})
      : super(
          key: key,
        );

  @override
  State<SiteAddressView> createState() => _SiteAddressViewState();
}

class _SiteAddressViewState extends State<SiteAddressView> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom + 200;
    return ViewModelBuilder<SiteAddressViewMode>.reactive(
        viewModelBuilder: () => SiteAddressViewMode(),
        onViewModelReady: (viewModel) async {
          viewModel.deliveryAddressId = widget.deliveryAddressId;
        },
        builder: (context, viewModel, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                title: 'Add New Site Contact',
                //  addressData == null
                //     ? 'Add New Site Contact'
                //     : 'Edit New Site Contact',
                backIcon: IconButton(
                  padding: const EdgeInsets.only(left: 5),
                  icon: Icon(
                    PowaGroupIcon.arrow_back,
                    size: 24.h,
                    color: const Color(0xff36393C),
                  ),
                  onPressed: () {
                    //viewModel.navigationService.back();
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ),
            backgroundColor: const Color(0xffEFF1F2),
            body: ListView(
              padding: EdgeInsets.only(left: 10.h, right: 10.h),
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: screenHeight / 2 + 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(15.0.r)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 30,
                    ),
                    child: Stack(
                      children: [
                        ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            getAddressForm(context, viewModel),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 50.0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                // addressData.streetNameNumber;

                                // if (addressData == null) {
                                //   viewModel.onSubmitButtonClick(
                                //       false, null, context);
                                // } else {
                                //   viewModel.onSubmitButtonClick(
                                //       true, addressData!, context);
                                // }
                                viewModel.onSubmitButtonClick(context);
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
              ],
            )));
  }

//return bottom sheet contant
  Widget starContent(context, text) => Row(
        children: [
          RichText(
            text: TextSpan(
                text: text,
                style: TextStyle(
                  color: Color(0xff36393C),
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w500,
                  fontSize: Globlas.deviceType == 'phone' ? 15 : 25,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Globlas.deviceType == 'phone' ? 15 : 25,
                        fontFamily: 'Raleway',
                        color: const Color(0xFFD60505)),
                  )
                ]),
          ),
        ],
      );

  //return TextInput fields
  Widget formField(labelText, context, hintText, keyboardType, controller,
          validationfield, int star, number) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          star == 1
              ? starContent(context, labelText)
              : Container(child: fieldContent(labelText)),
          number
              ? TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 10,
                  textInputAction: TextInputAction.next,
                  // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  keyboardType: keyboardType,
                  controller: controller,
                  validator: (value) => validationfield(value),
                  style: TextStyle(
                      color: const Color(0xff1B1D1E),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Globlas.deviceType == 'phone' ? 10 : 20,
                          vertical: Globlas.deviceType == 'phone' ? 12 : 15),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color(0xFFD60505),
                      )),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: TextStyle(
                          color: const Color(0xff858D93),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                      hintText: hintText,
                      counterText: " "),
                  onSaved: (value) => controller = value,
                )
              : TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  keyboardType: keyboardType,
                  controller: controller,
                  validator: (value) => validationfield(value),
                  style: TextStyle(
                      color: const Color(0xff1B1D1E),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.33,
                      fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Globlas.deviceType == 'phone' ? 10 : 20,
                        vertical: Globlas.deviceType == 'phone' ? 12 : 15),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFFD60505),
                    )),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintStyle: TextStyle(
                        color: const Color(0xff858D93),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Raleway',
                        fontSize: Globlas.deviceType == 'phone' ? 15 : 25),
                    hintText: hintText,
                  ),
                  onSaved: (value) => controller = value,
                ),
          SizedBox(
            height: 20.h,
          ),
        ],
      );

//return the TextField details
  Widget getAddressForm(context, SiteAddressViewMode viewModel) {
    // if (viewModel.stateValue != null && viewModel.stateValue.isNotEmpty) {
    //   viewModel.getCity();
    // }
    return Form(
      key: viewModel.formKeyForSiteContact,

      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: formField(
              'First Name',
              context,
              'Enter first name',
              TextInputType.name,
              viewModel.firstNameController,
              Validation.fieldEmpty,
              2,
              false,
            )),
            Container(
                child: formField(
              'Last Name',
              context,
              'Enter last name',
              TextInputType.name,
              viewModel.lastNameController,
              Validation.notValidate,
              2,
              false,
            )),
            Container(
                child: formField(
              'Mobile',
              context,
              'Enter mobile',
              TextInputType.number,
              viewModel.mobileNumberController,
              Validation.fieldEmpty,
              2,
              false,
            )),
            Container(
                child: formField(
                    'Email',
                    context,
                    'Enter email address',
                    TextInputType.emailAddress,
                    viewModel.emailController,
                    Validation.notValidate,
                    2,
                    false)),

            // SizedBox(
            //   height: 10.h,
            // ),
            // SizedBox(
            //   height: 75.h,
            // ),
          ]),

      // ])
    );
  }
}
