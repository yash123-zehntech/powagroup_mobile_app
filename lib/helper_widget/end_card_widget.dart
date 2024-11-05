import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:powagroup/app/locator.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/provider/payment_provider.dart';
import 'package:powagroup/request_model/create_order_request.dart';
import 'package:powagroup/services/api.dart';
import 'package:powagroup/services/hive_db_services.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/invoice_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/extra_info_module/response_model/extra_info_response.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/response_model/create_order_response.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/user_module/profile/response_model.dart/user_profile_model.dart';
import 'package:powagroup/util/constant.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:provider/provider.dart';
import '../ui/screen/modules/all_cart_module/confirm_order_module/confirmorder_view_modal.dart';
import '../ui/screen/modules/all_cart_module/model/dropdownlist.dart';
import '../util/app_data.dart';
import '../util/shared_preference.dart';

Widget commentSectionPriceWidget(sale_uom, viewModel, title, screenName,
    productTotalAmount, UserObject? userDetails) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sale_uom == null && sale_uom.isEmpty
            ? Text(
                sale_uom == null || sale_uom.isEmpty ? "" : "per $sale_uom",
                style: TextStyle(
                    fontFamily: 'Inter-Medium',
                    fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.33,
                    color: const Color(0xff000000)),
              )
            : Container(
                height: 0,
                width: 0,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title == 'Checkout' || title == "Add To Truck"
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.r),
                      border: Border.all(
                        width: 0.4.w,
                        color: const Color(0xff36393C),
                        style: BorderStyle.solid,
                      ), // inner circle color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 8.w,
                        ),
                        Text('Qty:',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 20 : 30,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.33,
                              color: const Color(0xff36393C),
                            )),
                        Container(
                          height: 20.h,
                          width: 20.w,
                          child: TextField(
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints.expand(
                              height: 28, width: 28),
                          child: PopupMenuButton<DropDownList>(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(0),
                            tooltip: "1",
                            iconSize: 20,
                            icon: const Icon(Icons.arrow_drop_down),
                            splashRadius: 12,
                            itemBuilder: (BuildContext context) {
                              return ConfirmOrderModal.act
                                  .map((DropDownList choice) {
                                return PopupMenuItem<DropDownList>(
                                  onTap: () {},
                                  value: choice,
                                  child: Container(
                                      width: 20.w, child: Text(choice.name)),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : priceColumnWidget(
                    'Total Amounts', productTotalAmount, viewModel),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: title == "Proceed To Pay"
                  ? InkWell(
                      child: ButtonWidget(
                        isBusy: viewModel.isBusy,
                        buttonTitle: title,
                        containerWidth: 130.0.w,
                        containerHeigth: 48.h,
                      ),
                      onTap: () async {
                        if (userDetails != null) {
                          callStripePayment(
                              viewModel, userDetails, productTotalAmount);
                        } else {
                          callStripePayment(
                              viewModel, userDetails, productTotalAmount);
                        }
                      },
                    )
                  : InkWell(
                      onTap: () {
                        title == 'Next' && screenName == 'ReviewPage'
                            ? viewModel.onNextButtonClick()
                            : title == 'Next' && screenName == 'ExtraInfoView'
                                ? viewModel.onNextButtonClick()
                                : title == 'Checkout' || title == 'Add To Truck'
                                    ? viewModel.onCheckoutButtonClick()
                                    : Container();
                      },
                      child: ButtonWidget(
                        isBusy: viewModel.isBusy,
                        buttonTitle: title,
                        containerWidth: 130.0.w,
                        containerHeigth: 48.h,
                      ),
                    ),
            ),
          ],
        ),
      ],
    ),
  );
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

void showModal(
    BuildContext context,
    ConfirmOrderModal viewModel,
    UserObject? userDetails,
    paymentMethodsList,
    CreateOrderResponse response,
    productTotalAmount) {
  showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStatecheck) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 450.h,
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    )),
                alignment: Alignment.topCenter,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.h, right: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Select Payment Type",
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                letterSpacing: -0.33,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize:
                                    Globlas.deviceType == "phone" ? 18 : 25,
                              )),
                        ],
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        itemCount: paymentMethodsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: InkWell(
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 9.0),
                                            child: Container(
                                              height: 20.h,
                                              width: 20.h,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: paymentMethodsList[
                                                                  index]
                                                              .name ==
                                                          viewModel
                                                              .getIndexOFlist
                                                      ? const Color(0xFFD60505)
                                                      : const Color(0xff858D93),
                                                  width: 1,
                                                ),
                                                color: paymentMethodsList[index]
                                                            .name ==
                                                        viewModel.getIndexOFlist
                                                    ? const Color(0xFFD60505)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Icon(Icons.check,
                                                  color: Colors.white,
                                                  size: 16.h),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 9.0,
                                                ),
                                                child: Text(
                                                    paymentMethodsList[index]
                                                        .name,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        letterSpacing: -0.33,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: const Color(
                                                            0xff000000),
                                                        fontSize:
                                                            Globlas.deviceType ==
                                                                    "phone"
                                                                ? 16
                                                                : 28)),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 9.0,
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: 'PLEASE NOTE: ',
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xff1B1D1E),
                                                          fontSize:
                                                              Globlas.deviceType ==
                                                                      'phone'
                                                                  ? 13
                                                                  : 26,
                                                          fontFamily: 'Raleway',
                                                          letterSpacing: -0.33,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              "We will contact you if further delivery charges apply for Bulky items.",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  Globlas.deviceType ==
                                                                          'phone'
                                                                      ? 13
                                                                      : 26,
                                                              fontFamily:
                                                                  'Raleway',
                                                              letterSpacing:
                                                                  -0.33,
                                                              color: const Color(
                                                                  0xff000000)),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  viewModel.getIndexOFlist =
                                      paymentMethodsList[index].name;
                                  viewModel.paymentMethodId =
                                      paymentMethodsList[index].id;
                                  viewModel.paymentType =
                                      paymentMethodsList[index].type;
                                  setStatecheck(() {});
                                  viewModel.notifyListeners();
                                }),
                          );
                        }),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);

                  if (viewModel.paymentType == "stripe") {
                    PaymentProvider paymentProvider = PaymentProvider();
                    PaymentIntent? paymentSuccessInformation =
                        await paymentProvider.makePayment(
                            amount: double.parse(
                                productTotalAmount.replaceAll("\$", "")),
                            currency: 'AUD');

                    if (paymentSuccessInformation != null) {
                      callPaymentStoreAPI(
                          paymentSuccessInformation.id,
                          double.parse(productTotalAmount.replaceAll("\$", "")),
                          viewModel,
                          response.result!.id,
                          viewModel.paymentMethodId);
                    }
                  } else {
                    callPaymentStoreAPI(
                        "",
                        double.parse(productTotalAmount.replaceAll("\$", "")),
                        viewModel,
                        response.result!.id,
                        viewModel.paymentMethodId);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        letterSpacing: -0.33,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff33A3E4),
                        fontSize: Globlas.deviceType == "phone" ? 18 : 25,
                      )),
                ),
              )
            ],
          );
        });
      });
}

// call Stripe payment option
void callStripePayment(
    viewModel, UserObject? userDetails, productTotalAmount) async {
  CreateOrderResponse? response =
      await callCreateOrderAPI(viewModel, userDetails);

  if (response != null) {
    if (response.result != null &&
        response.result!.paymentMethods != null &&
        response.result!.paymentMethods!.isNotEmpty) {
      viewModel.getIndexOFlist = response.result!.paymentMethods![0].name;
      viewModel.paymentMethodId = response.result!.paymentMethods![0].id;
      viewModel.paymentType = response.result!.paymentMethods![0].type;
    }
    showModal(AppUtil.getContext(), viewModel, userDetails,
        response.result!.paymentMethods, response, productTotalAmount);
  }
}

Widget priceColumnWidget(String name, String price, viewModel) {
  return Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            name,
            style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w300,
                letterSpacing: -0.33,
                color: const Color(0xff000000)),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        viewModel.showLoaderForOrderTotal != null &&
                viewModel.showLoaderForOrderTotal
            ? ShimmerLoading(
                isLoading: true,
                child: Container(
                  width: 70,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(6)),
                ))
            : Text(
                price,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: name == "Total Pay"
                        ? Globlas.deviceType == "phone"
                            ? 18
                            : 28
                        : Globlas.deviceType == "phone"
                            ? 14
                            : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.33,
                    color: const Color(0xff000000)),
              )
      ],
    ),
  );
}

// call Create order API
Future<CreateOrderResponse?> callCreateOrderAPI(
    viewModel, UserObject? userDetails) async {
  // Map Request object
  viewModel.setBusy(true);
  Api apiCall = locator<Api>();
  CreateOrderRequest mapRequest =
      CreateOrderRequest(list: List.empty(growable: true));

  // Get Cart Product List
  List<ProductData> cartProductList = await AppUtil.getCartList();

  if (cartProductList.isNotEmpty) {
    cartProductList.forEach((element) {
      mapRequest.list!.add(CartProduct(
          id: element.id,
          quantity: int.parse(element.yashValue!.contains(".0")
              ? element.yashValue!.replaceAll(".0", "")
              : element.yashValue!)));
    });
  }

  // Get Shipping Address list
  List<DeliveryInfo> shippingAddressList = await AppUtil.getDeliveryList();

  var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);

  if (shippingAddressList.isNotEmpty && shippingAddressList != []) {
    if (value == '0') {
      DeliveryInfo addressData =
          shippingAddressList.firstWhere((element) => element.selected!);
      mapRequest.shippingAddressId = addressData.id!.toString();
    } else {
      if (userDetails != null && userDetails.partnerId != null)
        mapRequest.shippingAddressId = userDetails.partnerId.toString();
    }
  }

  // Get Billing Address list
  List<InvoiceInfo> invoiceList = await AppUtil.getInvoiceList();

  if (invoiceList.isNotEmpty) {
    InvoiceInfo invoiceData =
        invoiceList.firstWhere((element) => element.selectedForBilling!);
    mapRequest.billingAddressId = invoiceData.id.toString();
  }

  if (invoiceList.isNotEmpty) {
    InvoiceInfo invoiceData =
        invoiceList.firstWhere((element) => element.selectedForBilling!);
    mapRequest.billingAddressId = invoiceData.id.toString();
  }

  mapRequest.deliveryCharges =
      "0"; //AppUtil.getItemDeliveryCharges().toString();

  HiveDbServices<ExtraInfoData> _localDb = HiveDbServices(Constants.extra_info);

  ExtraInfoData? information = await _localDb.get();

  if (information != null) {
    mapRequest.deliveryNotes = information.deliveryNotes!;
    mapRequest.referenceNumber = information.refernceNumber;
    mapRequest.siteContactId = information.id;
    mapRequest.warehouseId = int.parse(information.warehouseId!);
  }

  mapRequest.deliveryMethod = userDetails!.preferredDeliveryMethodId != null &&
          userDetails.preferredDeliveryMethodId.runtimeType != bool
      ? 9
      : 9;

  mapRequest.payOnAccount = viewModel.getIndexOFlist == "Pay by Account"
      ? userDetails.paymentTermName == "EOM + 30" ||
              userDetails.paymentTermName == "Immediate Payment"
          ? true
          : false
      : false;

  // Call API cod
  CreateOrderResponse createOrderResponse =
      await apiCall.proceedToPay(json.encode(mapRequest.toJson()));

  switch (createOrderResponse.statusCode) {
    case Constants.sucessCode:
      return createOrderResponse;
    case Constants.wrongError:
      AppUtil.showDialogbox(AppUtil.getContext(),
          createOrderResponse.error ?? 'Oops Something went wrong');

      break;
    case Constants.networkErroCode:
      AppUtil.showDialogbox(AppUtil.getContext(),
          createOrderResponse.error ?? 'Oops Something went wrong');

      break;
    default:
      {
        if (createOrderResponse.error != null &&
            createOrderResponse.error!.isNotEmpty) {
          AppUtil.showDialogbox(AppUtil.getContext(),
              createOrderResponse.error ?? 'Oops Something went wrong');
        }
      }
      break;
  }
  return null;
}

// Call Payment Store API with transaction Id
callPaymentStoreAPI(String transactionId, double totalAmount, viewModel,
    orderId, PaymentMethodId) async {
  Api apiCall = locator<Api>();
  viewModel.setBusy(true);
  CreateOrderResponse createOrderResponse;

  if (transactionId.isNotEmpty) {
    createOrderResponse = await apiCall.confirmPayment(
        json.encode({
          "payment_txid": transactionId,
          "payment_amount": totalAmount.toStringAsFixed(2),
          'payment_method_id': PaymentMethodId
        }),
        orderId);
  } else {
    createOrderResponse = await apiCall.confirmPayment(
        json.encode({
          "payment_amount": totalAmount.toStringAsFixed(2),
          'payment_method_id': PaymentMethodId
        }),
        orderId);
  }

  print("Create Order response ------- ${createOrderResponse.result}");

  switch (createOrderResponse.statusCode) {
    case Constants.sucessCode:
      AppUtil.showDialogboxforSuccess(AppUtil.getContext(), 'Thank You!',
          'Your Order has been placed successfully', 1);
      Future.delayed(const Duration(seconds: 2), () {
        AppUtil.clearCartData();
        Provider.of<AppData>(AppUtil.getContext(), listen: false)
            .setBedgeCount(0);
      });
      break;
    case Constants.wrongError:
      AppUtil.showDialogbox(AppUtil.getContext(),
          createOrderResponse.error ?? 'Oops Something went wrong');

      break;
    case Constants.networkErroCode:
      AppUtil.showDialogbox(AppUtil.getContext(),
          createOrderResponse.error ?? 'Oops Something went wrong');

      break;
    default:
      {
        if (createOrderResponse.error != null &&
            createOrderResponse.error!.isNotEmpty) {
          AppUtil.showDialogbox(AppUtil.getContext(),
              createOrderResponse.error ?? 'Oops Something went wrong');
        }
      }
      break;
  }

  viewModel.setBusy(false);
}
