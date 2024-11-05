import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/appbar_widget.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/cities_search.dart';
import 'package:powagroup/helper_widget/form_dropdown_widget.dart';
import 'package:powagroup/helper_widget/form_textfield.widget.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/ui/screen/modules/address_module/address_view_model.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/address_response.dart';
import 'package:powagroup/ui/screen/modules/address_module/response_model/cities_respose.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

import '../../../../helper_widget/shimmer_loading.dart';

class AddressView extends StatelessWidget {
  AddressData? addressData;
  AddressView({Key? key, this.addressData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight =
        MediaQuery.of(context).viewInsets.bottom + 200;
    return ViewModelBuilder<AddressViewMode>.reactive(
        viewModelBuilder: () => AddressViewMode(),
        onViewModelReady: (viewModel) async {
          if (addressData != null) {
            viewModel.setControllerValue(addressData!);
          }
          viewModel.countryController.text = 'Australia';
          List<String?> stateList = await AppUtil.getStates();

          // if (stateList != null && stateList.isNotEmpty) {
          //   viewModel.stateList = stateList;
          // }
        },
        builder: (context, viewModel, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                title: addressData == null
                    ? 'Add Your Address'
                    : 'Edit Your Address',
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
                  height: screenHeight - keyboardHeight,
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
                            bottom: 10.0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                if (addressData == null) {
                                  viewModel.onSubmitButtonClick(
                                      false, null, context);
                                } else {
                                  viewModel.onSubmitButtonClick(
                                      true, addressData!, context);
                                }
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
  Widget getAddressForm(context, AddressViewMode viewModel) {
    // if (viewModel.stateValue != null && viewModel.stateValue.isNotEmpty) {
    //   viewModel.getCity();
    // }
    return Form(
      key: viewModel.formKey,

      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: formField(
              'Address Name',
              context,
              'Enter Address',
              TextInputType.name,
              viewModel.addressNameController,
              Validation.fieldEmpty,
              1,
              false,
            )),
            // Container(
            //     child: formField(
            //         'Email Address',
            //         context,
            //         'Enter Address',
            //         TextInputType.emailAddress,
            //         viewModel.emailController,
            //         Validation.notValidate,
            //         1,
            //         false)),
            // Container(
            //     child: formField(
            //         'Mobile Number',
            //         context,
            //         'Mobile Number',
            //         TextInputType.number,
            //         viewModel.mobileNumberController,
            //         Validation.notValidate,
            //         2,
            //         true)),
            Container(
              child: citiesSearch(viewModel.citiesList, viewModel),

              // formField(
              //     'Street Name & Number',
              //     context,
              //     ' ',
              //     TextInputType.name,
              //     viewModel.streetNameNumberController,
              //     Validation.fieldEmpty,
              //     2,
              //     false)
            ),
            viewModel.checkforCities
                ? ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 225, 225),
                          borderRadius: BorderRadius.circular(1)),
                    ))
                : viewModel.citiesList.isEmpty ||
                        viewModel.citiesList == null ||
                        viewModel.isTapping
                    ? Container()
                    : viewModel.citiesList.isNotEmpty &&
                            !viewModel.isContinerTapping
                        ? InkWell(
                            onTap: () {
                              // viewModel.notifyListeners();
                            },
                            child: Container(
                              height: 100.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(4),
                                ),
                                border: Border.all(
                                  width: 1.0, // Border width
                                  color: Color.fromARGB(
                                      255, 225, 225, 225), // Border color
                                ),
                              ),
                              child: ListView.separated(
                                itemCount: viewModel.citiesList.length,
                                separatorBuilder: (BuildContext context,
                                        int index) =>
                                    Divider(), // Add a separator between list items
                                itemBuilder: (BuildContext context, int index) {
                                  CitiesData choice =
                                      viewModel.citiesList[index];

                                  return ListTile(
                                    title: Text(choice.name.toString()),
                                    onTap: () {
                                      viewModel.streetNameNumberController
                                          .text = choice.name!;
                                      viewModel.stateNameController.text =
                                          choice.stateName!;

                                      viewModel.cityController.text =
                                          choice.zip;

                                      viewModel.cityValue = " ";
                                      viewModel.listOfState.clear();
                                      viewModel.listOfCity.clear();
                                      viewModel.listOfState
                                          .add(choice.stateName);
                                      viewModel.listOfCity.add(choice.city);
                                      viewModel.isContinerTapping = true;
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),
            SizedBox(
              height: 20.h,
            ),

            // child: citiesSearch(viewModel.citiesList, viewModel)),

            Container(
                child: formField(
                    'Street and Number',
                    context,
                    '',
                    TextInputType.name,
                    viewModel.streetNameController,
                    Validation.fieldEmpty,
                    2,
                    false)),
            // Container(
            //     child: formField(
            //         'Code',
            //         context,
            //         '',
            //         TextInputType.name,
            //         viewModel.codeController,
            //         Validation.fieldEmpty,
            //         1,
            //         false)),
            Container(
                child: formField(
                    'Country',
                    context,
                    'Australia',
                    TextInputType.name,
                    viewModel.countryController,
                    Validation.fieldEmpty,
                    1,
                    false)),

            Container(child: starContent(context, 'State Name')),
            // SizedBox(
            //   height: 10.h,
            // ),
            Container(
                child: formField(
                    '',
                    context,
                    viewModel.stateValue ?? ' ',
                    TextInputType.name,
                    viewModel.stateNameController,
                    Validation.fieldEmpty,
                    2,
                    false)),
            // Container(
            //     child: dropDownForPlace(viewModel, viewModel.listOfState, 1)),

            Container(child: starContent(context, 'Postcode')),

            Container(
                child: formField(
                    '',
                    context,
                    viewModel.cityValue ?? ' ',
                    TextInputType.name,
                    viewModel.cityController,
                    Validation.fieldEmpty,
                    2,
                    false)),
            // Container(
            //     child: dropDownForPlace(viewModel, viewModel.listOfCity, 2)),
            // Container(
            //     child: formField('City Post', context, '', TextInputType.name,
            //         viewModel.cityController, Validation.fieldEmpty, 1)),
            SizedBox(
              height: 10.h,
            ),
            // Container(
            //     child: formField(
            //         'Site Contact Phone Number',
            //         context,
            //         'Phone Number',
            //         TextInputType.phone,
            //         viewModel.contectNumberController,
            //         Validation.validMobile,
            //         2,
            //         true)),

            // Container(child: starContent(context, 'Address Type')),
            // SizedBox(
            //   height: 10.h,
            // ),
            // Container(
            //     child: dropDownForPlace(viewModel, viewModel.addressType, 3)),
            SizedBox(
              height: 75.h,
            ),
          ]),

      // ])
    );
  }
}
