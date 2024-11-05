import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:powagroup/custom_fonts/powa_group_icon_icons.dart';
import 'package:powagroup/helper_widget/end_card_widget.dart';
import 'package:powagroup/helper_widget/network_error%20widget.dart';
import 'package:powagroup/helper_widget/shimmer_loading.dart';
import 'package:powagroup/ui/screen/modules/all_cart_module/confirm_order_module/confirmorder_view_modal.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_hive_model.dart';
import 'package:powagroup/ui/screen/modules/home_module/product_subcategory_item_module/response_model/product_subcategory_response.dart';
import 'package:powagroup/util/globleData.dart';
import 'package:powagroup/util/util.dart';
import 'package:stacked/stacked.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({Key? key}) : super(key: key);

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmOrderModal>.reactive(
        viewModelBuilder: () => ConfirmOrderModal(),
        onViewModelReady: (viewModel) async {
          viewModel.getUserData();
          List<ProductData> cartProductList = await AppUtil.getCartList();

          if (cartProductList != null && cartProductList.isNotEmpty) {
            viewModel.cartProductList = cartProductList;
          }

          viewModel.getDeliveryList();
          await viewModel.getDeliveyMethodsItems(true);
          await viewModel.getOrderTotal();
          viewModel.getInvoiceList();
          viewModel.getPickUpType();
          viewModel.notifyListeners();
        },
        // ignore: unrelated_type_equality_checks
        builder: (context, viewModel, child) => Scaffold(
              backgroundColor: const Color(0xffEFF1F2),
              body: Column(children: [
                viewModel.cartProductList != null &&
                        viewModel.cartProductList.isNotEmpty
                    ? Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 50),
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: viewModel.cartProductList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12.0,
                                        ),
                                        child: Slidable(
                                          key: ValueKey(index),
                                          closeOnScroll: false,
                                          endActionPane: ActionPane(
                                            extentRatio: 0.2,
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                backgroundColor:
                                                    const Color(0xffD60505),
                                                icon: PowaGroupIcon.delete,
                                                onPressed:
                                                    (BuildContext context) {
                                                  viewModel.deleteProduct(
                                                      viewModel.cartProductList[
                                                          index],
                                                      viewModel,
                                                      context);
                                                },
                                              ),
                                            ],
                                          ),
                                          child: productContainer(
                                              index, viewModel),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  height: 12,
                                ),
                                priceDetailWidget(viewModel),
                                const SizedBox(
                                  height: 12,
                                ),
                                commentSectionWidget(viewModel),
                                const SizedBox(
                                  height: 60,
                                ),
                                commentSectionPriceWidget(
                                    "",
                                    viewModel,
                                    'Proceed To Pay',
                                    'ConfirmOrderPage',
                                    viewModel.showLoaderForOrderTotal != null &&
                                            viewModel.showLoaderForOrderTotal
                                        ? ''
                                        : '\$${(viewModel.getOrderTotalsResponse!.itemTotalEx! + viewModel.getOrderTotalsResponse!.deliveryEx! + viewModel.getOrderTotalsResponse!.totalTax!).toStringAsFixed(2)}',
                                    viewModel.userDetails)
                              ]),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.h, right: 16.h),
                          child: NetworkError(
                            content: 'Your cart is empty!',
                            subContant:
                                "Looks like you haven't added anything to your cart yet",
                            icon: 'assets/icon/network_error.png',
                            viewModel: viewModel,
                          ),
                        ),
                      ),
              ]),
            ));
  }

  Widget productContainer(index, ConfirmOrderModal viewModal) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          // "khushi",
                          viewModal.cartProductList[index].name != null &&
                                  viewModal
                                      .cartProductList[index].name!.isNotEmpty
                              ? viewModal.cartProductList[index].name!
                              : '',
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: Globlas.deviceType == "phone" ? 18 : 28,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.33,
                              color: const Color(0xff1B1D1E)),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "Kjjjhv",
                            viewModal.cartProductList[index].sku != null
                                ? 'Code : ${viewModal.cartProductList[index].sku}'
                                : '',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize:
                                    Globlas.deviceType == "phone" ? 14 : 24,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.33,
                                color: const Color(0xff36393C)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: viewModal.cartProductList[index]
                                              .priceUntaxed !=
                                          null
                                      ? '\$${viewModal.cartProductList[index].priceUntaxed!.toStringAsFixed(2)}'
                                      : '',
                                  // text: "yee",
                                  // viewModal.cartProductList[index]
                                  //         .qtyBreaks!.isNotEmpty
                                  //     ? viewModal.cartProductList[index]
                                  //                 .priceByQty !=
                                  //             null
                                  //         ? "\$${viewModal.cartProductList[index].priceByQty.toString()}"
                                  //         : ''
                                  //     : viewModal.cartProductList[index].price
                                  //         .toString(),
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    letterSpacing: -0.33,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: const Color(0xff1B1D1E),
                                    fontSize:
                                        Globlas.deviceType == "phone" ? 20 : 30,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "  Per Unit",
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontSize:
                                                Globlas.deviceType == "phone"
                                                    ? 10
                                                    : 20,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.33,
                                            color: const Color(0xff36393C)))
                                  ]),
                            ),
                            Container(
                              height: 32.h,
                              width: 120.w,
                              padding: const EdgeInsets.only(left: 8, right: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 0.4,
                                  color:
                                      const Color(0xff858D93).withOpacity(0.5),
                                  style: BorderStyle.solid,
                                ), // inner circle color
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Qty : ',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: Globlas.deviceType == "phone"
                                            ? 14
                                            : 24,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.33,
                                        color: const Color(0xff858D93),
                                      )),
                                  Container(
                                    height: 25.h,
                                    width: 20.w,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        viewModal.cartProductList[index]
                                            .yashValue = value;

                                        viewModal.debouncer.run(() async {
                                          viewModal.updateControllerValue(
                                              index,
                                              viewModal.cartProductList[index]
                                                  .yashValue,
                                              AppUtil.getQtyPriceByMultiply(
                                                  viewModal
                                                      .cartProductList[index]
                                                      .yashValue!,
                                                  viewModal
                                                      .cartProductList[index]
                                                      .qtyBreaks!));

                                          await viewModal
                                              .getDeliveyMethodsItems(false);

                                          await viewModal.getOrderTotal();

                                          viewModal.notifyListeners();
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        });
                                      },
                                      onTap: () {
                                        viewModal.cartProductList[index]
                                            .controllerForCart!
                                            .clear();
                                      },
                                      cursorColor: Colors.black,
                                      controller: viewModal
                                          .cartProductList[index]
                                          .controllerForCart,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              Globlas.deviceType == "phone"
                                                  ? 18
                                                  : 28,
                                          color: const Color(0xff36393C),
                                          letterSpacing: -0.33),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints.expand(
                                        height: 20, width: 20),
                                    child: PopupMenuButton<QtyBreak>(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(0),
                                      tooltip: "",
                                      iconSize: 20,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      splashRadius: 12,
                                      itemBuilder: (BuildContext context) {
                                        return viewModal
                                            .cartProductList[index].qtyBreaks!
                                            .map((QtyBreak choice) {
                                          return PopupMenuItem<QtyBreak>(
                                            onTap: () async {
                                              viewModal.updateControllerValue(
                                                  index,
                                                  choice.qty,
                                                  choice.price);

                                              await viewModal
                                                  .getDeliveyMethodsItems(
                                                      false);

                                              await viewModal.getOrderTotal();

                                              viewModal.notifyListeners();
                                            },
                                            value: choice,
                                            child: Container(
                                                width: 20.w,
                                                child: Text(
                                                    //choice.qty.toString()
                                                    AppUtil.getQTYValueForMenu(
                                                        choice.qty
                                                            .toString()))),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () {
                viewModal.deleteProduct(
                    viewModal.cartProductList[index], viewModal, context);
              },
              icon: Icon(PowaGroupIcon.delete,
                  size: 22.h, color: const Color(0xff36393C))),
        ],
      ),
    );
  }

  Widget priceDetailWidget(ConfirmOrderModal viewModel) {
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Price Details',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.33,
                  color: const Color(0xff1B1D1E)),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget('Item Total'),
                  const SizedBox(
                    height: 16,
                  ),
                  titleWidget('Delivery Charges'),
                  const SizedBox(
                    height: 16,
                  ),
                  titleWidget('Excluding GST'),
                  const SizedBox(
                    height: 16,
                  ),
                  titleWidget('GST'),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      : priceWidget(
                          '\$${viewModel.getOrderTotalsResponse!.itemTotalEx!.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 16,
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
                      : priceWidget(
                          '\$${viewModel.getOrderTotalsResponse!.deliveryEx!.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 16,
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
                      : priceWidget(
                          '\$${(viewModel.getOrderTotalsResponse!.itemTotalEx! + viewModel.getOrderTotalsResponse!.deliveryEx!).toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 16,
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
                      : priceWidget(
                          '\$${viewModel.getOrderTotalsResponse!.totalTax!.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 1,
            color: Color(0xff858D93),
          ),
          const SizedBox(
            height: 16,
          ),
          priceRowWidget(
              "Total Amount",
              viewModel.showLoaderForOrderTotal != null &&
                      viewModel.showLoaderForOrderTotal
                  ? ''
                  : '\$${(viewModel.getOrderTotalsResponse!.itemTotalEx! + viewModel.getOrderTotalsResponse!.deliveryEx! + viewModel.getOrderTotalsResponse!.totalTax!).toStringAsFixed(2)}',
              viewModel)
        ],
      ),
    );
  }

  Widget priceWidget(String price) {
    return Text(
      price,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 16 : 26,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.33,
          color: const Color(0xff000000)),
    );
  }

  // Return Price Row Widget
  Widget priceRowWidget(
      String name, String price, ConfirmOrderModal viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Globlas.deviceType == "phone" ? 16 : 26,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.33,
              color: const Color(0xff000000)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: viewModel.showLoaderForOrderTotal != null &&
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
                      color: name == "Total Pay"
                          ? const Color(0xff33A3E4)
                          : const Color(0xff000000)),
                ),
        )
      ],
    );
  }

  // Widget commentSectionWidgetforPrice(ConfirmOrderModal viewModel) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.white,
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         InkWell(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               priceColumnWidget('Total Amount', '\$152.00'),
  //               ButtonWidget(
  //                 buttonTitle: 'Proceed To Pay',
  //                 containerWidth: 130.0.h,
  //                 containerHeigth: 48.h,
  //               ),
  //             ],
  //           ),
  //           onTap: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Return Comment Section Widget
  Widget commentSectionWidget(ConfirmOrderModal viewModel) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Address',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.33,
                    color: const Color(0xff1B1D1E)),
              ),
              InkWell(
                child: Text(
                  'Edit Address',
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: Globlas.deviceType == "phone" ? 16 : 26,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.33,
                      color: const Color(0xffD60505)),
                ),
                onTap: () {
                  // viewModel.onNextButtonClick();
                  viewModel.onEditAddressClick(
                      context, viewModel.shippingAddressList[0]);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Text(
          //       'Billing Address:',
          //       style: TextStyle(
          //           fontFamily: 'Inter-Regular',
          //           fontSize: Globlas.deviceType == "phone" ? 14 : 24,
          //           fontStyle: FontStyle.normal,
          //           fontWeight: FontWeight.w400,
          //           letterSpacing: -0.33,
          //           color: const Color(0xff858D93)),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          // titleWidget(viewModel.billingAddressList.isEmpty ||
          //         viewModel.billingAddressList == null
          //     ? 'Lorem ipsum is a placeholder text commonly'
          //     : viewModel.billingAddressList[0].completeAddress.toString()),
          // const SizedBox(
          //   height: 10,
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Shipping Address:',
                style: TextStyle(
                    fontFamily: 'Inter-Regular',
                    fontSize: Globlas.deviceType == "phone" ? 14 : 24,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.33,
                    color: const Color(0xff858D93)),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),

          titleWidget(viewModel.shippingAddressList.isEmpty
              ? 'Pickup'
              // 'Lorem ipsum is a placeholder text commonly'
              :
              // !viewModel.isPickup
              //     ? "Pickup"

              // :
              viewModel.shippingAddressList[0].completeAddress.toString()),
        ],
      ),
    );
  }

  Widget titleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: Globlas.deviceType == "phone" ? 14 : 24,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.33,
          color: const Color(0xff000000)),
    );
  }

  Widget priceColumnWidget(String name, String price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Text(
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
          ),
        )
      ],
    );
  }
}
