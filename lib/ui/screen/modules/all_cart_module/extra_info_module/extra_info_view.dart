import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powagroup/helper_widget/labal_field_contant_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/extra_info_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/warehouses_response_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:powagroup/util/validator.dart';
import 'package:stacked/stacked.dart';

class ExtraInfoView extends StatefulWidget {
  String? deliveryAddressId;
  ExtraInfoView({Key? key, this.deliveryAddressId}) : super(key: key);

  @override
  State<ExtraInfoView> createState() => _ExtraInfoViewState();
}

class _ExtraInfoViewState extends State<ExtraInfoView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExtraViewModel>.reactive(
        viewModelBuilder: () => ExtraViewModel(),
        onViewModelReady: (viewModel) async {
          viewModel.getSavedExtraInformation();
          List<ProductData> cartProductList = await AppUtil.getCartList();

          if (cartProductList != null && cartProductList.isNotEmpty) {
            try {
              viewModel.cartProductList = cartProductList;
            } catch (e) {}
          }
          if (viewModel.deliveryAddressId != null &&
              viewModel.deliveryAddressId!.isNotEmpty) {
            viewModel.deliveryAddressId = widget.deliveryAddressId;
          }
          viewModel.addressList = await AppUtil.getDeliveryList();

          await viewModel.getSiteContect(viewModel.addressList);
          await viewModel.getWarehousesListItems();
          //await viewModel.getItemDeliveryCharges();
          await viewModel.getOrderTotal();
          viewModel.isPickupValue();
          viewModel.getPickUpType();
        },
        builder: (context, viewModel, child) => Scaffold(
            backgroundColor: Color(0xffEFF1F2),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFFFFFFFF),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft: Radius.circular(20.r),
                        ),
                      ),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 30, bottom: 30),
                        shrinkWrap: true, // <- added
                        primary: false, // <- added
                        children: [getAddressForm(context, viewModel)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: viewModel.commentSectionPriceWidget1(
                        "",
                        viewModel,
                        'Next',
                        'ExtraInfoView',
                        viewModel.showLoaderForOrderTotal != null &&
                                viewModel.showLoaderForOrderTotal
                            ? ''
                            : '\$${(viewModel.getOrderTotalsResponse!.itemTotalEx! + viewModel.getOrderTotalsResponse!.deliveryEx! + viewModel.getOrderTotalsResponse!.totalTax!).toStringAsFixed(2)}',
                        context),
                  ),
                ],
              ),
            )));
  }

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
          validationfield, int star) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          star == 1
              ? starContent(context, labelText)
              : Container(child: fieldContent(labelText)),
          TextFormField(
            cursorColor: Color(0xFFD60505),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            keyboardType: keyboardType,
            controller: controller,
            validator: (value) =>
                validationfield != null ? validationfield(value) : null,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'Raleway',
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
  Widget getAddressForm(context, ExtraViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(child: starContent(context, 'Site Contact')),
                viewModel.showAddNewcontact
                    ? InkWell(
                        onTap: () {
                          if (!viewModel.checkforSiteContacts) {
                            viewModel.onAddNewSiteContactAddressClick(context);
                          }
                        },
                        child: Container(
                          //margin: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: const Color(0xff33A3E4),
                                size: 15,
                              ),
                              Text("Add New Site Contact",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 13 : 22,
                                    color: const Color(0xff33A3E4),
                                  )),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            // viewModel.siteContect != null
            //     ?
            viewModel.checkforSiteContacts
                // || viewModel.information == null
                // &&
                //         viewModel.sitecontactList.length != 0
                ?
                // AppUtil.showSnackBar('Site contact is empty.')
                ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 225, 225),
                          borderRadius: BorderRadius.circular(1)),
                    ))
                // Container(
                //     child: dropDownforSite(
                //     AppUtil.getContext(),
                //     viewModel.siteContactInfo,
                //     viewModel.sitecontactList,
                //     1,

                //     viewModel,
                //   ))

                : dropDownButtonForSite(
                    viewModel,
                  ),
            // : Container(),

            // Container(
            //     child: dropDownForSiteContect(viewModel,
            //         viewModel.dropDownTrade, viewModel.addressList, 1)),
            SizedBox(
              height: 15.h,
            ),
            Container(
                child: starContent(context, 'Preferred Dispatch Warehouse')),

            viewModel.checkforWarehouse
                // || viewModel.information == null
                // &&
                //         viewModel.sitecontactList.length != 0
                ?
                // AppUtil.showSnackBar('Site contact is empty.')
                ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 225, 225),
                          borderRadius: BorderRadius.circular(1)),
                    ))
                // Container(
                //     child: dropDownforSite(
                //     AppUtil.getContext(),
                //     viewModel.siteContactInfo,
                //     viewModel.sitecontactList,
                //     1,
                //     viewModel,
                //   ))

                : dropDownButtonForWarehouse(viewModel),
            SizedBox(
              height: 15.h,
            ),
            Container(
                child: formField(
                    'Reference/ Po Number',
                    context,
                    'Requires',
                    TextInputType.name,
                    viewModel.refernceController,
                    Validation.fieldEmpty,
                    2)),
            Container(
                child: formField(
                    'Delivery Notes',
                    context,
                    ' ',
                    TextInputType.name,
                    viewModel.notesController,
                    null,
                    //Validation.fieldEmpty,
                    2)),
            purchessContent('Official Purchase Order'),
            SizedBox(height: 20),
            Row(
              children: [
                CupertinoButton(
                  color: const Color(0xffD60505),
                  onPressed: () {
                    viewModel.chooseFile = 1;
                    _show(context, viewModel);
                  },
                  child: Text('Choose File',
                      style: TextStyle(
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontSize: Globlas.deviceType == 'phone' ? 12 : 23,
                        fontFamily: 'Raleway',
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Text(
                    'No File Chosen',
                    style: TextStyle(
                      color: const Color(0xff858D93),
                      fontWeight: FontWeight.w400,
                      fontSize: Globlas.deviceType == 'phone' ? 11 : 23,
                      fontFamily: 'Raleway',
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),
            viewModel.imageFile == null || viewModel.imageFile!.isEmpty
                ? Container()
                : Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(viewModel.imageFile!))

                            // image: MemoryImage(viewModel.imageData, scale: 0.5)
                            )),
                    // backgroundImage: new FileImage(
                    //     File(viewModel.information.imagePath!)),
                  ),

            // SizedBox(
            //   height: 20.h,
            // ),
            // InkWell(
            //   onTap: () {
            //     // viewModel.onLoginButtonClick();
            //     viewModel.onSubmitButtonClick(context);
            //   },
            //   child: ButtonWidget(
            //     isBusy: viewModel.isBusy,
            //     buttonTitle: 'Submit',
            //     containerWidth: double.infinity,
            //     containerHeigth: 58.h,
            //   ),
            // ),
            // SizedBox(
            //   height: 10.h,
            // )
            // Container(
            //     child: formField('Zip Code', context, '', TextInputType.name,
            //         viewModel.codeController, Validation.fieldEmpty, 1)),
            // Container(
            //     child: formField('Country', context, '', TextInputType.name,
            //         viewModel.countryController, Validation.fieldEmpty, 1)),
            // Container(child: starContent(context, 'State/Provice')),
            // SizedBox(
            //   height: 10.h,
            // ),
            // Container(
            //     child: dropDown(AppUtil.getContext(), viewModel,
            //         viewModel.dropDownAct, viewModel.act, 2)),
          ]),
    );
  }
}

void _close(BuildContext context, viewModel) {
  viewModel.navigationService.back();
  // Navigator.pop(context);
}

Widget dropDownButtonForSite(ExtraViewModel viewModel) {
  return DropdownButtonHideUnderline(
    child: DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) => value == null ? 'Please select this field' : null,
      // viewModel.userName == null ? 'Please select this field' : null,
      value: viewModel.siteContactInfo,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),
      elevation: 16,
      isExpanded: true,
      iconSize: 30.h,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
      hint: Text(
          // viewModel.userName!,
          'Select',
          style: TextStyle(
              color: const Color(0xff858D93),
              fontWeight: FontWeight.w400,
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == 'phone' ? 15 : 25)),
      onChanged: (String? siteContactInfo) {
        // viewModel.siteContactInfo = siteContactInfo;
        viewModel.siteContactInfo = siteContactInfo;
      },
      items: viewModel.sitecontactList.map((item) {
        return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
            ));
      }).toList(),
    ),
  );
}

Widget dropDownButtonForWarehouse(ExtraViewModel viewModel) {
  return DropdownButtonHideUnderline(
    child: DropdownButtonFormField<Warehouse>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) => value == null ? 'Please select this field' : null,
      // viewModel.wareHouseName == null ? 'Please select this field' : null,
      value: viewModel.warehouseInfo,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
      ),
      elevation: 16,
      isExpanded: true,
      iconSize: 30.h,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
      hint: Text(
          // viewModel.wareHouseName!,
          'Select',
          style: TextStyle(
              color: const Color(0xff858D93),
              fontWeight: FontWeight.w400,
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == 'phone' ? 15 : 25)),
      onChanged: (Warehouse? warehouseInfo) {
        viewModel.warehouseInfo = warehouseInfo;
      },
      items: viewModel.warehousetList.map((item) {
        return DropdownMenuItem<Warehouse>(
            value: item,
            child: Text(
              item.name!,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == 'phone' ? 14 : 24),
            ));
      }).toList(),
    ),
  );
}

void _show(BuildContext ctx, ExtraViewModel viewModel) {
  showCupertinoModalPopup(
      context: ctx,
      builder: (_) => CupertinoActionSheet(
          title: Text("Select Source",
              style: TextStyle(
                fontFamily: 'Raleway',
                letterSpacing: -0.33,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: Globlas.deviceType == "phone" ? 15 : 25,
              )),
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  _getFromGallery(viewModel);
                  //_close(ctx, viewModel);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Icon(Icons.photo, size: 30.h, color: Colors.grey.shade500),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text("Choose from library",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          letterSpacing: -0.33,
                          fontStyle: FontStyle.normal,
                          color: const Color(0xff33A3E4),
                          fontSize: Globlas.deviceType == "phone" ? 15 : 25,
                        )),
                  ],
                )),
            CupertinoActionSheetAction(
              onPressed: () {
                _getFromCamera(viewModel);
                // _close(ctx, viewModel);
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(
                    Icons.camera,
                    size: 30.h,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text("Take a photo",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        letterSpacing: -0.33,
                        fontStyle: FontStyle.normal,
                        color: const Color(0xff33A3E4),
                        fontSize: Globlas.deviceType == "phone" ? 15 : 25,
                      ))
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () => _close(ctx, viewModel),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  letterSpacing: -0.33,
                  fontStyle: FontStyle.normal,
                  color: const Color(0xff33A3E4),
                  fontSize: Globlas.deviceType == "phone" ? 15 : 25,
                ),
              ))));
}

Widget purchessContent(text) => Text(text,
    style: TextStyle(
        color: const Color(0xff36393C),
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        fontSize: Globlas.deviceType == 'phone' ? 15 : 25));

/// Get from gallery
_getFromGallery(ExtraViewModel viewModel) async {
  viewModel.navigationService.back();
  final ImagePicker imagePicker = ImagePicker();
  File file;
  XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front);
  if (image != null) {
    file = File(image!.path);
    viewModel.imageFile = image.path;
  }
}

/// Get from Camera
_getFromCamera(ExtraViewModel viewModel) async {
  viewModel.navigationService.back();
  final ImagePicker imagePicker = ImagePicker();

  XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front);

  viewModel.imageFile = image!.path;
}
