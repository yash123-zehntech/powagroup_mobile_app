import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/button_widget.dart';
import 'package:powagroup/helper_widget/end_quantity_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/delivery_view_model.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/contact_info.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/delivery_module/response_model/delivery_info.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/shared_preference.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class DeliveryPage extends StatefulWidget {
  String? value;

  DeliveryPage({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryPage> {
  int? selectedIndex;
  int? selectIndexforbilling;
  int? selectIndexforContact;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeliveryModel>.reactive(
        viewModelBuilder: () => DeliveryModel(),
        onViewModelReady: (viewModel) async {
          bool isConnected = await AppUtil.checkNetwork();
          if (isConnected != null && isConnected) {
            List<ProductData> cartProductList = await AppUtil.getCartList();

            if (cartProductList != null && cartProductList.isNotEmpty) {
              try {
                viewModel.cartProductList = cartProductList;
              } catch (e) {}
              viewModel.addressId = cartProductList[0].id!;
            }

            viewModel.getAddressListForShipping(true);
            viewModel.getAddressListForBilling(true);
            viewModel.getAddressListForContact(true);

            await viewModel.getDeliveyMethodsItems(true);
            await viewModel.getOrderTotal();

            var value = await SharedPre.getStringValue(SharedPre.ISPICKUP);
            if (value == "0") {
              viewModel.isCheckbox = true;
            } else {
              viewModel.isCheckboxBilling = true;
            }
          }
        },
        builder: (context, viewModel, child) => Scaffold(
            bottomNavigationBar: endContant(viewModel),
            backgroundColor: const Color(0xffEFF1F2),
            body:
                // !viewModel.isInvoiceAPICall && !viewModel.isShippingAPICall
                //     ?
                OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                if (connected) {
                  if (!viewModel.isBusy &&
                      viewModel.deliveryAddList.isNotEmpty &&
                      viewModel.deliveryMethodsList.isNotEmpty &&
                      viewModel.invoiceAddList.isNotEmpty &&
                      viewModel.contactAddList.isNotEmpty) {
                    return bodyWiget(viewModel);
                  }
                  return child;
                } else if (!connected) {
                  if (!viewModel.isLocalDBAlreadyCalled &&
                      !viewModel.isLocalDBAlreadyCalledForMethods &&
                      !viewModel.isLocalforInvoiceAlreadyCalled &&
                      !viewModel.isLocalforContactAlreadyCalled) {
                    try {
                      Future.delayed(const Duration(milliseconds: 3), () {
                        viewModel.getLocalDataForDelivery();
                        viewModel.getLoacalDataForInvoice();
                        viewModel.getLoacalDataForContact();
                      });
                    } catch (error) {
                      viewModel.getLocalDataForDelivery();
                      viewModel.getLoacalDataForInvoice();
                      viewModel.getLoacalDataForContact();
                    }
                  }
                  if (viewModel.deliveryAddList.isNotEmpty &&
                      viewModel.deliveryMethodsList.isEmpty &&
                      viewModel.invoiceAddList.isNotEmpty &&
                      viewModel.contactAddList.isNotEmpty) {
                    return bodyWiget(viewModel);
                  } else {
                    return NetworkError(
                      content: 'Network Error',
                      subContant: 'The network connection is lost',
                      icon: 'assets/icon/mobile_network_error.png',
                      viewModel: viewModel,
                    );
                  }
                }
                return child;
              },
              builder: ((context) {
                return bodyWiget(viewModel);
              }),
              child: child,
            )));
  }

  Widget createAddress(viewModel) {
    return InkWell(
      onTap: () {
        viewModel.onAddNewAddressClick(context);
      },
      child: Container(
        child: Text("Create Delivery Address",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
              fontSize: Globlas.deviceType == "phone" ? 16 : 26,
              color: const Color(0xff33A3E4),
            )),
      ),
    );
  }

  Widget endContant(DeliveryModel viewModel) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: viewModel.invoiceAddList.isEmpty &&
                    viewModel.deliveryAddList.isEmpty &&
                    viewModel.contactAddList.isEmpty
                ? Container()
                : commentSectionPriceWidget2("", viewModel, 'Next', '\$'),
          )
        ],
      );

  commentSectionPriceWidget2(
      sale_uom, DeliveryModel viewModel, title, productTotalAmount) {
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
              priceColumnWidget(
                  'Total Amounts',
                  viewModel.showLoaderForOrderTotal != null &&
                          viewModel.showLoaderForOrderTotal
                      ? ''
                      : '\$${(viewModel.getOrderTotalsResponse!.itemTotalEx! + viewModel.getOrderTotalsResponse!.deliveryEx! + viewModel.getOrderTotalsResponse!.totalTax!).toStringAsFixed(2)}',
                  viewModel),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () async {
                    var value =
                        await SharedPre.getStringValue(SharedPre.ISPICKUP);
                    if (value == "0") {
                      viewModel.isCheckbox = true;
                      if (viewModel.deliveryAddList
                              .any((element) => element.selected == true) &&
                          viewModel.invoiceAddList.any((element) =>
                              element.selectedForBilling == true)) {
                        viewModel.onNextButtonClick(context);
                      } else {
                        AppUtil.showSnackBar('Please select Shipping address');
                      }
                    } else {
                      viewModel.isCheckboxBilling = true;
                      viewModel.onNextButtonClick(context);
                    }
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

  Widget headContant(text) => Text(
        text,
        style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w700,
            fontSize: Globlas.deviceType == 'phone' ? 16 : 26),
      );

  Widget billingAddressCard(int index, DeliveryModel viewModel) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Icon(
                        PowaGroupIcon.company,
                        size: 20.h,
                        color: const Color(0xff858D93),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        viewModel.invoiceAddList.isNotEmpty &&
                                viewModel.invoiceAddList[index].name != null &&
                                viewModel.invoiceAddList[index].name!.isNotEmpty
                            ? viewModel.invoiceAddList[index].name.toString()
                            : '',
                        style: TextStyle(
                            color: const Color(0xff36393C),
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            fontSize: Globlas.deviceType == 'phone' ? 12 : 22),
                      ),
                    ],
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      viewModel.onEditAddressInvoiceClick(
                          context, viewModel.invoiceAddList[index]);
                    },
                    icon: Icon(
                      PowaGroupIcon.edit_icon,
                      color: const Color(0xff858D93),
                      size: 16.h,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Text(
                      viewModel.invoiceAddList[index].completeAddress != null &&
                              viewModel.invoiceAddList[index].completeAddress!
                                  .isNotEmpty
                          ? viewModel.invoiceAddList[index].completeAddress!
                          : '',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.33,
                          color: const Color(0xff36393C)),
                    ),
                  ),
                ),
              ])
            ]));
  }

  Widget shippingAddressCard(DeliveryModel viewModel, index) {
    return InkWell(
      onTap: () {
        viewModel.updateLocalDatabase(viewModel.deliveryAddList[index]);
      },
      child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        circleContainers(viewModel.deliveryAddList, viewModel,
                            context, index),
                        const SizedBox(width: 15),
                        Icon(PowaGroupIcon.company,
                            size: 20.h, color: const Color(0xff858D93)),
                        const SizedBox(width: 10),
                        Text(
                          viewModel.deliveryAddList[index].name != null &&
                                  viewModel
                                      .deliveryAddList[index].name!.isNotEmpty
                              ? viewModel.deliveryAddList[index].name!
                              : '',
                          style: TextStyle(
                              color: const Color(0xff36393C),
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  Globlas.deviceType == 'phone' ? 12 : 22),
                        ),
                      ],
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        viewModel.onEditAddressClick(
                            context, viewModel.deliveryAddList[index]);
                      },
                      icon: Icon(
                        PowaGroupIcon.edit_icon,
                        color: const Color(0xff858D93),
                        size: 16.h,
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        viewModel.deliveryAddList[index].completeAddress !=
                                    null &&
                                viewModel.deliveryAddList[index]
                                    .completeAddress!.isNotEmpty
                            ? viewModel.deliveryAddList[index].completeAddress!
                            : '',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.33,
                            color: const Color(0xff36393C)),
                      ),
                    ),
                  ),
                ])
              ])),
    );
  }

  Widget contactAddressCard(int index, DeliveryModel viewModel) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      circleContainersforContact(
                          viewModel.contactAddList, viewModel, context, index),
                      const SizedBox(width: 15),
                      Icon(
                        PowaGroupIcon.company,
                        size: 20.h,
                        color: const Color(0xff858D93),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        viewModel.contactAddList.isNotEmpty &&
                                viewModel.contactAddList[index].name != null &&
                                viewModel.contactAddList[index].name!.isNotEmpty
                            ? viewModel.contactAddList[index].name.toString()
                            : '',
                        style: TextStyle(
                            color: const Color(0xff36393C),
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                            fontSize: Globlas.deviceType == 'phone' ? 12 : 22),
                      ),
                    ],
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      viewModel.onEditAddressContactClick(
                          context, viewModel.contactAddList[index]);
                    },
                    icon: Icon(
                      PowaGroupIcon.edit_icon,
                      color: const Color(0xff858D93),
                      size: 16.h,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Text(
                      viewModel.contactAddList[index].completeAddress != null &&
                              viewModel.contactAddList[index].completeAddress!
                                  .isNotEmpty
                          ? viewModel.contactAddList[index].completeAddress!
                          : '',
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.33,
                          color: const Color(0xff36393C)),
                    ),
                  ),
                ),
              ])
            ]));
  }

  Widget maincircleContainers(
          BuildContext context, DeliveryModel viewModel, index, list) =>
      InkWell(
        onTap: () async {
          viewModel.isCheckbox = !viewModel.isCheckbox;
          viewModel.isCheckboxBilling = false;

          if (list.length > 0) {
            viewModel.updateLocalDatabaseForMethods(list, viewModel.isCheckbox);
            await viewModel.setPickup("0");
          }
        },
        child: Container(
            height: 17.h,
            width: 17.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: const Color(0xff858D93)),
            ),
            child: viewModel.isCheckbox
                ? Icon(
                    PowaGroupIcon.circle1,
                    color: viewModel.isCheckbox
                        ? const Color(0xffD60505)
                        : Colors.white,
                    size: 12.h,
                  )
                : Container()),
      );

  Widget circleContainers(List<DeliveryInfo> list, DeliveryModel viewModel,
          BuildContext context, index) =>
      InkWell(
        onTap: () {
          viewModel.updateLocalDatabase(list[index]);
        },
        child: Container(
            height: 17.h,
            width: 17.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(width: 1, color: const Color(0xff858D93)),
            ),
            child: selectedIndex == index || list[index].selected == true
                ? Icon(
                    PowaGroupIcon.circle1,
                    color:
                        selectedIndex == index || list[index].selected == true
                            ? const Color(0xffD60505)
                            : Colors.white,
                    size: 12.h,
                  )
                : Container()),
      );

  Widget circleContainersforbilling(
      DeliveryModel viewModel, BuildContext context, list, index) {
    return InkWell(
      onTap: () async {
        viewModel.isCheckbox = false;

        viewModel.isCheckboxBilling = !viewModel.isCheckboxBilling;
        viewModel.updateLocalDatabaseForMethods(
            list, viewModel.isCheckboxBilling);
        await viewModel.setPickup("1");
      },
      child: Container(
          height: 17.h,
          width: 17.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 1, color: const Color(0xff858D93)),
          ),
          child: viewModel.isCheckboxBilling
              ? Icon(
                  PowaGroupIcon.circle1,
                  color: viewModel.isCheckboxBilling
                      ? const Color(0xffD60505)
                      : Colors.white,
                  size: 12.h,
                )
              : Container()),
    );
  }

  Widget circleContainersforContact(List<ContactInfo> list,
      DeliveryModel viewModel, BuildContext context, index) {
    return InkWell(
      onTap: () {
        viewModel.updateLocalDatabaseforContact(list[index]);
      },
      child: Container(
          height: 17.h,
          width: 17.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
            border: Border.all(width: 1, color: const Color(0xff858D93)),
          ),
          child: selectIndexforContact == index || list[index].selected == true
              ? Icon(
                  PowaGroupIcon.circle1,
                  color: selectIndexforContact == index ||
                          list[index].selected == true
                      ? const Color(0xffD60505)
                      : Colors.white,
                  size: 12.h,
                )
              : Container()),
    );
  }

  Widget bodyWiget(DeliveryModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            viewModel.invoiceAddList.isNotEmpty
                ? SizedBox(
                    height: 10.h,
                  )
                : Container(
                    height: 0,
                    width: 0,
                  ),
            viewModel.deliveryAddList.isEmpty
                ? Container()
                : headContant("Choose a delivery method"),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: maincircleContainers(
                      context, viewModel, 0, viewModel.deliveryMethodsList),
                ),
                Expanded(
                    child: viewModel.isDeliveryMethods
                        ? ShimmerLoading(
                            isLoading: true,
                            child: Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                            ))
                        : viewModel.deliveryMethodsList.isEmpty
                            ? Container()
                            : Text(
                                viewModel.deliveryMethodsList != null &&
                                        viewModel.deliveryMethodsList[0].name !=
                                            null
                                    ? viewModel.deliveryMethodsList[0].name
                                        .toString()
                                    : "",
                                style: TextStyle(
                                    color: const Color(0xff1B1D1E),
                                    fontSize:
                                        Globlas.deviceType == 'phone' ? 12 : 22,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400),
                              )),
                viewModel.isDeliveryMethods
                    ? Container()
                    : viewModel.deliveryMethodsList.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(4),
                              color: const Color(0xffD60505),
                              child: Text(
                                viewModel.deliveryMethodsList != null &&
                                        viewModel.deliveryMethodsList[0]
                                                .deliveryEx !=
                                            null
                                    ? "\$ ${viewModel.deliveryMethodsList[0].deliveryEx.toStringAsFixed(2)}"
                                    : "",
                                style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontSize: Globlas.deviceType == 'phone'
                                        ? 12.sp
                                        : 12.sp,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            !viewModel.isCheckboxBilling
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.isShippingAPICall
                        ? 2
                        : viewModel.deliveryAddList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Slidable(
                            key: ValueKey(index),
                            closeOnScroll: false,
                            endActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: const Color(0xffD60505),
                                  icon: PowaGroupIcon.delete,
                                  onPressed: (BuildContext context) {
                                    viewModel.deleteAddress(
                                        viewModel.deliveryAddList[index]);
                                  },
                                ),
                              ],
                            ),
                            child: viewModel.isShippingAPICall
                                ? ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      width: double.infinity,
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100],
                                      ),
                                    ))
                                : shippingAddressCard(viewModel, index)),
                      );
                    })
                : Container(),
            viewModel.isCheckbox ? createAddress(viewModel) : Container(),
            Divider(),
            viewModel.deliveryMethodsList.length > 1
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: circleContainersforbilling(viewModel,
                                context, viewModel.deliveryMethodsList, 1),
                          ),
                          Expanded(
                            child: viewModel.isDeliveryMethods
                                ? ShimmerLoading(
                                    isLoading: true,
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100],
                                      ),
                                    ))
                                : viewModel.isDeliveryMethods &&
                                        viewModel.deliveryMethodsList.isEmpty
                                    ? Container()
                                    : Text(
                                        viewModel.deliveryMethodsList != null &&
                                                viewModel.deliveryMethodsList[1]
                                                        .name !=
                                                    null
                                            ? viewModel
                                                .deliveryMethodsList[1].name
                                                .toString()
                                            : "",
                                        style: TextStyle(
                                            color: const Color(0xff1B1D1E),
                                            fontSize:
                                                Globlas.deviceType == 'phone'
                                                    ? 12
                                                    : 22,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w400),
                                      ),
                          ),
                          viewModel.isDeliveryMethods
                              ? Container()
                              : viewModel.deliveryMethodsList.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        color: const Color(0xffD60505),
                                        child: Text(
                                          viewModel.deliveryMethodsList !=
                                                      null &&
                                                  viewModel
                                                          .deliveryMethodsList[
                                                              1]
                                                          .deliveryEx !=
                                                      null
                                              ? viewModel.deliveryMethodsList[1]
                                                          .deliveryEx
                                                          .toString() ==
                                                      '0'
                                                  ? "\$ 0.00"
                                                  : "\$ ${viewModel.deliveryMethodsList[1].deliveryEx.toString()}"
                                              : "",
                                          style: TextStyle(
                                              color: const Color(0xffffffff),
                                              fontSize:
                                                  Globlas.deviceType == 'phone'
                                                      ? 12.sp
                                                      : 12.sp,
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: viewModel.isDeliveryMethods &&
                                viewModel.deliveryMethodsList.length == 0
                            ? ShimmerLoading(
                                isLoading: true,
                                child: Container(
                                  width: double.infinity,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[100],
                                  ),
                                ))
                            : viewModel.deliveryMethodsList.isEmpty
                                ? Container()
                                : Text(
                                    viewModel.deliveryMethodsList != null &&
                                            viewModel.deliveryMethodsList[1]
                                                    .description !=
                                                null &&
                                            viewModel.deliveryMethodsList[1]
                                                .description!.isNotEmpty
                                        ? viewModel
                                            .deliveryMethodsList[1].description
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        color: const Color(0xff1B1D1E),
                                        fontSize: Globlas.deviceType == 'phone'
                                            ? 13
                                            : 22,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w400),
                                  ),
                      ),
                    ],
                  )
                : Container()
          ],
        )),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
